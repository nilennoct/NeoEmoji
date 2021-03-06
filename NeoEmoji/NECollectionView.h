//
//  NECollectionView.h
//  NeoEmoji
//
//  Created by Neo He on 11/8/15.
//  Copyright (c) 2015 Neo He. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NEPreviewView.h"

@interface NECollectionView : NSCollectionView

@property NSInteger numberOfColumns;

@property (weak) IBOutlet NEPreviewView *previewView;

@end
