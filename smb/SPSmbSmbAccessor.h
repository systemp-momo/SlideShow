//
//  SPSmbSmbAccessor.h
//  SPSmbSlideshow
//
//  Created by systemp on 2016/07/03.
//  Copyright © 2016年 systemp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SmbMountDidFnished)(NSString* mountedPoint);

@interface SPSmbSmbAccessor : NSObject

-(void)mount:(SmbMountDidFnished)mountReport;

@property (copy)NSString* serverPath;
@property (copy)NSString* userName;
@property (copy)NSString* password;
@property (copy)NSString* mountedVolumeName;
@end
