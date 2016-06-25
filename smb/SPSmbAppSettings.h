//
//  AppSettings.h
//  smb
//
//  Created by systemp on 2016/06/19.
//  Copyright © 2016年 systemp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPSmbAppSettings : NSObject
@property (strong)NSString* serverPath;
@property (strong)NSString* serverDirectory;
@property (strong)NSString* userName;
@property (strong)NSString* password;
@property (strong)NSString* mountedVolumeName;
@property (strong)NSNumber* slideShowIntervalSeconds;
@property (strong)NSArray* excludedFileExtentionArray;
@property (strong)NSArray* excludedDirectoryArray;

- (void)loadPreferences;
- (void)setDefaultPreferences;
- (BOOL)showPreference;
- (BOOL) isValidSettings;
+ (NSString*)exludedArrayItemKey;

@end
