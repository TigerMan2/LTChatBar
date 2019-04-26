//
//  LTChatInputView.h
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/25.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTRecordView.h"

typedef NS_ENUM(NSUInteger, LTChatBarStatus) {
    LTChatBarStatusNone = 0,    //  无状态
    LTChatBarStatusVoice,       //  语音
    LTChatBarStatusEmoji,       //  表情
    LTChatBarStatusMore,        //  更多
    LTChatBarStatusKeyboard     //  键盘
};

typedef NS_ENUM(NSUInteger, LTChatBarRecordStatus) {
    LTChatBarRecordStatusNone   =   0,  //  初始状态
    LTChatBarRecordStatusRecording,     //  正在录音
    LTChatBarRecordStatusMoveOutSide,   //  移出
    LTChatBarRecordStatusMoveInSide,    //  移进
    LTChatBarRecordStatusCancel,        //  上滑取消录音
    LTChatBarRecordStatusEnd,           //  录音结束
    LTChatBarRecordStatusToolShot       //  录音太短
};

#import "LTChatInputViewDelegate.h"

@interface LTChatInputView : UIView
/** 语音按钮 */
@property (nonatomic, strong) UIButton *voiceButton;
/** 输入框 */
@property (nonatomic, strong) UITextView *inputView;
/** 表情按钮 */
@property (nonatomic, strong) UIButton *emojiButton;
/** 更多按钮 */
@property (nonatomic, strong) UIButton *moreButton;
/** 录音按钮 */
@property (nonatomic, strong) UIButton *recordButton;
/** 聊天键盘按钮 */
@property (nonatomic, strong) LTRecordView *talkButton;
/** 输入框当前高度 */
@property (nonatomic, assign) CGFloat curHeight;
/** 键盘状态 */
@property (nonatomic, assign) LTChatBarStatus keyboardStatus;
/** 录音状态 */
@property (nonatomic, assign) LTChatBarRecordStatus recordStatus;

@property (nonatomic, weak) id <LTChatInputViewDelegate> delegate;

@end

