//
//  SPSmbUserDefaults.m
//  SPSmbSlideshow
//
//  Created by systemp on 2016/07/03.
//  Copyright © 2016年 systemp. All rights reserved.
//

#import "SPSmbUserDefaults.h"
#import "SPSmbAppSettings.h"

// Constants.
NSString * const SPPreferencesDidChangeNotification = @"SPSmbPreferencesDidChangeNotification";

NSString * const SPPrefKeyServerPath         = @"ServerPath";
NSString * const SPPrefKeyServerDirectory    = @"ServerDirectory";
NSString * const SPPrefKeyUserName           = @"UserName";
NSString * const SPPrefKeyPassword           = @"Password";
NSString * const SPPrefKeyMountedVolumesName = @"MountedVolumeName";
NSString * const SPPrefKeySlideShowIntervalSeconds   = @"SlideShowIntervalSeconds";
NSString * const SPPrefKeyExcludedDirectoryArray     = @"ExcludedDirectoryArray";
NSString * const SPPrefKeyExcludedFileExtentionArray = @"ExcludedFileExtentionArray";

@interface SPSmbUserDefaults ()
@end

@implementation SPSmbUserDefaults
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)dealloc
{
}

-(BOOL)updatePreferences:(SPSmbAppSettings*)appSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:appSettings.serverPath forKey:SPPrefKeyServerPath];
    [defaults setObject:appSettings.serverDirectory forKey:SPPrefKeyServerDirectory];
    [defaults setObject:appSettings.userName forKey:SPPrefKeyUserName];
    [defaults setObject:appSettings.password forKey:SPPrefKeyPassword];
    [defaults setObject:appSettings.mountedVolumeName forKey:SPPrefKeyMountedVolumesName];
    [defaults setObject:appSettings.slideShowIntervalSeconds forKey:SPPrefKeySlideShowIntervalSeconds];
    [defaults setObject:appSettings.excludedFileExtentionArray forKey:SPPrefKeyExcludedFileExtentionArray];
    [defaults setObject:appSettings.excludedDirectoryArray forKey:SPPrefKeyExcludedDirectoryArray];
    BOOL successful = [defaults synchronize];
    return successful;
}

-(SPSmbAppSettings*)queryPreferences
{
    [self setDefaultPreferences];

    SPSmbAppSettings* appSettings = [[SPSmbAppSettings alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    appSettings.serverPath = [defaults objectForKey:SPPrefKeyServerPath];
    appSettings.serverDirectory = [defaults objectForKey:SPPrefKeyServerDirectory];
    appSettings.userName = [defaults objectForKey:SPPrefKeyUserName];
    appSettings.password = [defaults objectForKey:SPPrefKeyPassword];
    appSettings.mountedVolumeName = [defaults objectForKey:SPPrefKeyMountedVolumesName];
    appSettings.slideShowIntervalSeconds = [defaults objectForKey:SPPrefKeySlideShowIntervalSeconds];
    appSettings.excludedFileExtentionArray = [defaults objectForKey:SPPrefKeyExcludedFileExtentionArray];
    appSettings.excludedDirectoryArray = [defaults objectForKey:SPPrefKeyExcludedDirectoryArray];
    
    return appSettings;
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


@end
