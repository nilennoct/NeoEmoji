//
//  NECategoryController.h
//  NeoEmoji
//
//  Created by Neo on 12/8/15.
//  Copyright (c) 2015 Neo He. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NECategoryController : NSArrayController <NSTableViewDelegate>

@property (readonly) BOOL canSelectionBeRemoved;

@end
