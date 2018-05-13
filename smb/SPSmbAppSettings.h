//
//  AppSettings.h
//  smb
//
//  Created by systemp on 2016/06/19.
//  Copyright © 2016年 systemp. All rights reserved.
//

#import <Foundation/Foundation.h>

// Entity
extern NSString * const SPKeyExludedArrayItemKey;

@interface SPSmbAppSettings : NSObject<NSCopying>

// for smb.
@property (copy)NSString* serverPath;
@property (copy)NSString* userName;
@property (copy)NSString* password;
@property (copy)NSString* mountedVolumeName;

// for slideshow.
@property (copy)NSNumber* slideShowIntervalSeconds;
@property (copy)NSString* serverDirectory;

// for file system.
@property (copy)NSArray* excludedFileExtentionArray;

@property (copy)NSArray* excludedDirectoryArray;

- (BOOL)isValidSettings;

@end
