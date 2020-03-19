//
//  TMChatInputItem.h
//  TMChatBarDemo
//
//  Created by Luther on 2019/5/9.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TMChatButtonType) {
    TMChatButtonTypeVoice,
    TMChatButtonTypeFace,
    TMChatButtonTypeMore,
    TMChatButtonTypeSwitchBar,
};

@interface TMChatInputItem : NSObject

@property (nonatomic, strong) NSString *normalStr;
@property (nonatomic, strong) NSString *selectedStr;
@property (nonatomic, strong) NSString *highLightStr;
@property (nonatomic, assign) TMChatButtonType itemType;

+ (instancetype)barItemWithNormalImageStr:(NSString *)normalStr selectedImageStr:(NSString *)selectedStr highLightImageStr:(NSString *)highLightStr itemType:(TMChatButtonType)itemType;

@end

