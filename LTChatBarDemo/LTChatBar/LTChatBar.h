//
//  LTChatBar.h
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/25.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTChatBarHeader.h"

@class LTEmojiGroup;
@class LTChatInputView;
@class LTChatEmojiView;
@class LTChatMoreView;

@protocol LTChatBarDelegate;

@interface LTChatBar : UIView

/** 输入框 */
@property (nonatomic, strong) LTChatInputView *inputView;
/** 表情视图 */
@property (nonatomic, strong) LTChatEmojiView *emojiView;
/** 更多视图 */
@property (nonatomic, strong) LTChatMoreView *moreView;

@property (nonatomic, weak) id <LTChatBarDelegate> delegate;

@end


@protocol LTChatBarDelegate <NSObject>

@optional

/**
 输入框高度变换

 @param chatBar 输入框控制器
 @param height 高度
 */
- (void)chatBar:(LTChatBar *)chatBar didChangeInputViewHeight:(CGFloat)height;

/**
 点击添加表情按钮

 @param chatBar 输入框控制器
 @param addButton 添加按钮
 */
- (void)chatBar:(LTChatBar *)chatBar clickAddAction:(UIButton *)addButton;

/**
 选择表情组

 @param chatBar 输入框控制器
 @param emojiGroup 表情组
 */
- (void)chatBar:(LTChatBar *)chatBar didSelectEmojiGroup:(LTEmojiGroup *)emojiGroup;

/**
 点击发送按钮，发送表情

 @param chatBar 输入框控制器
 @param emoji  表情
 */
- (void)chatBar:(LTChatBar *)chatBar sendEmoji:(NSString *)emoji;

/**
 通过输入的文字的变化，改变输入框控制器的高度

 @param chatBar 输入框控制器
 @param height 高度
 @param inputStatus 输入框状态
 */
- (void)chatBar:(LTChatBar *)chatBar changeInputViewHeight:(CGFloat)height inputStatus:(LTChatBarStatus)inputStatus;

/**
 发送消息

 @param chatBar 输入框控制器
 @param message 发送的消息
 */
- (void)chatBar:(LTChatBar *)chatBar sendMessage:(NSString *)message;

/**
 状态改变

 @param chatBar 输入框控制器
 @param fromStatus 改变前的状态
 @param toStatus 改变后的状态
 */
- (void)chatBar:(LTChatBar *)chatBar changeStatusForm:(LTChatBarStatus)fromStatus to:(LTChatBarStatus)toStatus;

/**
 录音状态改变

 @param chatBar 输入框控制器
 @param recordStatus 录音状态
 @param voicePath 录音url
 @param recordTime 录音时长
 */
- (void)chatBar:(LTChatBar *)chatBar recordStatus:(LTChatBarRecordStatus)recordStatus voicePath:(NSString *)voicePath recordTime:(CGFloat)recordTime;

/**
 点击更多视图里面的item

 @param chatBar 输入框控制器
 @param moreStatus 点击的item
 */
- (void)chatBar:(LTChatBar *)chatBar didSelectMoreView:(LTInputViewMoreStatus)moreStatus;

@end
