//
//  NPImage.m
//  NeoPNG
//
//  Created by Neo on 12/3/15.
//  Copyright (c) 2015 Neo He. All rights reserved.
//

#import "NPImageWrapper.h"

static const NSString *defaultPrefix = @"out/";

@implementation NPImageWrapper

- (instancetype)initWithPath:(NSString *)path {
    if (self = [super init]) {
        _path = path;
        _URL = [NSURL fileURLWithPath:path];
        _filename = [_path lastPathComponent];
    }

    return self;
}

#pragma mark NSPasteboardWriting

- (NSPasteboardWritingOptions)writingOptionsForType:(NSString *)type pasteboard:(NSPasteboard *)pasteboard {
    return [_URL writingOptionsForType:type pasteboard:pasteboard];
}

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
    return [_URL writableTypesForPasteboard:pasteboard];
}

- (id)pasteboardPropertyListForType:(NSString *)type {
    return [_URL pasteboardPropertyListForType:type];
}

- (BOOL)isEqual:(NPImageWrapper *)object {
    if ([super isEqual:object]) {
        return YES;
    }

    return [_path isEqualToString:object.path];
}

- (NSUInteger)hash {
    return _path.hash;
}

@end
