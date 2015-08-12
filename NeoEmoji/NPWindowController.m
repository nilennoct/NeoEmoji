//
//  NPWindowController.m
//  NeoPNG
//
//  Created by Neo on 12/3/15.
//  Copyright (c) 2015 Neo He. All rights reserved.
//

#import "NPWindowController.h"
#import "NPImageWrapper.h"

@interface NPWindowController ()

@end

@implementation NPWindowController

- (void)awakeFromNib {
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.movableByWindowBackground = YES;
    self.windowFrameAutosaveName = @"MainWindow";
    self.window.level = NSFloatingWindowLevel;
    self.window.resizeIncrements = NSMakeSize(50.f, 1.f);

//    self.window.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantDark];
}

- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize {
    CGFloat width = frameSize.width;
    width = floor((width - 40) / 50.f) * 50.f + 40;

    return NSMakeSize(width, frameSize.height);
}

@end
