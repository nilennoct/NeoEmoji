//
//  NEDataManager.h
//  NeoEmoji
//
//  Created by Neo on 12/8/15.
//  Copyright (c) 2015 Neo He. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CATEGORY_DATA_KEY   @"CategoryData"
#define CATEGORY_INDEX_KEY  @"CategorySelectionIndex"

@interface NEDataManager : NSObject

+ (instancetype)sharedInstance;

- (id)readDataForKey:(NSString *)key;
- (void)writeData:(id)data forKey:(NSString *)key;

@end
