//
//  SPSmbSlideshow.h
//  SPSmbSlideshow
//
//  Created by systemp on 2016/06/26.
//  Copyright © 2016年 systemp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetSSFileListManager.h"
#import "SPSmbAppSettings.h"

@protocol SPSmbPresenterDelegate
- (void)setDisplayingImage:(NSImage*)image imagePath:(NSString*)path;
- (void)showPreferences;
@end

@interface SPSmbSlideshow : NSObject<NetSSDirectoryDelegate>
@property (weak)NSObject<SPSmbPresenterDelegate>* delegate;
@property (strong)SPSmbAppSettings *appSettings;
- (void)startup;
- (void)updatePreferences;

@end
