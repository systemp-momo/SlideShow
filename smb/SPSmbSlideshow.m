//
//  SPSmbSlideshow.m
//  SPSmbSlideshow
//
//  Created by systemp on 2016/06/26.
//  Copyright © 2016年 systemp. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import <IOKit/IOKitLib.h>
#import <DiskArbitration/DiskArbitration.h>
#import <DiskArbitration/DADisk.h>
#import <DiskArbitration/DADissenter.h>
#import <DiskArbitration/DASession.h>
#import <NetFS/NetFS.h>
#import "NetSSFileListManager.h"
#import "SPSmbAppSettings.h"
#import "SPSmbSlideshow.h"
#import "SPSmbPreferenceWindowController.h"

@interface SPSmbSlideshow ()

@property (strong) NetSSFileListManager* fileListManager;
@property (strong) NSTimer* timer;
@end

@implementation SPSmbSlideshow

#pragma mark initialize/uninitialize
- (id)init
{
    self = [super init];
    if(self != nil)
    {
        self.appSettings = [[SPSmbAppSettings alloc]init];
        self.fileListManager  = [[NetSSFileListManager alloc]init];
        self.fileListManager.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    self.fileListManager.delegate = nil;
    self.fileListManager = nil;
    [self.timer invalidate];
    self.timer = nil;
    self.appSettings = nil;
}

#pragma mark Handling Application.
- (void)startup
{
    if( ![self.appSettings isValidSettings] )
    {
        if( self.delegate!=nil && [self.delegate respondsToSelector:@selector(showPreferences)] )
        {
            [self.delegate showPreferences];
        }
    }
    else
    {
        [self mount];
    }
}

- (void)updatePreferences
{
    [self startup];
    
    return;
}

#pragma mark For SMB.
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
    [self startSlideShow:point];
    
    return;
}

#pragma mark Slideshow
-(void)startSlideShow:(NSString*)rootDirectory
{
    [self.timer invalidate];
    
    self.fileListManager.onCollectingCompletion = ^(){};
    
    NSString* scanPath = [NSString stringWithFormat:@"%@/%@", rootDirectory, self.appSettings.serverDirectory];
    [self.fileListManager collectTree:scanPath];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:[self.appSettings.slideShowIntervalSeconds integerValue] target:self selector:@selector(repeatMethod:) userInfo:nil repeats:NO];
}

- (void)repeatMethod:(NSTimer *)timer
{
    [timer invalidate];
    
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
            if( self.delegate!=nil && [self.delegate respondsToSelector:@selector(setDisplayingImage:imagePath:)])
            {
                [self.delegate setDisplayingImage:loadedImage imagePath:path];
            }
            
            [self.timer invalidate];
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
    
    BOOL isValid = (isImage && ![self containsStringCaseInsensitiveWithString:extension inExcludedArray:self.appSettings.excludedFileExtentionArray]);
    return isValid;
}

-(BOOL)containsStringCaseInsensitiveWithString:(NSString*)string inExcludedArray:(NSArray*)array
{
    __block BOOL contains = NO;
    [array enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSDictionary* content, NSUInteger idx, BOOL* stop){
        NSString *excluded = content[[SPSmbAppSettings exludedArrayItemKey]];
        contains = (NSOrderedSame == [string caseInsensitiveCompare:excluded]);
        *stop = contains;
    }];
    return contains;
}

@end
