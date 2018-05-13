//
//  SPSmbPreferenceWindowController.m
//  smb
//
//  Created by systemp on 2016/06/18.
//  Copyright © 2016年 systemp. All rights reserved.
//

#import "SPSmbPreferenceWindowController.h"
#import "SPSmbAppSettings.h"

@interface SPSmbPreferenceWindowController ()

@property (strong) SPSmbSlideshow* slideshow;

@end

@implementation SPSmbPreferenceWindowController

- (id)initWithSettings:(SPSmbAppSettings *)appSettings
{
    self = [super initWithWindowNibName:@"SPSmbPreferenceWindowController"];
    
    if(self!=nil)
    {
        if( appSettings != nil)
        {
            _appSettings = appSettings;
            _isChanged= NO;
        }
    }
    return self;
}

-(void)dealloc
{
    _appSettings = nil;
    _slideshow = nil;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    self.isChanged = NO;
}

- (void)windowWillClose:(NSNotification *)notification
{
    [[NSApplication sharedApplication] stopModal];
}

-(IBAction)okButton:(id)sender
{
    [self.window endEditingFor:nil];
    
    self.isChanged = YES;

    [self.window close];

    return;
}

@end
