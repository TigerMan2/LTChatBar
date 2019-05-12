//
//  LTChatInputItem.h
//  LTChatBarDemo
//
//  Created by Luther on 2019/5/9.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LTChatButtonType) {
    LTChatButtonTypeVoice,
    LTChatButtonTypeFace,
    LTChatButtonTypeMore,
    LTChatButtonTypeSwitchBar,
};

@interface LTChatInputItem : NSObject

@property (nonatomic, strong) NSString *normalStr;
@property (nonatomic, strong) NSString *selectedStr;
@property (nonatomic, strong) NSString *highLightStr;
@property (nonatomic, assign) LTChatButtonType itemType;

+ (instancetype)barItemWithNormalImageStr:(NSString *)normalStr selectedImageStr:(NSString *)selectedStr highLightImageStr:(NSString *)highLightStr itemType:(LTChatButtonType)itemType;

@end

