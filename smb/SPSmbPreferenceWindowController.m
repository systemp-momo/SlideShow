//
//  SPSmbPreferenceWindowController.m
//  smb
//
//  Created by systemp on 2016/06/18.
//  Copyright © 2016年 systemp. All rights reserved.
//

#import "SPSmbPreferenceWindowController.h"
#import "AppDelegate.h"
#import "SPSmbAppSettings.h"

@interface SPSmbPreferenceWindowController ()
@property (copy)NSString* temporaryServerPath;
@property (copy)NSString* temporaryServerDirectory;
@property (copy)NSString* temporaryUserName;
@property (copy)NSString* temporaryPassword;
@property (copy)NSString* temporaryMountedVolumeName;
@property (copy)NSString* temporarySlideShowIntervalSeconds;
@property (copy)NSArray* temporaryExcludedFileExtentionArray;
@property (copy)NSArray* temporaryExcludedDirectoryArray;
@end

@implementation SPSmbPreferenceWindowController

- (id)initWithAppSettings:(SPSmbAppSettings*)appSettings
{
    self = [super initWithWindowNibName:@"SPSmbPreferenceWindowController"];
    
    if(self!=nil)
    {
        _appSettings = appSettings;
        if( _appSettings != nil)
        {
            _temporaryServerPath = _appSettings.serverPath;
            _temporaryServerDirectory = _appSettings.serverDirectory;
            _temporaryUserName = _appSettings.userName;
            _temporaryPassword = _appSettings.password;
            _temporaryMountedVolumeName = _appSettings.mountedVolumeName;
            _temporarySlideShowIntervalSeconds = [_appSettings.slideShowIntervalSeconds stringValue];
            _temporaryExcludedFileExtentionArray = _appSettings.excludedFileExtentionArray;
            _temporaryExcludedDirectoryArray = _appSettings.excludedDirectoryArray;
        }
        _isApplied = NO;
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)windowWillClose:(NSNotification *)notification
{
    [[NSApplication sharedApplication] stopModal];
}

-(IBAction)okButton:(id)sender
{
    [self.window endEditingFor:nil];
    
    self.isApplied = YES;
    
    self.appSettings.serverPath = self.temporaryServerPath;
    self.appSettings.serverDirectory = self.temporaryServerDirectory;
    self.appSettings.userName = self.temporaryUserName;
    self.appSettings.password = self.temporaryPassword;
    self.appSettings.mountedVolumeName = self.temporaryMountedVolumeName;
    self.appSettings.slideShowIntervalSeconds = @([self.temporarySlideShowIntervalSeconds integerValue]);
    self.appSettings.excludedFileExtentionArray = self.temporaryExcludedFileExtentionArray;
    self.appSettings.excludedDirectoryArray = self.temporaryExcludedDirectoryArray;
    
    [self.window close];

    return;
}

@end
