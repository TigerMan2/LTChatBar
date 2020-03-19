//
//  TMChatMoreItem.m
//  TMChatBarDemo
//
//  Created by Luther on 2019/5/9.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "TMChatMoreItem.h"

@implementation TMChatMoreItem

+ (instancetype)moreItemWithPicName:(NSString *)picName highLightPicName:(NSString *)highLightPicName itemName:(NSString *)itemName {
    return [[self alloc] initWithPicName:picName highLightPicName:highLightPicName itemName:itemName];
}

- (instancetype)initWithPicName:(NSString *)picName highLightPicName:(NSString *)highLightPicName itemName:(NSString *)itemName
{
    self = [super init];
    if (self) {
        self.itemPicName = picName;
        self.itemHighLightPicName = highLightPicName;
        self.itemName = itemName;
    }
    return self;
}

@end
