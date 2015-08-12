//
//  NPImagesController.h
//  NeoPNG
//
//  Created by Neo on 13/3/15.
//  Copyright (c) 2015 Neo He. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NECollectionView.h"

@interface NPImagesController : NSArrayController <NSCollectionViewDelegate>

@property (weak) IBOutlet NECollectionView *imageCollectionView;

@property (readonly, getter=isEmpty) BOOL empty;
@property (nonatomic) BOOL allowsMultipleSelection;

- (NSInteger)dropFiles:(NSArray *)files;
- (void)pushObject:(id)object;
- (NSInteger)commitChanges;
- (void)revertChanges;

- (IBAction)removeWithFile:(id)sender;
- (IBAction)clear:(id)sender;

@end
