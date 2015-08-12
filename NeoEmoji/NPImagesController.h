//
//  NPImagesController.h
//  NeoPNG
//
//  Created by Neo on 13/3/15.
//  Copyright (c) 2015 Neo He. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NECollectionView.h"
#import "NECategoryController.h"

#define DRAGGED_TYPES @[NSFilenamesPboardType, NSURLPboardType]
#define SUPPORT_IMAGE_TYPES @[@"png", @"jpg", @"gif"]

@interface NPImagesController : NSArrayController <NSCollectionViewDelegate>

@property (weak) IBOutlet NECollectionView *imageCollectionView;

@property (weak) IBOutlet NECategoryController *categoryController;

@property (readonly, getter=isEmpty) BOOL empty;
@property (nonatomic) BOOL allowsMultipleSelection;

- (NSInteger)dropFiles:(NSArray *)files;
- (void)pushObject:(id)object;
- (NSInteger)commitChanges;
- (void)revertChanges;

- (IBAction)clear:(id)sender;

@end
