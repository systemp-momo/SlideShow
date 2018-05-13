//
//  NetSSFileListManager.h
//  NetworkSlideShow
//
//  Created by systemp on 9/16/13.
//  Copyright (c) 2013 systemp. All rights reserved.
//

// infra class


#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

typedef void (^__notify_collecting_completion)();

@protocol NetSSDirectoryDelegate
-(BOOL)isValidDirectoryName:(NSString*)fullpath;
-(BOOL)isValidFileName:(NSString*)fullpath;
@end

@interface NetSSFileListManager : NSObject

-(void)collectTree:(NSString*)url;
-(void)cancelCollecting;
-(NSString*)getPathAtRandom;

@property (strong, atomic)NSMutableArray* fileList;
@property (atomic, copy) __notify_collecting_completion onCollectingCompletion;
@property (atomic, assign)NSObject<NetSSDirectoryDelegate>* delegate;

@end
