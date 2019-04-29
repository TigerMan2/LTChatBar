//
//  LTChatInputView.m
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/25.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "LTChatInputView.h"
#import "UIView+Frame.h"
#import "UIColor+LT.h"
#import "KSystemAuthorization.h"


@interface LTChatInputView () <UITextViewDelegate,LTChatInputViewDelegate>
{
    BOOL isAuthorized;
}
@property (nonatomic, assign) NSRange lastRange;
@property (nonatomic, assign) BOOL canceled;
@end

@implementation LTChatInputView

#pragma mark - 懒加载
- (UIButton *)voiceButton {
    if (!_voiceButton) {
        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceButton.frame = CGRectMake(0, 0, CHATBAR_HEIGHT - 10, CHATBAR_HEIGHT);
        [_voiceButton setImage:[UIImage imageNamed:@"icon_message_voiceBtn"] forState:UIControlStateNormal];
        [_voiceButton setImageEdgeInsets:UIEdgeInsetsMake(10, 5, 10, 5)];
        [_voiceButton addTarget:self action:@selector(clickVoiceAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceButton;
}

- (UITextView *)inputView {
    if (!_inputView) {
        _inputView = [[UITextView alloc] initWithFrame:CGRectMake(self.voiceButton.maxX, CHATBAR_BACKGROUND_SPACE, kWIDTH - 3 * (CHATBAR_HEIGHT - 10), CHATBAR_HEIGHT - 2 * CHATBAR_BACKGROUND_SPACE)];
        _inputView.delegate = self;
        _inputView.textColor = CHATBAR_TEXTCOLOR;
        _inputView.font = [UIFont systemFontOfSize:CHATBAR_TEXT_FONT];
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.bounces = NO;
        _inputView.returnKeyType = UIReturnKeySend;
        _inputView.layer.cornerRadius = 4;
        _inputView.layer.masksToBounds = YES;
        _inputView.allowsEditingTextAttributes = YES;
        _inputView.layoutManager.allowsNonContiguousLayout = NO;
    }
    return _inputView;
}

- (UIButton *)emojiButton {
    if (!_emojiButton) {
        _emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _emojiButton.frame = CGRectMake(self.inputView.maxX, 0, CHATBAR_HEIGHT - 10, CHATBAR_HEIGHT);
        [_emojiButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 5)];
        [_emojiButton setImage:[UIImage imageNamed:@"icon_message_expression"] forState:UIControlStateNormal];
        [_emojiButton addTarget:self action:@selector(clickEmojiAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiButton;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.frame = CGRectMake(self.emojiButton.maxX, 0, CHATBAR_HEIGHT - 10, CHATBAR_HEIGHT);
        [_moreButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 5)];
        [_moreButton setImage:[UIImage imageNamed:@"icon_message_more"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(clickMoreAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (LTRecordView *)talkButton {
    if (!_talkButton) {
        _talkButton = [[LTRecordView alloc] initWithFrame:self.inputView.frame];
        [_talkButton setBackgroundColor:[UIColor clearColor]];
        [_talkButton.layer setMasksToBounds:YES];
        [_talkButton.layer setCornerRadius:4.0f];
        [_talkButton.layer setBorderWidth:0.5f];
        [_talkButton.layer setBorderColor:[UIColor grayColor].CGColor];
        [_talkButton setHidden:YES];
        _talkButton.userInteractionEnabled = NO;
    }
    return _talkButton;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    self.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
    self.keyboardStatus = LTChatBarStatusNone;
    
    [self addSubview:self.voiceButton];
    [self addSubview:self.inputView];
    [self addSubview:self.emojiButton];
    [self addSubview:self.moreButton];
    [self addSubview:self.talkButton];
    
    self.userInteractionEnabled = YES;
    self.curHeight = CHATBAR_HEIGHT;
    
    [self.inputView addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew||NSKeyValueChangeOldKey context:nil];
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    float y = self.lt_h - CHATBAR_HEIGHT;
    if (self.keyboardStatus == LTChatBarStatusVoice) {
        y = self.lt_h - CHATBAR_HEIGHT - kTabbarSafeBottomMargin;
    }
    if (self.voiceButton.lt_y != y) {
        
        self.inputView.lt_h = self.lt_h - 2 * CHATBAR_BACKGROUND_SPACE;
        self.voiceButton.lt_y = y;
        self.emojiButton.lt_y = self.voiceButton.lt_y;
        self.moreButton.lt_y = self.voiceButton.lt_y;
    }
}

#pragma mark - 响应事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"]) {
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.inputView scrollRangeToVisible:NSMakeRange(self.inputView.text.length, 1)];
}

- (BOOL)resignFirstResponder {
    if (self.keyboardStatus == LTChatBarStatusVoice) {
        [self.emojiButton setImage:[UIImage imageNamed:@"icon_message_expression"] forState:UIControlStateNormal];
        [self.voiceButton setImage:[UIImage imageNamed:@"icon_message_keyboard"] forState:UIControlStateNormal];
    } else {
        [self.emojiButton setImage:[UIImage imageNamed:@"icon_message_expression"] forState:UIControlStateNormal];
        [self.voiceButton setImage:[UIImage imageNamed:@"icon_message_voiceBtn"] forState:UIControlStateNormal];
    }
    [self.inputView resignFirstResponder];
    
    return [super resignFirstResponder];
}

- (BOOL)becomeFirstResponder {
    [self.inputView becomeFirstResponder];
    return [super becomeFirstResponder];
}

#pragma mark - 点击事件
/** 点击切换语音或键盘 */
- (void)clickVoiceAction:(UIButton *)sender {
    
    LTChatBarStatus lastStatus = self.keyboardStatus;
    if (self.keyboardStatus != LTChatBarStatusVoice) {
        isAuthorized = [[KSystemAuthorization shareInstance] checkAudioAuthorization];
        if (!isAuthorized) {
            [[KSystemAuthorization shareInstance] settingAuthorizationWithTitle:@"权限设置" message:@"录音需要访问你的麦克风权限" cancel:^(BOOL isCancel) {
                isAuthorized = !isCancel;
            }];
        }
        
        self.keyboardStatus = LTChatBarStatusVoice;
        self.curHeight = kTabbarHeight;
        self.lt_h = self.curHeight;
        
        [self.inputView resignFirstResponder];
        //判断最后的状态是不是显示表情
        if (lastStatus == LTChatBarStatusEmoji) {
            [self.emojiButton setImage:[UIImage imageNamed:@"icon_message_expression"] forState:UIControlStateNormal];
        }
        
        [_voiceButton setImage:[UIImage imageNamed:@"icon_message_keyboard"] forState:UIControlStateNormal];
        [self.inputView setHidden:YES];
        [self.talkButton setHidden:NO];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputView:changeKeyboardStatus:nowStatus:)]) {
            [self.delegate inputView:self changeKeyboardStatus:lastStatus nowStatus:LTChatBarStatusVoice];
        }
        
    } else {
        
        self.keyboardStatus = LTChatBarStatusKeyboard;
        [self.inputView becomeFirstResponder];
        
        [self.inputView setHidden:NO];
        [self.talkButton setHidden:YES];
        
        [_voiceButton setImage:[UIImage imageNamed:@"icon_message_voiceBtn"] forState:UIControlStateNormal];
        [self.emojiButton setImage:[UIImage imageNamed:@"icon_message_expression"] forState:UIControlStateNormal];
        
        [self textViewDidChange:self.inputView];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputView:changeKeyboardStatus:nowStatus:)]) {
            [self.delegate inputView:self changeKeyboardStatus:lastStatus nowStatus:LTChatBarStatusKeyboard];
        }
    }
}

/** 输入表情 */
- (void)clickEmojiAction:(UIButton *)sender {
    LTChatBarStatus lastStauts = self.keyboardStatus;
    if (lastStauts != LTChatBarStatusEmoji) {
        self.keyboardStatus = LTChatBarStatusEmoji;
        
        if (lastStauts == LTChatBarStatusKeyboard) {
            [self.inputView resignFirstResponder];
        }
        
        //显示键盘图标
        [self.emojiButton setImage:[UIImage imageNamed:@"icon_message_keyboard"] forState:UIControlStateNormal];
        [_voiceButton setImage:[UIImage imageNamed:@"icon_message_voiceBtn"] forState:UIControlStateNormal];
        
        if (self.inputView.hidden) {
            self.inputView.hidden = NO;
            self.talkButton.hidden = YES;
        }
        
        [self textViewDidChange:self.inputView];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputView:changeKeyboardStatus:nowStatus:)]) {
            [self.delegate inputView:self changeKeyboardStatus:lastStauts nowStatus:LTChatBarStatusEmoji];
            //最后的状态是显示键盘，需要先收起键盘
        }
    } else {
        self.keyboardStatus = LTChatBarStatusKeyboard;
        
        [self.inputView becomeFirstResponder];
        
        [self.emojiButton setImage:[UIImage imageNamed:@"icon_message_expression"] forState:UIControlStateNormal];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputView:changeKeyboardStatus:nowStatus:)]) {
            [self.delegate inputView:self changeKeyboardStatus:lastStauts nowStatus:LTChatBarStatusKeyboard];
        }
    }
}

/** 点击更多按钮 */
- (void)clickMoreAction:(UIButton *)sender {
    
    LTChatBarStatus lastStatus = self.keyboardStatus;
    
    if (lastStatus != LTChatBarStatusMore) {
        self.keyboardStatus = LTChatBarStatusMore;
        [self.emojiButton setImage:[UIImage imageNamed:@"icon_message_expression"] forState:UIControlStateNormal];
        [self.voiceButton setImage:[UIImage imageNamed:@"icon_message_voiceBtn"] forState:UIControlStateNormal];
        [self.inputView setHidden:NO];
        [self.talkButton setHidden:YES];
        self.talkButton.userInteractionEnabled = NO;
        [self.inputView resignFirstResponder];
        [self textViewDidChange:self.inputView];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputView:changeKeyboardStatus:nowStatus:)]) {
            [self.delegate inputView:self changeKeyboardStatus:lastStatus nowStatus:LTChatBarStatusMore];
        }
    }
}

#pragma mark - 录音部分
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.keyboardStatus != LTChatBarStatusVoice) {
        return;
    }
    if (!isAuthorized) {
        [[KSystemAuthorization shareInstance] settingAuthorizationWithTitle:@"权限设置" message:@"录音需要访问你的麦克风权限" cancel:^(BOOL isCancel) {
            isAuthorized = !isCancel;
        }];
        return;
    } else {
        CGPoint touchPoint = [[touches anyObject] locationInView:self];
        
        if (CGRectContainsPoint(self.talkButton.frame, touchPoint)) {
            _canceled = NO;
            self.recordStatus = LTChatBarRecordStatusRecording;
            self.talkButton.textLabel.text = @"松开 发送";
        } else {
            _canceled = YES;
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_canceled || !isAuthorized || self.keyboardStatus != LTChatBarStatusVoice) {
        return;
    }
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.talkButton.frame, touchPoint)) {
        self.recordStatus = LTChatBarRecordStatusMoveInSide;
        self.talkButton.textLabel.text = @"松开 发送";
    } else {
        self.recordStatus = LTChatBarRecordStatusMoveOutSide;
        self.talkButton.textLabel.text = @"松开 取消";
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_canceled || !isAuthorized || self.keyboardStatus != LTChatBarStatusVoice) {
        return;
    }
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    self.recordStatus = CGRectContainsPoint(self.talkButton.frame, touchPoint) ? LTChatBarRecordStatusEnd : LTChatBarRecordStatusCancel;
    self.talkButton.textLabel.text = @"按住 说话";
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_canceled || !isAuthorized || self.keyboardStatus != LTChatBarStatusVoice) {
        return;
    }
    self.recordStatus = LTChatBarRecordStatusCancel;
    self.talkButton.textLabel.text = @"按住 说话";
}

/**
 发送当前消息
 */
- (void)sendCurrentMessage {
    if (self.inputView.text.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputView:sendTextMessage:)]) {
            [self.delegate inputView:self sendTextMessage:self.inputView.text];
        }
        self.inputView.text = @"";
    }
}

/** 删除表情 */
- (void)deleteEmoji {
    if (((int)self.inputView.text.length - 1) >= 0) {
        [self textView:self.inputView shouldChangeTextInRange:NSMakeRange(self.inputView.text.length - 1, 1) replacementText:@""];
        [self textViewDidChange:self.inputView];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    LTChatBarStatus lastStatus = self.keyboardStatus;
    self.keyboardStatus = LTChatBarStatusKeyboard;
    if (lastStatus == LTChatBarStatusEmoji) {
        [_emojiButton setImage:[UIImage imageNamed:@"icon_message_expression"] forState:UIControlStateNormal];
    } else if (lastStatus == LTChatBarStatusMore) {
        
        [_moreButton setImage:[UIImage imageNamed:@"icon_message_more"] forState:UIControlStateNormal];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputView:changeKeyboardStatus:nowStatus:)]) {
        [self.delegate inputView:self changeKeyboardStatus:lastStatus nowStatus:LTChatBarStatusKeyboard];
    }
}

/** textView输入内容一改变就调用 */
- (void)textViewDidChange:(UITextView *)textView {
    
    CGFloat height = [self.inputView sizeThatFits:CGSizeMake(textView.lt_w, MAXFLOAT)].height;
    //当高度大于最小高度时
    height = height > CHATBAR_TEXT_MIN_HEIGHT ? height : CHATBAR_TEXT_MIN_HEIGHT;
    if (height <= CHATBAR_TEXT_MIN_HEIGHT) {
        self.inputView.showsVerticalScrollIndicator = NO;
    } else {
        self.inputView.showsVerticalScrollIndicator = YES;
    }
    
    height = height < CHATBAR_TEXT_MAX_HEIGHT ? height : CHATBAR_TEXT_MAX_HEIGHT;
    self.curHeight = height + CHATBAR_BACKGROUND_SPACE * 2;
    
    [self.inputView scrollRangeToVisible:NSMakeRange(self.inputView.text.length, 1)];
    
    if (self.lt_h != self.curHeight) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputView:changeInputViewHeight:)]) {
            [self.delegate inputView:self changeInputViewHeight:self.curHeight];
        }
    }
    
    if (height != textView.lt_h) {
        [UIView animateWithDuration:0.05 animations:^{
            textView.lt_h = height;
        }];
    }
    
    if ([textView.text isEqualToString:@""] || textView.text.length == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteEmojiToEmpty" object:nil];
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    self.lastRange = range;
    if ([text isEqualToString:@"\n"]) {
        [self sendCurrentMessage];
        self.curHeight = CHATBAR_HEIGHT;
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputView:changeInputViewHeight:)]) {
            [self.delegate inputView:self changeInputViewHeight:self.curHeight];
        }
        return NO;
    }
    else if (textView.text.length > 0  && [text isEqualToString:@""]) {
        //删除
        if ([textView.text characterAtIndex:range.location] == ']') {
            NSUInteger location = range.location;
            NSUInteger length = range.length;
            while (location != 0) {
                location --;
                length ++;
                char c = [textView.text characterAtIndex:location];
                if (c == '[') {
                    textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:@""];
                    [self textViewDidChange:textView];
                    return NO;
                } else if (c == ']') {
                    return YES;
                }
            }
        }
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

- (void)dealloc {
    [self.inputView removeObserver:self forKeyPath:@"text"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
