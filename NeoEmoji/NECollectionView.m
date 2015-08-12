//
//  NECollectionView.m
//  NeoEmoji
//
//  Created by Neo He on 11/8/15.
//  Copyright (c) 2015 Neo He. All rights reserved.
//

#import "NECollectionView.h"
#import "NPImagesController.h"

@implementation NECollectionView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (IBAction)openDocument:(id)sender {
    [(NPImagesController *)self.delegate add:sender];
}

- (IBAction)copy:(id)sender {
    NSPasteboard *pboard = [NSPasteboard generalPasteboard];
    [pboard clearContents];
    NPImagesController *imagesController = (NPImagesController *)self.delegate;
    NSArray *imagesToCopy = imagesController.selectedObjects;

    [pboard writeObjects:imagesToCopy];
}

- (IBAction)paste:(id)sender {
    NSPasteboard *pboard = [NSPasteboard generalPasteboard];
    NSArray *copiedImages = [pboard readObjectsForClasses:@[[NSURL class]] options:nil];
    if ([copiedImages count] == 0) {
        return;
    }

    NSMutableArray *pathOfCopiedImages = [NSMutableArray arrayWithCapacity:[copiedImages count]];
    for (NSURL *URL in copiedImages) {
        if ([URL path] != nil) {
            [pathOfCopiedImages addObject:[URL path]];
        }
    }

    NPImagesController *imagesController = (NPImagesController *)self.delegate;
    NSInteger numberOfImagesToAdd = [imagesController dropFiles:pathOfCopiedImages];
    if (numberOfImagesToAdd > 0) {
        [imagesController commitChanges];
    }
}

- (IBAction)delete:(id)sender {
    [(NPImagesController *)self.delegate remove:sender];
}

- (IBAction)clear:(id)sender {
    [(NPImagesController *)self.delegate clear:sender];
}

@end
