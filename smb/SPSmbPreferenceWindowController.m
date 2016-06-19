//
//  SPSmbPreferenceWindowController.m
//  smb
//
//  Created by systemp on 2016/06/18.
//  Copyright © 2016年 systemp. All rights reserved.
//

#import "SPSmbPreferenceWindowController.h"

@interface SPSmbPreferenceWindowController ()

@end

@implementation SPSmbPreferenceWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
-(IBAction)okButton:(id)sender
{
    [[NSApplication sharedApplication] stopModal];
    return;
}
@end
