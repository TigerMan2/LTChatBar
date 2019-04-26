//
//  LTChatInputViewDelegate.h
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/26.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTChatEmojiView.h"

@class LTEmojiModel;
@class LTChatInputView;
@class LTChatMoreView;

@protocol LTChatInputViewDelegate <NSObject>

@optional
#pragma mark - 表情页面
/**
 点击选择表情

 @param emojiView 表情所在页面
 @param emojiDic 表情模型
 @param type 表情类型
 */
- (void)emojiView:(LTChatEmojiView *)emojiView
   didSelectEmoji:(LTEmojiModel *)emojiDic
        emojiType:(LTEmojiType)type;

/** 删除光标前的表情 */
- (void)emojiViewDeleteEmoji;

/**
 点击发送按钮，发送表情

 @param emojiView 表情所在页面
 @param emoji 表情
 */
- (void)emojiView:(LTChatEmojiView *)emojiView
        sendEmoji:(NSString *)emoji;

#pragma mark - 输入框代理部分

/**
 通过输入文字的变化，改变输入框的高度

 @param inputView 输入框
 @param height 高度
 */
- (void)inputView:(LTChatInputView *)inputView changeInputViewHeight:(CGFloat)height;

/**
 发送文字消息

 @param inputView 输入框
 @param textMessage 输入框的文字
 */
- (void)inputView:(LTChatInputView *)inputView sendTextMessage:(NSString *)textMessage;

/**
 改变状态

 @param inputView 输入框
 @param oldStatus 改变之前的状态
 @param nowStatus 改变之后的状态
 */
- (void)inputView:(LTChatInputView *)inputView changeKeyboardStatus:(LTChatBarStatus)oldStatus nowStatus:(LTChatBarStatus)nowStatus;

/**
 点击输入框更多按钮事件

 @param inputView 输入框
 @param keyboardStatus 键盘状态
 */
- (void)inputView:(LTChatInputView *)inputView clickMore:(LTChatBarStatus)keyboardStatus;

@end
