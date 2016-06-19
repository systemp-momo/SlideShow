//
//  NetSSComponentObject.m
//  NetworkSlideShow
//
//  Created by systemp on 9/16/13.
//  Copyright (c) 2013 systemp. All rights reserved.
//

#import "NetSSComponentObject.h"

@implementation NetSSComponentObject
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)dealloc
{
    self.fullPath = nil;
}

@end
