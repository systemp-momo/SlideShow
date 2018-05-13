//
//  SPSmbSlideshow.h
//  SPSmbSlideshow
//
//  Created by systemp on 2016/06/26.
//  Copyright © 2016年 systemp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetSSFileListManager.h"

@class SPSmbUserDefaults;
@class SPSmbAppSettings;

@protocol SPSmbPresenterProtocol
- (void)imageDidLoad:(NSImage*)image imagePath:(NSString*)path;
- (BOOL)preferenceIsInvalid:(SPSmbAppSettings*)appSettings;
@end

@interface SPSmbSlideshow : NSObject<NetSSDirectoryDelegate>
@property (weak)NSObject<SPSmbPresenterProtocol>* presenter;
@property (copy) SPSmbAppSettings* appSettings;

- (void)startup;
- (void)updatePreferences:(SPSmbAppSettings*)appSettings;

@end
