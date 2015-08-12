//
//  NPWindowController.h
//  NeoPNG
//
//  Created by Neo on 12/3/15.
//  Copyright (c) 2015 Neo He. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NPImagesController.h"
#import "NPDragView.h"

@interface NPWindowController : NSWindowController <NSWindowDelegate>


@property (weak) IBOutlet NPImagesController *imagesController;

//- (IBAction)openPreference:(id)sender;

@end
