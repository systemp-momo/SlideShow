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
#import "SPSmbSlideshow.h"
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
    self.slideshow.delegate = self;
    [self.slideshow startup];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    self.slideshow.delegate = nil;
    self.slideshow = nil;
    self.displayingImage = nil;
}

- (IBAction)showPreferences:(id)sender
{
    [self showPreferences];
    return;
}

#pragma mark SPSmbPresenterDelegate
- (void)setDisplayingImage:(NSImage*)image imagePath:(NSString*)path
{
    self.displayingImage = image;
    self.imageView.toolTip = path;
    self.window.title = path;
    return;
}

- (void)showPreferences
{
    SPSmbPreferenceWindowController *preferenceController = [[SPSmbPreferenceWindowController alloc]initWithAppSettings:self.slideshow.appSettings];
    [[NSApplication sharedApplication]
     runModalForWindow:[preferenceController window]];
    [[preferenceController window] orderOut:self];
    
    [self.slideshow updatePreferences];
    
    return;
}

@end
