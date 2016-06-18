//
//  NetSSComposite.m
//  NetworkSlideShow
//
//  Created by systemp on 9/16/13.
//  Copyright (c) 2013 systemp. All rights reserved.
//

#import "NetSSComposite.h"

@implementation NetSSComposite
- (id)init
{
    self = [super init];
    if (self) {
        self.children = [NSMutableArray array];
    }
    return self;
}

-(void)dealloc
{
    [self.children removeAllObjects];
    self.children = nil;
    // not call [super dealloc];
}

@end
