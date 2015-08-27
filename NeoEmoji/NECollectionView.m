//
//  NECollectionView.m
//  NeoEmoji
//
//  Created by Neo He on 11/8/15.
//  Copyright (c) 2015 Neo He. All rights reserved.
//

#import "NECollectionView.h"
#import "NPImagesController.h"
#import "NPImageWrapper.h"

@implementation NECollectionView {
    NSInteger _lastIndexOfItem;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        NSLog(@"initWithCoder");
        _lastIndexOfItem = NSNotFound;

        NSTrackingAreaOptions options = (NSTrackingActiveAlways | NSTrackingInVisibleRect |
                                         NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved);

//        [self addTrackingRect:self.bounds owner:self userData:nil assumeInside:YES];
        NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:[self bounds] options:options owner:self userInfo:nil];

        [self addTrackingArea:area];
    }

    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)mouseMoved:(NSEvent *)theEvent {
    NSRect bounds = self.superview.bounds;

    NSPoint mouseLocation = [self convertPoint:theEvent.locationInWindow fromView:nil];
    if (mouseLocation.x < 0 || mouseLocation.y < 0) {
        self.previewView.hidden = YES;
        return;
    }

    NSInteger indexOfX = (int)(mouseLocation.x / 50.f);
    NSInteger indexOfY = (int)((mouseLocation.y) / 50.f);

    if (indexOfX >= self.numberOfColumns) {
        self.previewView.hidden = YES;
        return;
    }

    NSInteger indexOfItem = indexOfY * self.numberOfColumns + indexOfX;
//    NSLog(@"%ld", indexOfItem);

    if (_lastIndexOfItem != indexOfItem) {
        if (indexOfItem < 0 || indexOfItem >= [self.content count]) {
            self.previewView.hidden = YES;
        }
        else {
//            NSLog(@"%ld, %ld", indexOfX, indexOfY);
//            NSLog(@"%ld", indexOfItem);
            NPImageWrapper *imageWrap = [self.content objectAtIndex:indexOfItem];

            CGFloat locationX = indexOfX < self.numberOfColumns / 2 ? NSWidth(self.frame) - 100.f : 0;
            NSRect frame = NSMakeRect(locationX, NSMinY(bounds), 100.f, 100.f);
            NSRect realFrame = [self.superview convertRect:frame toView:nil];

            self.previewView.frame = realFrame;
            NSImage *image = [[NSImage alloc] initWithContentsOfFile:imageWrap.path];
            self.previewView.imageView.image = image;
            self.previewView.hidden = NO;
        }
        _lastIndexOfItem = indexOfItem;
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    self.previewView.hidden = YES;
    _lastIndexOfItem = NSNotFound;
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
