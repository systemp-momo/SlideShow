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
        _children = [NSMutableArray array];
    }
    return self;
}

-(void)dealloc
{
    [_children removeAllObjects];
    _children = nil;
}

@end
