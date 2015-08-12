//
//  NECategory.m
//  NeoEmoji
//
//  Created by Neo on 12/8/15.
//  Copyright (c) 2015 Neo He. All rights reserved.
//

#import "NECategory.h"
#import "NPImageWrapper.h"

@implementation NECategory

- (instancetype)init {
    if (self = [super init]) {
        self.name = @"unamed";
        self.emojis = [NSMutableArray array];
    }

    return self;
}

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        self.name = name;
        self.emojis = [NSMutableArray array];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.emojis forKey:@"emojis"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];

        NSArray *emojiData = [aDecoder decodeObjectForKey:@"emojis"];
        self.emojis = [NSMutableArray arrayWithArray:emojiData];

    };

    return self;
}

- (NSImage *)image {
    if ([self.emojis count] > 0) {
        NPImageWrapper *imageWrapper = (NPImageWrapper *)[self.emojis objectAtIndex:0];
        return [[NSImage alloc] initWithContentsOfFile:imageWrapper.path];
    }
    else {
        return [NSImage imageNamed:@"NEPlaceholderTemplate"];
    }
}

@end
