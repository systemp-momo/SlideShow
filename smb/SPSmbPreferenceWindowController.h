//
//  SPSmbPreferenceWindowController.h
//  smb
//
//  Created by systemp on 2016/06/18.
//  Copyright © 2016年 systemp. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AppDelegate;
@class SPSmbAppSettings;

@interface SPSmbPreferenceWindowController : NSWindowController
@property (weak)SPSmbAppSettings* appSettings;
@property (assign)BOOL isApplied;

- (id)initWithAppSettings:(SPSmbAppSettings*)appSettings;

@end
