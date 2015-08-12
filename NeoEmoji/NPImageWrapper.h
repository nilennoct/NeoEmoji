//
//  NPImage.h
//  NeoPNG
//
//  Created by Neo on 12/3/15.
//  Copyright (c) 2015 Neo He. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NPImageWrapper : NSObject <NSPasteboardWriting> {
    NSURL *_URL;
}

@property NSString *path;

@property NSString *filename;

- (instancetype)initWithPath:(NSString *)path;

@end
