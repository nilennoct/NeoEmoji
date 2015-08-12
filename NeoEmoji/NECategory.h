//
//  NECategory.h
//  NeoEmoji
//
//  Created by Neo on 12/8/15.
//  Copyright (c) 2015 Neo He. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface NECategory : NSObject <NSCoding>

@property NSString *name;
@property (readonly) NSImage *image;

@property NSMutableArray *emojis;

- (instancetype)initWithName:(NSString *)name;

@end
