//
//  TMChatInputView.h
//  TMChatBarDemo
//
//  Created by Luther on 2019/5/8.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMTextView.h"
#import "TMRecordButton.h"
#import "TMChatInputItem.h"

@class TMChatInputView;

@protocol TMChatInputViewDelegate <NSObject>

@optional
- (void)chatInputView:(TMChatInputView *)inputView voiceButtonPressed:(BOOL)select keyboardState:(BOOL)change;
- (void)chatInputView:(TMChatInputView *)inputView faceButtonPressed:(BOOL)select keyboardState:(BOOL)change;
- (void)chatInputView:(TMChatInputView *)inputView moreButtonPressed:(BOOL)select keyboardState:(BOOL)change;
- (void)chatInputViewSwitchBarButtonPressed:(TMChatInputView *)inputView keyBoardState:(BOOL)change;

- (void)chatInputViewDidStartRecording:(TMChatInputView *)inputView;
- (void)chatInputViewDidCancelRecording:(TMChatInputView *)inputView;
- (void)chatInputViewDidFinishRecoding:(TMChatInputView *)inputView;
- (void)chatInputViewWillCancelRecoding:(TMChatInputView *)inputView;
- (void)chatInputViewContineRecording:(TMChatInputView *)inputView;

- (void)chatInputViewTextViewDidBeginEditing:(UITextView *)textView;
- (void)chatInputViewSendText:(NSString *)text;
- (void)chatInputViewTextViewDidChange:(UITextView *)textView;
- (void)chatInputViewTextViewDeleteBackward:(TMTextView *)textView;

@end

@interface TMChatInputView : UIView

@property (nonatomic, weak) id <TMChatInputViewDelegate> delegate;

/** 切换bar按钮 */
@property (nonatomic, strong, readonly) UIButton *switchBarButton;
/** 语音按钮 */
@property (nonatomic, strong, readonly) UIButton *voiceButton;
/** 表情按钮 */
@property (nonatomic, strong, readonly) UIButton *faceButton;
/** 更多按钮 */
@property (nonatomic, strong, readonly) UIButton *moreButton;
/** 输入框 */
@property (nonatomic, strong, readonly) TMTextView *textView;
/** 录音按钮 */
@property (nonatomic, strong, readonly) TMRecordButton *recordButton;

/** 是否显示切换bar按钮，默认是NO */
@property (nonatomic, assign) BOOL allowSwitchBar;
/** 是否显示表情按钮，默认是YES */
@property (nonatomic, assign) BOOL allowFace;
/** 是否显示更多按钮，默认是YES */
@property (nonatomic, assign) BOOL allowMore;
/** 是否显示语音按钮，默认是YES */
@property (nonatomic, assign) BOOL allowVoice;

/** 语音按钮是否选中 */
@property (nonatomic, assign, readonly) BOOL voiceSelected;
/** 表情按钮是否选中 */
@property (nonatomic, assign, readonly) BOOL faceSelected;
/** 更多按钮是否选中 */
@property (nonatomic, assign, readonly) BOOL moreSelected;
/** 切换bar按钮是否选中 */
@property (nonatomic, assign, readonly) BOOL switchBarSelected;

/** 配置TextView内容 */
- (void)setTextViewContent:(NSString *)text;
- (void)clearTextViewContent;

/** 配置TextView的placeHolder */
- (void)setTextViewPlaceHolder:(NSString *)placeHolder;
- (void)setTextViewPlaceHolderColor:(UIColor *)placeHolderColor;

/** 加载按钮的图片 */
- (void)loadBarItems:(NSArray <TMChatInputItem *> *)items;


@end

