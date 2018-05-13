//
//  SPSmbPreferenceWindowController.h
//  smb
//
//  Created by systemp on 2016/06/18.
//  Copyright © 2016年 systemp. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPSmbUserDefaults.h"

@class AppDelegate;
@class SPSmbSlideshow;

@interface SPSmbPreferenceWindowController : NSWindowController
- (id)initWithSettings:(SPSmbAppSettings *)appSettings;

@property(copy)SPSmbAppSettings* appSettings;
@property(assign)BOOL isChanged;
@end
