//
//  NPImagesController.m
//  NeoPNG
//
//  Created by Neo on 13/3/15.
//  Copyright (c) 2015 Neo He. All rights reserved.
//

#import "NPImagesController.h"
#import "NPImageWrapper.h"
#import "NECategory.h"
#import "NEDataManager.h"

@implementation NPImagesController {
    NSMutableArray *_tStorage;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        _tStorage = [NSMutableArray array];
//        [self readData];
    }

    return self;
}

- (void)awakeFromNib {
    [_imageCollectionView registerForDraggedTypes:DRAGGED_TYPES];
    [_imageCollectionView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    [_imageCollectionView setDraggingSourceOperationMask:NSDragOperationEvery forLocal:YES];
}

- (BOOL)isEmpty {
    return [self.content count] == 0;
}

- (BOOL)allowsMultipleSelection {
    return _imageCollectionView.allowsMultipleSelection;
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection {
    _imageCollectionView.allowsMultipleSelection = allowsMultipleSelection;
    [self setSelectionIndex:NSNotFound];
}

- (NSInteger)dropFiles:(NSArray *)files {
    _tStorage = [NSMutableArray arrayWithCapacity:[files count]];

    @autoreleasepool {
        for (NSString *path in files) {
            NSString *extension = [[path pathExtension] lowercaseString];
            if ([SUPPORT_IMAGE_TYPES containsObject:extension]) {
                NPImageWrapper *image = [[NPImageWrapper alloc] initWithPath:path];
                [self pushObject:image];
            }
        }
    }

    return [_tStorage count];
}

- (void)pushObject:(id)object {
    if (object != nil && [self.content indexOfObject:object] == NSNotFound) {
        [_tStorage addObject:object];
    }
}

- (NSInteger)commitChanges {
    NSInteger count = [_tStorage count];
    NECategory *category = self.categoryController.selectedObjects[0];

    [category willChangeValueForKey:@"image"];

    if (count > 0) {
        [self addObjects:_tStorage];

        [_tStorage removeAllObjects];

        [category didChangeValueForKey:@"image"];
    }

    [self writeToFile];

    return count;
}


- (NSInteger)commitChangesAtIndex:(NSInteger)index {
    NSInteger count = [_tStorage count];

    NECategory *category = self.categoryController.selectedObjects[0];

    [category willChangeValueForKey:@"image"];

    if (count > 0) {
        NSIndexSet *insertIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, count)];
        [self insertObjects:_tStorage atArrangedObjectIndexes:insertIndexSet];

        [category didChangeValueForKey:@"image"];

        [_tStorage removeAllObjects];
    }

    [self writeToFile];

    return count;
}

- (void)rearrangeSelectedObjectsAtIndex:(NSInteger)index {
    NSIndexSet *selectionIndexes = self.selectionIndexes;
    NSArray *selectedObjects = self.selectedObjects;

    __block NSUInteger insertIndex = index;
    [selectionIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        if (idx < index) {
            insertIndex--;
        }
    }];

    NECategory *category = self.categoryController.selectedObjects[0];

    [category willChangeValueForKey:@"image"];

    [self removeObjects:selectedObjects];
    [self insertObjects:selectedObjects atArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(insertIndex, [selectedObjects count])]];

    [category didChangeValueForKey:@"image"];

    [self writeToFile];
}

- (void)revertChanges {
    [_tStorage removeAllObjects];
}

- (void)writeToFile {
    [[NEDataManager sharedInstance] writeData:self.categoryController.content forKey:CATEGORY_DATA_KEY];
//    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:[self.arrangedObjects count]];
//    [self.arrangedObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        NPImageWrapper *image = obj;
//        [dataArray addObject:image.path];
//    }];
//
//    [[NSUserDefaults standardUserDefaults] setObject:dataArray forKey:@"data"];
//    BOOL result = [dataArray writeToFile:[self getFilepath] atomically:YES];
//    if (!result) {
//        NSLog(@"Error when write data to plist");
//    }
}

- (void)removeObjects:(NSArray *)objects {
    NECategory *category = self.categoryController.selectedObjects[0];

    [category willChangeValueForKey:@"image"];
    [super removeObjects:objects];
    [category didChangeValueForKey:@"image"];

    [self writeToFile];
}
//
//- (void)removeWithFile {
//    [self removeObjects:self.selectedObjects];
//        //    [self removeObjectsAtArrangedObjectIndexes:self.selectionIndexes];
//}

#pragma - drop

- (NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id<NSDraggingInfo>)draggingInfo proposedIndex:(NSInteger *)proposedDropIndex dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation {
    if ([[draggingInfo draggingSource] isEqualTo: _imageCollectionView]) {
        return NSDragOperationGeneric;
    }

    NSPasteboard *pboard = [draggingInfo draggingPasteboard];

    if ([pboard.types containsObject:NSFilenamesPboardType]) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];

        NSInteger numberOfImagesToAdd = [self dropFiles:files];

        if (numberOfImagesToAdd > 0) {
//            [collectionView setDropRow:[collectionView numberOfRows] dropOperation:NSTableViewDropAbove];
            return NSDragOperationGeneric;
        }
    }

    return NSDragOperationNone;
}

- (BOOL)collectionView:(NSCollectionView *)collectionView acceptDrop:(id<NSDraggingInfo>)draggingInfo index:(NSInteger)index dropOperation:(NSCollectionViewDropOperation)dropOperation {
    if ([[draggingInfo draggingSource] isEqualTo: _imageCollectionView]) {
        [self rearrangeSelectedObjectsAtIndex:index];
    }
    else {
        [self commitChangesAtIndex:index];
    }

    return YES;
}

- (id<NSPasteboardWriting>)collectionView:(NSCollectionView *)collectionView pasteboardWriterForItemAtIndex:(NSUInteger)index {
    return self.arrangedObjects[index];
}

#pragma mark IBAction

- (IBAction)add:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.allowsMultipleSelection = YES;
    panel.canChooseDirectories = NO;
    panel.allowedFileTypes = SUPPORT_IMAGE_TYPES;

    [panel beginSheetModalForWindow:self.imageCollectionView.window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSArray *URLs = [panel URLs];

            for (NSURL *URL in URLs) {
                NPImageWrapper *image = [[NPImageWrapper alloc] initWithPath:URL.path];
                [self pushObject:image];
            }

            [self commitChanges];
        }
    }];
}

- (IBAction)remove:(id)sender {
    [self removeObjects:self.selectedObjects];
}

- (IBAction)clear:(id)sender {
    NSAlert *alert = [NSAlert new];
    [alert addButtonWithTitle:@"OK"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Clear all emojis?"];
    [alert setInformativeText:@"All emojis in this category will be removed."];
    alert.alertStyle = NSCriticalAlertStyle;

    if ([alert runModal] != NSAlertFirstButtonReturn) {
        return;
    }

    [self removeObjects:self.content];
}

@end
