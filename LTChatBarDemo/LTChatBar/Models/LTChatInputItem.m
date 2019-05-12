//
//  LTChatInputItem.m
//  LTChatBarDemo
//
//  Created by Luther on 2019/5/9.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "LTChatInputItem.h"

@implementation LTChatInputItem

+ (instancetype)barItemWithNormalImageStr:(NSString *)normalStr selectedImageStr:(NSString *)selectedStr highLightImageStr:(NSString *)highLightStr itemType:(LTChatButtonType)itemType {
    return [[self alloc] initWithNormalImageStr:normalStr selectedImageStr:selectedStr highLightImageStr:highLightStr itemType:itemType];
}

- (instancetype)initWithNormalImageStr:(NSString *)normalStr selectedImageStr:(NSString *)selectedStr highLightImageStr:(NSString *)highLightStr itemType:(LTChatButtonType)itemType {
    self = [super init];
    if (self) {
        self.normalStr = normalStr;
        self.selectedStr = selectedStr;
        self.highLightStr = highLightStr;
        self.itemType = itemType;
    }
    return self;
}

@end
