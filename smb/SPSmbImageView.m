//
//  SPSmbImageView.m
//  smb
//
//  Created by systemp on 2016/06/25.
//  Copyright © 2016年 systemp. All rights reserved.
//

#import "SPSmbImageView.h"

@implementation SPSmbImageView
- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor blackColor] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}
@end
