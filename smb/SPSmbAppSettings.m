//
//  AppSettings.m
//  smb
//
//  Created by systemp on 2016/06/19.
//  Copyright © 2016年 systemp. All rights reserved.
//

#import "SPSmbAppSettings.h"
#import "SPSmbPreferenceWindowController.h"

@interface SPSmbAppSettings ()
@property (strong)SPSmbPreferenceWindowController* preferenceController;
@end

@implementation SPSmbAppSettings
// Constants.
static NSString * const SPPrefKeyServerPath         = @"ServerPath";
static NSString * const SPPrefKeyServerDirectory    = @"ServerDirectory";
static NSString * const SPPrefKeyUserName           = @"UserName";
static NSString * const SPPrefKeyPassword           = @"Password";
static NSString * const SPPrefKeyMountedVolumesName = @"MountedVolumeName";
static NSString * const SPPrefKeySlideShowIntervalSeconds   = @"SlideShowIntervalSeconds";
static NSString * const SPPrefKeyExcludedDirectoryArray     = @"ExcludedDirectoryArray";
static NSString * const SPPrefKeyExcludedFileExtentionArray = @"ExcludedFileExtentionArray";
static NSString * const SPPrefKeyExludedArrayItemKey        = @"Excluded";

- (id)init
{
    self = [super init];
    if (self) {
        [self setDefaultPreferences];
        [self loadPreferences];
    }
    return self;
}

-(void)dealloc
{
    _serverPath = nil;
    _serverDirectory = nil;
    _userName = nil;
    _password = nil;
    _mountedVolumeName = nil;
    _slideShowIntervalSeconds = nil;
    _excludedFileExtentionArray = nil;
    _excludedDirectoryArray = nil;
    
    _preferenceController = nil;
}

-(BOOL)savePreferences
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.serverPath forKey:SPPrefKeyServerPath];
    [defaults setObject:self.serverDirectory forKey:SPPrefKeyServerDirectory];
    [defaults setObject:self.userName forKey:SPPrefKeyUserName];
    [defaults setObject:self.password forKey:SPPrefKeyPassword];
    [defaults setObject:self.mountedVolumeName forKey:SPPrefKeyMountedVolumesName];
    [defaults setObject:self.slideShowIntervalSeconds forKey:SPPrefKeySlideShowIntervalSeconds];
    [defaults setObject:self.excludedFileExtentionArray forKey:SPPrefKeyExcludedFileExtentionArray];
    [defaults setObject:self.excludedDirectoryArray forKey:SPPrefKeyExcludedDirectoryArray];
    BOOL successful = [defaults synchronize];
    return successful;
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

- (void)setDefaultPreferences
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

-(BOOL) isValidSettings
{
    return ( [self.serverPath length] > 0 );
}

-(BOOL)showPreference
{
    self.preferenceController = [[SPSmbPreferenceWindowController alloc]initWithAppSettings:self];
    [[NSApplication sharedApplication]
     runModalForWindow:[self.preferenceController window]];
    [[self.preferenceController window] orderOut:self];
    BOOL result = NO;
    if([self isValidSettings] && self.preferenceController.isApplied)
    {
        result = [self savePreferences];
    }
    
    return result;
}

+(NSString*)exludedArrayItemKey
{
    return SPPrefKeyExludedArrayItemKey;
}
@end
