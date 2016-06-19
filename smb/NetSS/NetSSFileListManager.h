//
//  NetSSFileListManager.h
//  NetworkSlideShow
//
//  Created by systemp on 9/16/13.
//  Copyright (c) 2013 systemp. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

typedef void (^__notify_collecting_completion)();

@interface NetSSFileListManager : NSObject

-(void)collectTree:(NSString*)url;
-(void)cancelCollecting;
-(NSString*)getImagePathAtRandom;

@property (atomic, copy) __notify_collecting_completion onCollectingCompletion;
@property (strong) NSArray* excludedFileExtensionList;
@property (strong) NSArray* excludedDirectoryNameList;

@end
