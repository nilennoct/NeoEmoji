//
//  NEDataManager.m
//  NeoEmoji
//
//  Created by Neo on 12/8/15.
//  Copyright (c) 2015 Neo He. All rights reserved.
//

#import "NEDataManager.h"

static NEDataManager *sharedInstance = nil;

@implementation NEDataManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NEDataManager alloc] init];
    });

    return sharedInstance;
}

- (id)readDataForKey:(NSString *)key {
    NSData *dataToRead = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!dataToRead) {
        return nil;
    }

    return [NSKeyedUnarchiver unarchiveObjectWithData:dataToRead];
}

- (void)writeData:(id)data forKey:(NSString *)key {
    NSData *dataToWrite = [NSKeyedArchiver archivedDataWithRootObject:data];
    [[NSUserDefaults standardUserDefaults] setObject:dataToWrite forKey:key];
}

@end
