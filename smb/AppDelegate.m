//
//  AppDelegate.m
//  smb
//
//  Created by systemp on 2015/11/23.
//  Copyright © 2015年 systemp. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import <IOKit/IOKitLib.h>
#import <DiskArbitration/DiskArbitration.h>
#import <DiskArbitration/DADisk.h>
#import <DiskArbitration/DADissenter.h>
#import <DiskArbitration/DASession.h>
#import <NetFS/NetFS.h>
#import "AppDelegate.h"
#import "NetSSFileListManager.h"
#import "SPSmbPreferenceWindowController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSImageView *imageView;
@property (strong) NetSSFileListManager* fileListManager;
@property (strong) NSTimer* timer;
@property (strong) NSImage* displayingImage;
@property (copy) NSString* displayingImagePath;

@property (strong)NSString* serverPath;
@property (strong)NSString* serverDirectory;
@property (strong)NSString* userName;
@property (strong)NSString* password;
@property (strong)NSString* mountedVolumeName;
@property (strong)NSNumber* slideShowIntervalSeconds;
@property (strong)NSArray* excludedFileExtentionArray;
@property (strong)NSArray* excludedDirectoryArray;
@property (strong)SPSmbPreferenceWindowController* preferenceController;
@end

@implementation AppDelegate
static NSString * const SPPrefKeyServerPath = @"ServerPath";
static NSString * const SPPrefKeyServerDirectory = @"ServerDirectory";
static NSString * const SPPrefKeyUserName = @"UserName";
static NSString * const SPPrefKeyPassword = @"Password";
static NSString * const SPPrefKeyMountedVolumesName = @"MountedVolumeName";
static NSString * const SPPrefKeySlideShowIntervalSeconds = @"SlideShowIntervalSeconds";
static NSString * const SPPrefKeyExcludedDirectoryArray = @"ExcludedDirectoryArray";
static NSString * const SPPrefKeyExcludedFileExtentionArray = @"ExcludedFileExtentionArray";

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self setDefaultPreferences];
    [self loadPreferences];

    if( [self.serverPath length]<=0 )
    {
        [self showPrefernces:self];
    }
    else
    {
        [self mount];
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    self.fileListManager = nil;
    [self.timer invalidate];
    self.timer = nil;
    self.displayingImage = nil;
    self.displayingImagePath = nil;
}

- (IBAction)showPrefernces:(id)sender
{
    self.preferenceController = [[SPSmbPreferenceWindowController alloc]initWithWindowNibName:@"SPSmbPreferenceWindowController"];
    [[NSApplication sharedApplication]
     runModalForWindow:[self.preferenceController window]];
    [[self.preferenceController window] orderOut:self];
    
    [self loadPreferences];
    
    if( [self.serverPath length] > 0 )
    {
        // start slide show.
        [self mount];
    }
    return;
}


-(void)loadPreferences
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.serverPath = [defaults objectForKey:SPPrefKeyServerPath];
    self.serverDirectory = [defaults objectForKey:SPPrefKeyServerDirectory];
    self.userName = [defaults objectForKey:SPPrefKeyUserName];
    self.password = [defaults objectForKey:SPPrefKeyPassword];
    self.mountedVolumeName = [defaults objectForKey:SPPrefKeyMountedVolumesName];
    self.slideShowIntervalSeconds = [defaults objectForKey:SPPrefKeySlideShowIntervalSeconds];
    self.excludedFileExtentionArray = [defaults objectForKey:SPPrefKeyExcludedFileExtentionArray];
    self.excludedDirectoryArray = [defaults objectForKey:SPPrefKeyExcludedDirectoryArray];
    return;
}
-(void)setDefaultPreferences
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *defaultsDict = @{
                                   SPPrefKeyServerPath : @"",
                                   SPPrefKeyServerDirectory : @"",
                                   SPPrefKeyUserName : @"",
                                   SPPrefKeyPassword : @"",
                                   SPPrefKeyMountedVolumesName : @"/Volumes",
                                   SPPrefKeySlideShowIntervalSeconds : @3,
                                   SPPrefKeyExcludedFileExtentionArray :@[],
                                   SPPrefKeyExcludedDirectoryArray : @[]
                                   };
    [defaults registerDefaults:defaultsDict];

    return;
}

-(void)mount
{
    NSURL *url = [NSURL URLWithString:self.serverPath];
    NSURL *path = [NSURL URLWithString:self.mountedVolumeName];

    NSMutableDictionary *openOptions = [NSMutableDictionary dictionaryWithObject:@NO forKey:(NSString*)kNetFSMountAtMountDirKey];;
    AsyncRequestID requestID;
    dispatch_queue_t dispath = dispatch_get_main_queue();
    
    NetFSMountURLBlock mount_report = ^(int status, AsyncRequestID requestID, CFArrayRef mountpoints)
    {
        CFStringRef str = CFArrayGetValueAtIndex(mountpoints, 0);
        NSString* mountPoint = [NSString stringWithString:(__bridge_transfer NSString*)str];
        [self mountDidFinished:mountPoint];
    };
    
    NetFSMountURLAsync((__bridge CFURLRef)(url),
                       (__bridge CFURLRef)(path),
                       (__bridge CFStringRef)(self.userName),
                       (__bridge CFStringRef)(self.password),
                       (__bridge CFMutableDictionaryRef)(openOptions),
                       nil,
                       &requestID,
                       dispath,
                       mount_report);

    return;
}

-(void) mountDidFinished:(NSString*)point
{
    self.mountedRoot = point;
    
    [self startSlideShow];

    return;
}

-(void)startSlideShow
{
    [self.timer invalidate];

    self.fileListManager  = [[NetSSFileListManager alloc]init];
    self.fileListManager.excludedFileExtensionList = @[@"ORF", @"orf", @"psd", @"PSD", @"xmp"];
    self.fileListManager.excludedDirectoryNameList = @[@".webaxs"];
    
    self.fileListManager.onCollectingCompletion = ^(){};
    
    NSString* scanPath = [NSString stringWithFormat:@"%@/%@", self.mountedRoot, self.serverDirectory];
    [self.fileListManager collectTree:scanPath];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:[self.slideShowIntervalSeconds integerValue] target:self selector:@selector(repeatMethod:) userInfo:nil repeats:NO];
}

-(void)loadImage
{
    NSString* path = [self.fileListManager getImagePathAtRandom];
    if(path)
    {
        NSImage* loadedImage = [[NSImage alloc] initWithContentsOfFile:path];
        dispatch_async(dispatch_get_main_queue(), ^(){
            self.displayingImage = loadedImage;
            self.displayingImagePath = path;
            self.imageView.toolTip = path;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:[self.slideShowIntervalSeconds integerValue] target:self selector:@selector(repeatMethod:) userInfo:nil repeats:NO];
        });
    }
}
- (void)repeatMethod:(NSTimer *)timer
{
    [self.timer invalidate];
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^(){
        [self loadImage];
    });
}

@end
