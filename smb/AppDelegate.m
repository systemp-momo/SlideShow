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
#import "SPSmbAppSettings.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSImageView *imageView;
@property (strong) NetSSFileListManager* fileListManager;
@property (strong) NSTimer* timer;
@property (strong) NSImage* displayingImage;
@property (copy) NSString* displayingImagePath;

@property (strong)SPSmbAppSettings* appSettings;
@end

@implementation AppDelegate

#pragma mark app delegate.
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}
- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.appSettings = [[SPSmbAppSettings alloc]init];
    self.fileListManager  = [[NetSSFileListManager alloc]init];
    self.fileListManager.delegate = self;
    
    if( ![self.appSettings isValidSettings] )
    {
        [self showPrefernces:self];
    }
    else
    {
        [self mount];
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    self.fileListManager.delegate = nil;
    self.fileListManager = nil;
    [self.timer invalidate];
    self.timer = nil;
    self.displayingImage = nil;
    self.displayingImagePath = nil;
    self.appSettings = nil;
}

#pragma mark preferences.
- (IBAction)showPrefernces:(id)sender
{
    if( [self.appSettings showPreference] )
    {
        // start slide show.
        [self mount];
    }
    
    return;
}


#pragma mark for SMB
-(void)mount
{
    NSString* fullpath = [NSString stringWithFormat:@"smb://%@", self.appSettings.serverPath];
    CFURLRef url = (__bridge CFURLRef)[NSURL URLWithString:fullpath];
    CFURLRef path = (__bridge CFURLRef)[NSURL URLWithString:self.appSettings.mountedVolumeName];
    CFStringRef username = (__bridge CFStringRef)(self.appSettings.userName);
    CFStringRef password = (__bridge CFStringRef)(self.appSettings.password);
    
    NSMutableDictionary *openOptions = [NSMutableDictionary dictionaryWithObject:@NO forKey:(NSString*)kNetFSMountAtMountDirKey];;
    AsyncRequestID requestID;
    dispatch_queue_t dispath = dispatch_get_main_queue();
    
    NetFSMountURLBlock mount_report = ^(int status, AsyncRequestID requestID, CFArrayRef mountpoints)
    {
        CFStringRef str = CFArrayGetValueAtIndex(mountpoints, 0);
        NSString* mountPoint = [NSString stringWithString:(__bridge_transfer NSString*)str];
        [self mountDidFinished:mountPoint];
    };
    
    NetFSMountURLAsync(url, path, username, password, (__bridge CFMutableDictionaryRef)(openOptions), nil, &requestID, dispath, mount_report);

    return;
}

-(void) mountDidFinished:(NSString*)point
{
    self.mountedRoot = point;
    
    [self startSlideShow];

    return;
}

#pragma mark Slide show
-(void)startSlideShow
{
    [self.timer invalidate];

    self.fileListManager.onCollectingCompletion = ^(){};
    
    NSString* scanPath = [NSString stringWithFormat:@"%@/%@", self.mountedRoot, self.appSettings.serverDirectory];
    [self.fileListManager collectTree:scanPath];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:[self.appSettings.slideShowIntervalSeconds integerValue] target:self selector:@selector(repeatMethod:) userInfo:nil repeats:NO];
}

- (void)repeatMethod:(NSTimer *)timer
{
    [self.timer invalidate];
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^(){
        [self loadImage];
    });
}

-(void)loadImage
{
    NSString* path = [self.fileListManager getPathAtRandom];
    if(path)
    {
        NSImage* loadedImage = [[NSImage alloc] initWithContentsOfFile:path];
        dispatch_async(dispatch_get_main_queue(), ^(){
            self.displayingImage = loadedImage;
            self.displayingImagePath = path;
            self.imageView.toolTip = path;
            self.window.title = path;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:[self.appSettings.slideShowIntervalSeconds integerValue] target:self selector:@selector(repeatMethod:) userInfo:nil repeats:NO];
        });
    }
}

#pragma mark NetSSDirectoryDelegate
-(BOOL)isValidDirectoryName:(NSString*)fullpath
{
    NSString* directoryName = [[fullpath pathComponents] lastObject];
    return (![self containsStringCaseInsensitiveWithString:directoryName inExcludedArray:self.appSettings.excludedDirectoryArray]);
}

-(BOOL)isValidFileName:(NSString*)fullpath
{
    BOOL isImage = NO;
    
    NSString* uti=[[NSWorkspace sharedWorkspace] typeOfFile:fullpath error:nil];
    isImage = [[NSWorkspace sharedWorkspace] type:uti conformsToType:@"public.image"];
    
    NSString* extension = [fullpath pathExtension];
    
    if(isImage && ![self containsStringCaseInsensitiveWithString:extension inExcludedArray:self.appSettings.excludedFileExtentionArray])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL)containsStringCaseInsensitiveWithString:(NSString*)string inExcludedArray:(NSArray*)array
{
    __block BOOL contains = NO;
    [array enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSDictionary* content, NSUInteger idx, BOOL* stop){
        NSString *excluded = [content objectForKey:[SPSmbAppSettings exludedArrayItemKey]];
        contains = (NSOrderedSame == [string caseInsensitiveCompare:excluded]);
        *stop = contains;
    }];
    return contains;
}
@end
