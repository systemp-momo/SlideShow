//
//  SPSmbSmbAccessor.m
//  SPSmbSlideshow
//
//  Created by systemp on 2016/07/03.
//  Copyright © 2016年 systemp. All rights reserved.
//
#import "SPSmbSmbAccessor.h"
#import <NetFS/NetFS.h>

@implementation SPSmbSmbAccessor
-(void)mount:(SmbMountDidFnished)mountReport
{
    NSString* fullpath = [NSString stringWithFormat:@"smb://%@", self.serverPath];
    CFURLRef url = (__bridge CFURLRef)[NSURL URLWithString:fullpath];
    CFURLRef path = (__bridge CFURLRef)[NSURL URLWithString:self.mountedVolumeName];
    CFStringRef username = (__bridge CFStringRef)(self.userName);
    CFStringRef password = (__bridge CFStringRef)(self.password);
    
    NSMutableDictionary *openOptions = [NSMutableDictionary dictionaryWithObject:@NO forKey:(NSString*)kNetFSMountAtMountDirKey];
    AsyncRequestID requestID;
    dispatch_queue_t dispath = dispatch_get_main_queue();
    
    NetFSMountURLBlock mount_report = ^(int status, AsyncRequestID requestID, CFArrayRef mountpoints)
    {
        if( mountpoints != NULL)
        {
            CFStringRef str = CFArrayGetValueAtIndex(mountpoints, 0);
            NSString* mountPoint = [NSString stringWithString:(__bridge_transfer NSString*)str];
            mountReport(mountPoint);
        }
    };
    
    NetFSMountURLAsync(url, path, username, password, (__bridge CFMutableDictionaryRef)(openOptions), nil, &requestID, dispath, mount_report);
    
    return;
}
@end
