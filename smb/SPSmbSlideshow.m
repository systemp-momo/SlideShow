//
//  SPSmbSlideshow.m
//  SPSmbSlideshow
//
//  Created by systemp on 2016/06/26.
//  Copyright © 2016年 systemp. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import <NetFS/NetFS.h>
#import "NetSSFileListManager.h"
#import "SPSmbAppSettings.h"
#import "SPSmbSlideshow.h"
#import "SPSmbSmbAccessor.h"
#import "SPSmbUserDefaults.h"

@interface SPSmbSlideshow ()

@property (strong) NetSSFileListManager* fileListManager;
@property (strong) SPSmbUserDefaults* userDefaults;
@property (strong) NSTimer* timer;
@property (strong) SPSmbSmbAccessor* smbAccessor;
@end

@implementation SPSmbSlideshow

#pragma mark initialize/uninitialize
- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _fileListManager  = [[NetSSFileListManager alloc]init];
        _fileListManager.delegate = self;
        _userDefaults = [[SPSmbUserDefaults alloc]init];
        _presenter = nil;
        _smbAccessor = [[SPSmbSmbAccessor alloc]init];
        _appSettings = [[SPSmbAppSettings alloc]init];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
                                                          
    _smbAccessor = nil;
    _fileListManager.delegate = nil;
    _fileListManager = nil;
    [_timer invalidate];
    _timer = nil;
    _appSettings = nil;
    _presenter = nil;
}

#pragma mark Handling Application.
- (void)startup
{
    self.appSettings = [self.userDefaults queryPreferences];
    
    if( ![self.appSettings isValidSettings] )
    {
        if( self.presenter!=nil && [self.presenter respondsToSelector:@selector(preferenceIsInvalid:)] )
        {
            [self.presenter preferenceIsInvalid:self.appSettings];
        }
    }
    else
    {
        self.smbAccessor.serverPath = self.appSettings.serverPath;
        self.smbAccessor.userName = self.appSettings.userName;
        self.smbAccessor.password = self.appSettings.password;
        self.smbAccessor.mountedVolumeName = self.appSettings.mountedVolumeName;
        [self.smbAccessor mount:^(NSString* mountedPoint)
        {
            [self startSlideShow:mountedPoint];
        }];
    }
}

#pragma mark Preferences
- (void)updatePreferences:(SPSmbAppSettings*)appSettings
{
    [self.userDefaults updatePreferences:appSettings];
}

#pragma mark Slideshow
-(void)startSlideShow:(NSString*)rootDirectory
{
    SPSmbAppSettings *settings = self.appSettings;

    [self.timer invalidate];
    
    self.fileListManager.onCollectingCompletion = ^(){};
    
    NSString* scanPath = [NSString stringWithFormat:@"%@/%@", rootDirectory, settings.serverDirectory];
    [self.fileListManager collectTree:scanPath];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:[settings.slideShowIntervalSeconds integerValue] target:self selector:@selector(repeatMethod:) userInfo:nil repeats:NO];
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
        SPSmbAppSettings *settings = self.appSettings;

        NSImage* loadedImage = [[NSImage alloc] initWithContentsOfFile:path];
        dispatch_async(dispatch_get_main_queue(), ^(){
            if( self.presenter!=nil && [self.presenter respondsToSelector:@selector(imageDidLoad:imagePath:)])
            {
                [self.presenter imageDidLoad:loadedImage imagePath:path];
            }
            
            [self.timer invalidate];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:[settings.slideShowIntervalSeconds integerValue] target:self selector:@selector(repeatMethod:) userInfo:nil repeats:NO];
        });
    }
}

#pragma mark NetSSDirectoryDelegate
-(BOOL)isValidDirectoryName:(NSString*)fullpath
{
    SPSmbAppSettings *settings = self.appSettings;

    NSString* directoryName = [[fullpath pathComponents] lastObject];
    return (![self containsStringCaseInsensitiveWithString:directoryName inExcludedArray:settings.excludedDirectoryArray]);
}

-(BOOL)isValidFileName:(NSString*)fullpath
{
    SPSmbAppSettings *settings = self.appSettings;
    BOOL isImage = NO;
    
    NSString* uti=[[NSWorkspace sharedWorkspace] typeOfFile:fullpath error:nil];
    isImage = [[NSWorkspace sharedWorkspace] type:uti conformsToType:@"public.image"];
    
    NSString* extension = [fullpath pathExtension];
    
    BOOL isValid = (isImage && ![self containsStringCaseInsensitiveWithString:extension inExcludedArray:settings.excludedFileExtentionArray]);
    return isValid;
}

-(BOOL)containsStringCaseInsensitiveWithString:(NSString*)string inExcludedArray:(NSArray*)array
{
    __block BOOL contains = NO;
    [array enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSDictionary* content, NSUInteger idx, BOOL* stop){
        NSString *excluded = content[SPKeyExludedArrayItemKey];
        contains = (NSOrderedSame == [string caseInsensitiveCompare:excluded]);
        *stop = contains;
    }];
    return contains;
}

@end
