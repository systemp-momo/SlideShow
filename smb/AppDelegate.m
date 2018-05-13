//
//  AppDelegate.m
//  smb
//
//  Created by systemp on 2015/11/23.
//  Copyright © 2015年 systemp. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import <IOKit/IOKitLib.h>
#import "AppDelegate.h"

#import "SPSmbPreferenceWindowController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSImageView *imageView;
@property (strong) NSImage* displayingImage;
@property (strong) SPSmbSlideshow* slideshow;
@end

@implementation AppDelegate

#pragma mark NSApplicationDelegate
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.slideshow = [[SPSmbSlideshow alloc]init];
    self.slideshow.presenter = self;
    [self.slideshow startup];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    self.slideshow.presenter = nil;
    self.slideshow = nil;
    self.displayingImage = nil;
}

- (IBAction)preferencesMenu:(id)sender
{
    [self preferenceIsInvalid:self.slideshow.appSettings];
    return;
}

#pragma mark SPSmbPresenterDelegate
- (void)imageDidLoad:(NSImage*)image imagePath:(NSString*)path
{
    self.displayingImage = image;
    self.imageView.toolTip = path;
    self.window.title = path;
    return;
}

- (BOOL)preferenceIsInvalid:(SPSmbAppSettings*)appSettings
{
    SPSmbPreferenceWindowController *preferenceController = [[SPSmbPreferenceWindowController alloc]initWithSettings:self.slideshow.appSettings];
    
    [[NSApplication sharedApplication]
     runModalForWindow:[preferenceController window]];
    [[preferenceController window] orderOut:self];
    if( preferenceController.isChanged )
    {
        [self.slideshow updatePreferences:preferenceController.appSettings];
    }
    return preferenceController.isChanged;
}

@end
