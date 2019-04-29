//
//  LTChatBar.m
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/25.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "LTChatBar.h"
#import "LTChatInputView.h"
#import "LTChatMoreView.h"
#import "LTChatEmojiView.h"
#import "LTEmojiModel.h"
#import "UIView+Frame.h"
#import "UIColor+LT.h"

@interface LTChatBar () <LTChatInputViewDelegate>

/** 文本消息 */
@property (nonatomic, strong) NSString *textMessage;
/** 输入框高度 */
@property (nonatomic, assign) CGFloat inputViewHeight;
/** 键盘frame */
@property (nonatomic, assign) CGRect keyboardFrame;

@end

@implementation LTChatBar

#pragma mark - 懒加载
- (LTChatEmojiView *)emojiView {
    if (!_emojiView) {
        _emojiView = [[LTChatEmojiView alloc] initWithFrame:CGRectMake(0, self.inputView.maxY, kWIDTH, CHATBAR_EMOJI_VIEW_HEIGHT)];
        _emojiView.delegate = self;
    }
    return _emojiView;
}

- (LTChatMoreView *)moreView {
    if (!_moreView) {
        _moreView = [[LTChatMoreView alloc] initWithFrame:CGRectMake(0, self.inputView.maxY, kWIDTH, CHATBAR_MORE_VIEW_HEIGHT)];
    }
    return _moreView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize {
    
    self.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
    
    self.inputView = [[LTChatInputView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, 50)];
    self.inputView.delegate = self;
    [self addSubview:self.inputView];
    
    [self moreView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectedMoreView:) name:@"KInputBoxDidSelectedMoreView" object:nil];
    
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.inputView.lt_h = self.inputView.curHeight;
    if (self.inputView.keyboardStatus == LTChatBarStatusEmoji) {
        self.emojiView.lt_h = self.inputView.curHeight;
    } else if (self.inputView.keyboardStatus == LTChatBarStatusMore) {
        self.moreView.lt_h = self.inputView.curHeight;
    }
}

- (BOOL)resignFirstResponder {
    
    if (self.inputView.keyboardStatus != LTChatBarStatusVoice) {
        self.inputView.keyboardStatus = LTChatBarStatusNone;
    }
    
    [self.inputView resignFirstResponder];
    [self.emojiView removeFromSuperview];
    [self.moreView removeFromSuperview];
    
    return [super resignFirstResponder];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    
    self.keyboardFrame = CGRectZero;
    if (self.inputView.keyboardStatus == LTChatBarStatusEmoji || self.inputView.keyboardStatus == LTChatBarStatusMore) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:didChangeInputViewHeight:)]) {
        [self.delegate chatBar:self didChangeInputViewHeight:self.inputView.curHeight];
    }
}

- (void)keyboardFrameWillChange:(NSNotification *)noti {
    
    self.keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (self.inputView.keyboardStatus == LTChatBarStatusKeyboard && self.keyboardFrame.size.height <= CHATBAR_MORE_VIEW_HEIGHT) {
        return;
    } else if ((self.inputView.keyboardStatus == LTChatBarStatusEmoji || self.inputView.keyboardStatus == LTChatBarStatusMore) && self.keyboardFrame.size.height <= CHATBAR_MORE_VIEW_HEIGHT) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:didChangeInputViewHeight:)]) {
        // 改变控制器.View 的高度 键盘的高度 + 当前的 49
        [self.delegate chatBar:self didChangeInputViewHeight:self.keyboardFrame.size.height + self.inputView.curHeight];
    }
}

- (void)didSelectedMoreView:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    LTInputViewMoreStatus inputViewMoreStatus = [userInfo[@"status"] unsignedIntegerValue];
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:didSelectMoreView:)]) {
        [self.delegate chatBar:self didSelectMoreView:inputViewMoreStatus];
    }
}

#pragma mark - LTChatInputViewDelegate
- (void)inputView:(LTChatInputView *)inputView changeKeyboardStatus:(LTChatBarStatus)oldStatus nowStatus:(LTChatBarStatus)nowStatus {
    switch (nowStatus) {
        case LTChatBarStatusNone:
            
            break;
        case LTChatBarStatusKeyboard:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.moreView removeFromSuperview];
                [self.emojiView removeFromSuperview];
            });
        }
            break;
        case LTChatBarStatusVoice:
        {
            if (oldStatus == LTChatBarStatusMore || oldStatus == LTChatBarStatusEmoji) {
                [self.moreView removeFromSuperview];
                [self.emojiView removeFromSuperview];
                [UIView animateWithDuration:0.15 animations:^{
                    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:didChangeInputViewHeight:)]) {
                        [self.delegate chatBar:self didChangeInputViewHeight:kTabbarHeight];
                    }
                }];
            } else {
                [UIView animateWithDuration:0.15 animations:^{
                    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:didChangeInputViewHeight:)]) {
                        [self.delegate chatBar:self didChangeInputViewHeight:kTabbarHeight];
                    }
                }];
            }
        }
            break;
        case LTChatBarStatusEmoji:
        {
            if (oldStatus == LTChatBarStatusVoice || oldStatus == LTChatBarStatusNone) {
                [self.emojiView setLt_h:self.inputView.curHeight - kTabbarSafeBottomMargin];
                //添加表情
                BOOL noEmpty = self.inputView.inputView.text.length > 0;
                [self addSubview:self.emojiView];
                if (noEmpty) {
                    [self.emojiView.menuView.addButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [self.emojiView.menuView.addButton setBackgroundColor:[UIColor colorWithHexString:@"0x0657b6"]];
                }
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:didChangeInputViewHeight:)]) {
                    [self.delegate chatBar:self didChangeInputViewHeight:self.inputView.curHeight + CHATBAR_EMOJI_VIEW_HEIGHT + kTabbarSafeBottomMargin];
                }
            } else {
                //表情高度变化
                self.emojiView.lt_h = self.inputView.curHeight + CHATBAR_EMOJI_VIEW_HEIGHT;
                BOOL noEmpty = self.inputView.inputView.text.length > 0;
                if (noEmpty) {
                    [self.emojiView.menuView.sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [self.emojiView.menuView.sendButton setBackgroundColor:[UIColor colorWithHexString:@"0x0657b6"]];
                }
                [self addSubview:self.emojiView];
                
                [UIView animateWithDuration:0.15 animations:^{
                    self.emojiView.lt_h = self.inputView.curHeight;
                } completion:^(BOOL finished) {
                    [self.moreView removeFromSuperview];
                }];
                
                // 整个界面高度变化
                if (oldStatus != LTChatBarStatusMore) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:didChangeInputViewHeight:)]) {
                        [self.delegate chatBar:self didChangeInputViewHeight:self.inputView.curHeight + CHATBAR_EMOJI_VIEW_HEIGHT + kTabbarSafeBottomMargin];
                    }
                }
            }
        }
            break;
        case LTChatBarStatusMore:
        {
            if (oldStatus == LTChatBarStatusVoice || oldStatus == LTChatBarStatusNone) {
                [self.moreView setLt_h:self.inputView.curHeight - kTabbarSafeBottomMargin];
                
                [self addSubview:self.moreView];
                
                [UIView animateWithDuration:0.15 animations:^{
                    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:didChangeInputViewHeight:)]) {
                        [self.delegate chatBar:self didChangeInputViewHeight:self.inputView.curHeight + CHATBAR_EMOJI_VIEW_HEIGHT + kTabbarSafeBottomMargin];
                    }
                }];
            }
            else {
                
                self.moreView.lt_y = self.inputView.curHeight + CHATBAR_EMOJI_HEIGHT;
                [self.emojiView removeFromSuperview];
                
                [self addSubview:self.moreView];
                [UIView animateWithDuration:0.15 animations:^{
                    self.moreView.lt_y = self.inputView.curHeight;
                } completion:nil];
                
                if (oldStatus != LTChatBarStatusMore) {
                    
                    [UIView animateWithDuration:0.15 animations:^{
                        if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:didChangeInputViewHeight:)]) {
                            [self.delegate chatBar:self didChangeInputViewHeight:self.inputView.curHeight + CHATBAR_EMOJI_VIEW_HEIGHT + kTabbarSafeBottomMargin];
                        }
                    }];
                }
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)inputView:(LTChatInputView *)inputView changeInputViewHeight:(CGFloat)height {
    
    self.emojiView.lt_y = height;
    self.moreView.lt_y = height;
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:didChangeInputViewHeight:)]) {
        // 除了输入框之外的高度
        CGFloat extraHeight = 0;
        if (inputView.keyboardStatus == LTChatBarStatusMore) {
            extraHeight = CHATBAR_MORE_VIEW_HEIGHT + kTabbarSafeBottomMargin;
        }
        else if (inputView.keyboardStatus == LTChatBarStatusEmoji) {
            extraHeight = CHATBAR_EMOJI_VIEW_HEIGHT + kTabbarSafeBottomMargin;
        }
        else if (inputView.keyboardStatus == LTChatBarStatusKeyboard) {
            extraHeight = self.keyboardFrame.size.height;
        }
        else {
            extraHeight = 0;
        }
        [self.delegate chatBar:self didChangeInputViewHeight:self.inputView.curHeight + extraHeight];
    }
}

- (void)inputView:(LTChatInputView *)inputView sendTextMessage:(NSString *)textMessage {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:sendMessage:)]) {
        [self.delegate chatBar:self sendMessage:textMessage];
    }
}

// 选择表情
- (void)emojiView:(LTChatEmojiView *)emojiView didSelectEmoji:(LTEmojiModel *)emojiDic emojiType:(LTEmojiType)type {
    
    NSRange range = self.inputView.inputView.selectedRange;
    
    NSString *prefix = [self.inputView.inputView.text substringToIndex:range.location];
    
    NSString *suffix = [self.inputView.inputView.text substringFromIndex:range.length + range.location];
    self.inputView.inputView.text = [NSString stringWithFormat:@"%@%@%@",prefix, emojiDic.emojiName, suffix];
}

- (void)emojiViewDeleteEmoji {
    [self.inputView deleteEmoji];
}

// 点击添加表情
- (void)emojiMenuView:(LTChatEmojiMenuView *)menuView clickAddAction:(UIButton *)addButton {
    
}

// 选择表情组
- (void)emojiMenuView:(LTChatEmojiMenuView *)menuView didSelectEmojiGroup:(LTEmojiGroup *)emojiGroup {
    
}

- (void)emojiView:(LTChatEmojiView *)emojiView sendEmoji:(NSString *)emoji {
    
    [self.inputView sendCurrentMessage];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.inputView removeFromSuperview];
    self.inputView = nil;
}

@end
