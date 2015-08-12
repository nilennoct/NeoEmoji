//
//  NECollectionViewItem.m
//  NeoEmoji
//
//  Created by Neo He on 12/8/15.
//  Copyright (c) 2015 Neo He. All rights reserved.
//

#import "NECollectionViewItem.h"

@interface NECollectionViewItem ()

@end

@implementation NECollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self.imageView setAnimates:selected];
}

@end
