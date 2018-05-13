//
//  AppSettings.m
//  smb
//
//  Created by systemp on 2016/06/19.
//  Copyright © 2016年 systemp. All rights reserved.
//

#import "SPSmbAppSettings.h"

NSString * const SPKeyExludedArrayItemKey        = @"Excluded";

@interface SPSmbAppSettings ()
@end

@implementation SPSmbAppSettings

- (id)init
{
    self = [super init];
    if (self) {
        _serverPath = nil;
        _serverDirectory = nil;
        _userName = nil;
        _password = nil;
        _mountedVolumeName = nil;
        _slideShowIntervalSeconds = nil;
        _excludedFileExtentionArray = nil;
        _excludedDirectoryArray = nil;
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
}

-(BOOL) isValidSettings
{
    return ( [self.serverPath length] > 0 );
}

#pragma mark NSCopying protocol
-(id)copyWithZone:(NSZone *)zone
{
    SPSmbAppSettings *newInstance = [[[self class] allocWithZone:zone] init];
    if (newInstance) {
        newInstance.serverPath = self.serverPath;
        newInstance.serverDirectory = self.serverDirectory;
        newInstance.userName = self.userName;
        newInstance.password = self.password;
        newInstance.mountedVolumeName = self.mountedVolumeName;
        newInstance.slideShowIntervalSeconds = self.slideShowIntervalSeconds;
        newInstance.excludedFileExtentionArray = self.excludedFileExtentionArray;
        newInstance.excludedDirectoryArray = self.excludedDirectoryArray;
    }
    return newInstance;
}

@end
