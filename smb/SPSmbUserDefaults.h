//
//  SPSmbPreferences.h
//  SPSmbSlideshow
//
//  Created by systemp on 2016/07/03.
//  Copyright © 2016年 systemp. All rights reserved.
//

#import <Foundation/Foundation.h>

// repository class

@class SPSmbAppSettings;

extern NSString * const SPPreferencesDidChangeNotification;

extern NSString * const SPPrefKeyServerPath;
extern NSString * const SPPrefKeyServerDirectory;
extern NSString * const SPPrefKeyUserName;
extern NSString * const SPPrefKeyPassword;
extern NSString * const SPPrefKeyMountedVolumesName;
extern NSString * const SPPrefKeySlideShowIntervalSeconds;
extern NSString * const SPPrefKeyExcludedDirectoryArray;
extern NSString * const SPPrefKeyExcludedFileExtentionArray;

// repository class.

@interface SPSmbUserDefaults : NSObject
- (void)setDefaultPreferences;
- (BOOL)updatePreferences:(SPSmbAppSettings*)appSettings;
- (SPSmbAppSettings*)queryPreferences;
@end
