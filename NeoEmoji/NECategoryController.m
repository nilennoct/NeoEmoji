//
//  NECategoryController.m
//  NeoEmoji
//
//  Created by Neo on 12/8/15.
//  Copyright (c) 2015 Neo He. All rights reserved.
//

#import "NECategoryController.h"
#import "NEDataManager.h"
#import "NECategory.h"

#define DEFAULT_CATEGORY_NAME @"uncategoried"

@implementation NECategoryController {
    BOOL _initialized;
}

- (void)awakeFromNib {
    if (_initialized) {
        return;
    }

    _initialized = YES;

    NSMutableArray *categoryData = [[NEDataManager sharedInstance] readDataForKey:CATEGORY_DATA_KEY];

    __block BOOL hasDefaultCategory = NO;

    if (!categoryData) {
        categoryData = [NSMutableArray array];
    }
    else if ([categoryData count] > 0) {
        [categoryData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NECategory *category = (NECategory *)obj;
            if ([category.name isEqualToString:DEFAULT_CATEGORY_NAME]) {
                hasDefaultCategory = YES;
                *stop = YES;
            }
        }];
    }

    if (!hasDefaultCategory) {
        NECategory *defaultCategory = [[NECategory alloc] initWithName:DEFAULT_CATEGORY_NAME];

        [categoryData insertObject:defaultCategory atIndex:0];
    }


    self.content = categoryData;

    NSInteger categorySelectionIndex = [[NSUserDefaults standardUserDefaults] integerForKey:CATEGORY_INDEX_KEY];

    self.selectionIndex = categorySelectionIndex;

}

- (BOOL)canSelectionBeRemoved {
    if (self.selectionIndex == NSNotFound) {
        return NO;
    }

    NSString *name = [self.selection valueForKey:@"name"];

    return ![name isEqualToString:DEFAULT_CATEGORY_NAME];
}

#pragma mark IBAction

- (IBAction)add:(id)sender {
    [self addObject:[[NECategory alloc] init]];

    [[NEDataManager sharedInstance] writeData:self.content forKey:CATEGORY_DATA_KEY];
}

- (IBAction)remove:(id)sender {
    NSInteger selectionIndex = self.selectionIndex - 1;
    [super remove:sender];

    NSInteger count = [self.arrangedObjects count];
    if (selectionIndex > count - 1) {
        selectionIndex = count - 1;
    }
    self.selectionIndex = selectionIndex;
    [[NEDataManager sharedInstance] writeData:self.content forKey:CATEGORY_DATA_KEY];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger categorySelectionIndex = self.selectionIndex;

    if (categorySelectionIndex != NSNotFound) {
        [[NSUserDefaults standardUserDefaults] setInteger:categorySelectionIndex forKey:CATEGORY_INDEX_KEY];
    }
}

@end
