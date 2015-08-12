//
//  AppDelegate.m
//  NeoEmoji
//
//  Created by Neo He on 11/8/15.
//  Copyright (c) 2015 Neo He. All rights reserved.
//

#import "AppDelegate.h"
#import "NPImagesController.h"

#import "DDHotKeyCenter.h"
#import <Carbon/Carbon.h>

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@property (weak) IBOutlet NPImagesController *imagesController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[DDHotKeyCenter sharedHotKeyCenter] registerHotKeyWithKeyCode:kVK_ANSI_E modifierFlags:NSCommandKeyMask | NSShiftKeyMask task:^(NSEvent *event) {
        if (_window.visible) {
            [_window orderOut:nil];
        }
        else {
            [_window makeKeyAndOrderFront:nil];
        }
    }];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    if (!self.window.visible) {
        [self.window makeKeyAndOrderFront:self];
    }
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    if (!flag) {
        [self.window makeKeyAndOrderFront:self];
    }
    return YES;
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames {
    NSInteger numberOfImagesToAdd = [_imagesController dropFiles:filenames];

    if (numberOfImagesToAdd > 0) {
        [_imagesController commitChanges];
        [sender replyToOpenOrPrint:NSApplicationDelegateReplySuccess];
        [self.window makeKeyAndOrderFront:self];
    }

    [sender replyToOpenOrPrint:NSApplicationDelegateReplyFailure];
}

@end
