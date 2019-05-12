//
//  LTChatInputView.m
//  LTChatBarDemo
//
//  Created by Luther on 2019/5/8.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "LTChatInputView.h"
#import "LTChatMacro.h"

#define TextViewH   36
#define ItemH   kChatToolBarHeight
#define ItemW   44
#define TextViewMargin  8
#define TextViewVerticalOffset  (ItemH-TextViewH)/2.0
#define Image(str)              (str == nil || str.length == 0) ? nil : [UIImage imageNamed:str]

@interface LTChatInputView ()
<
    LTTextViewDelegate
>

@property (nonatomic, assign) CGFloat previousTextViewHeight;

/** 临时记录输入框文字 */
@property (nonatomic, copy) NSString *currentText;

@property (nonatomic, strong) UIButton *switchBarButton;
@property (nonatomic, strong) UIButton *voiceButton;
@property (nonatomic, strong) UIButton *faceButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) LTTextView *textView;
@property (nonatomic, strong) LTRecordButton *recordButton;


@property (nonatomic, assign, readwrite) BOOL voiceSelected;
@property (nonatomic, assign, readwrite) BOOL faceSelected;
@property (nonatomic, assign, readwrite) BOOL moreSelected;
@property (nonatomic, assign, readwrite) BOOL switchBarSelected;

@end

@implementation LTChatInputView

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"self.textView.contentSize"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self didDefaultValue];
        [self didInitialize];
    }
    return self;
}

- (void)didDefaultValue {
    self.allowSwitchBar = NO;
    self.allowFace = YES;
    self.allowMore = YES;
    self.allowVoice = YES;
}

- (void)didInitialize {
    
    self.previousTextViewHeight = TextViewH;
    self.backgroundColor = kChatKeyBoardColor;
    
    SEL clickSel = @selector(chatBarButtonClick:);
    self.voiceButton = [self createButton:LTChatButtonTypeVoice action:clickSel];
    self.faceButton = [self createButton:LTChatButtonTypeFace action:clickSel];
    self.moreButton = [self createButton:LTChatButtonTypeMore action:clickSel];
    self.switchBarButton = [self createButton:LTChatButtonTypeSwitchBar action:clickSel];
    self.switchBarButton.hidden = YES;
    
    self.recordButton = [[LTRecordButton alloc] init];
    
    self.textView = [[LTTextView alloc] init];
    self.textView.frame = CGRectMake(0, 0, 0, TextViewH);
    self.textView.delegate = self;
    
    [self addSubview:self.voiceButton];
    [self addSubview:self.faceButton];
    [self addSubview:self.moreButton];
    [self addSubview:self.switchBarButton];
    [self addSubview:self.recordButton];
    [self addSubview:self.textView];
    
    [self didSubviewsFrame];
    
    //KVO
    [self addObserver:self forKeyPath:@"self.textView.contentSize" options:(NSKeyValueObservingOptionNew) context:nil];
    
    __weak typeof(self) weakSelf = self;
    self.recordButton.recordTouchDownAction = ^(LTRecordButton *recordButton) {
        NSLog(@"开始录音");
        if (recordButton.highlighted) {
            recordButton.highlighted = YES;
            [recordButton setButtonStateRecording];
        }
        if ([weakSelf.delegate respondsToSelector:@selector(chatInputViewDidStartRecording:)]) {
            [weakSelf.delegate chatInputViewDidStartRecording:weakSelf];
        }
    };
    self.recordButton.recordTouchUpInsideAction = ^(LTRecordButton *recordButton) {
        NSLog(@"完成录音");
        [recordButton setButtonStateNormal];
        if ([weakSelf.delegate respondsToSelector:@selector(chatInputViewDidFinishRecoding:)]) {
            [weakSelf.delegate chatInputViewDidFinishRecoding:weakSelf];
        }
    };
    self.recordButton.recordTouchUpOutsideAction = ^(LTRecordButton *recordButton) {
        NSLog(@"取消录音");
        [recordButton setButtonStateNormal];
        if ([weakSelf.delegate respondsToSelector:@selector(chatInputViewDidCancelRecording:)]) {
            [weakSelf.delegate chatInputViewDidCancelRecording:weakSelf];
        }
    };
    //持续调用
    self.recordButton.recordTouchDragInsideAction = ^(LTRecordButton *recordButton) {
        
    };
    self.recordButton.recordTouchDragOutsideAction = ^(LTRecordButton *recordButton) {
        
    };
    //中间状态
    self.recordButton.recordTouchDragExitAction = ^(LTRecordButton *recordButton) {
        NSLog(@"将要取消录音");
        if ([weakSelf.delegate respondsToSelector:@selector(chatInputViewWillCancelRecoding:)]) {
            [weakSelf.delegate chatInputViewWillCancelRecoding:weakSelf];
        }
    };
    self.recordButton.recordTouchDragEnterAction = ^(LTRecordButton *recordButton) {
        NSLog(@"继续录音");
        if ([weakSelf.delegate respondsToSelector:@selector(chatInputViewContineRecording:)]) {
            [weakSelf.delegate chatInputViewContineRecording:weakSelf];
        }
    };
    
}

#pragma mark - 设置子视图的frame
- (void)didSubviewsFrame {
    
    CGFloat barViewH = self.frame.size.height;
    
    if (self.allowSwitchBar) {
        self.switchBarButton.frame = CGRectMake(0, barViewH - ItemH, ItemW, ItemH);
    } else {
        self.switchBarButton.frame = CGRectZero;
    }
    
    if (self.allowVoice) {
        self.voiceButton.frame = CGRectMake(CGRectGetMaxX(self.switchBarButton.frame), barViewH - ItemH, ItemW, ItemH);
    } else {
        self.voiceButton.frame = CGRectZero;
    }
    
    if (self.allowMore) {
        self.moreButton.frame = CGRectMake(self.frame.size.width - ItemW, barViewH - ItemH, ItemW, ItemH);
    } else {
        self.moreButton.frame = CGRectZero;
    }
    
    if (self.allowFace) {
        self.faceButton.frame = CGRectMake(self.frame.size.width - ItemW - CGRectGetWidth(self.moreButton.frame), barViewH - ItemH, ItemW, ItemH);
    } else {
        self.faceButton.frame = CGRectZero;
    }
    
    CGFloat textViewX = CGRectGetWidth(self.switchBarButton.frame) + CGRectGetWidth(self.voiceButton.frame);
    CGFloat textViewW = self.frame.size.width - CGRectGetWidth(self.switchBarButton.frame) - CGRectGetWidth(self.voiceButton.frame) - CGRectGetWidth(self.faceButton.frame) - CGRectGetWidth(self.moreButton.frame);
    
    //调整边距
    if (textViewX == 0) {
        textViewX = TextViewMargin;
        textViewW = textViewW - TextViewMargin;
    }
    
    if (CGRectGetWidth(self.faceButton.frame) + CGRectGetWidth(self.moreButton.frame) == 0) {
        textViewW = textViewW - TextViewMargin;
    }
    
    self.textView.frame = CGRectMake(textViewX, TextViewVerticalOffset, textViewW, self.textView.frame.size.height);
    
    self.recordButton.frame = self.textView.frame;
    
}

#pragma mark - 加载按钮的图片
- (void)loadBarItems:(NSArray <LTChatInputItem *> *)items {
    for (LTChatInputItem *item in items) {
        [self setButton:item.itemType normalImageStr:item.normalStr selectedImageStr:item.selectedStr highLightImageStr:item.highLightStr];
    }
}

#pragma mark - 调整文本内容
- (void)setTextViewContent:(NSString *)text {
    self.textView.text = text;
    self.currentText = text;
}

- (void)clearTextViewContent {
    self.textView.text = @"";
    self.currentText = @"";
}

#pragma mark - 调整placeHolder
- (void)setTextViewPlaceHolder:(NSString *)placeHolder {
    if (placeHolder == nil) {
        return;
    }
    self.textView.placeHolder = placeHolder;
}

- (void)setTextViewPlaceHolderColor:(UIColor *)placeHolderColor {
    if (placeHolderColor == nil) {
        return;
    }
    self.textView.placeHolderColor = placeHolderColor;
}

#pragma mark - 设置按钮的图片
- (void)setButton:(LTChatButtonType)buttonType normalImageStr:(NSString *)normalImageStr selectedImageStr:(NSString *)selectedImageStr highLightImageStr:(NSString *)highLightImageStr {
    UIButton *button;
    switch (buttonType) {
        case LTChatButtonTypeVoice:
            button = self.voiceButton;
            break;
        case LTChatButtonTypeFace:
            button = self.faceButton;
            break;
        case LTChatButtonTypeMore:
            button = self.moreButton;
            break;
        case LTChatButtonTypeSwitchBar:
            button = self.switchBarButton;
            break;
            
        default:
            break;
    }
    
    [button setImage:Image(normalImageStr) forState:UIControlStateNormal];
    [button setImage:Image(selectedImageStr) forState:UIControlStateSelected];
    [button setImage:Image(highLightImageStr) forState:UIControlStateHighlighted];
    
}

#pragma mark - 工具栏点击事件
- (void)chatBarButtonClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            [self handleVoiceClick:sender];
            break;
        case 2:
            [self handleFaceClick:sender];
            break;
        case 3:
            [self handleMoreClick:sender];
            break;
        case 4:
            [self handleSwitchBarClick:sender];
            break;
            
        default:
            break;
    }
}

- (void)handleVoiceClick:(UIButton *)sender {
    self.voiceSelected = self.voiceButton.selected = !self.voiceButton.selected;
    self.faceSelected = self.faceButton.selected = NO;
    self.moreSelected = self.moreButton.selected = NO;
    
    BOOL keyboardChanged = YES;
    if (sender.selected) {
        if (!self.textView.isFirstResponder) {
            keyboardChanged = NO;
        }
        
        [self adjustTextViewContentSize];
        [self.textView resignFirstResponder];
    } else {
        
        [self resumeTextViewContentSize];
        
        [self.textView becomeFirstResponder];
    }
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.recordButton.hidden = !sender.selected;
        self.textView.hidden = sender.selected;
    } completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(chatInputView:voiceButtonPressed:keyboardState:)]) {
        [self.delegate chatInputView:self voiceButtonPressed:sender.selected keyboardState:keyboardChanged];
    }
    
}

- (void)handleFaceClick:(UIButton *)sender {
    self.faceSelected = self.faceButton.selected = !self.faceButton.selected;
    self.voiceSelected = self.voiceButton.selected = NO;
    self.moreSelected = self.moreButton.selected = NO;
    
    BOOL keyboardChanged = YES;
    if (sender.selected) {
        if (!self.textView.isFirstResponder) {
            keyboardChanged = NO;
        }
        [self.textView resignFirstResponder];
    } else {
        
        [self.textView becomeFirstResponder];
    }
    
    [self resumeTextViewContentSize];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.recordButton.hidden = YES;
        self.textView.hidden = NO;
    } completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(chatInputView:faceButtonPressed:keyboardState:)]) {
        [self.delegate chatInputView:self faceButtonPressed:sender.selected keyboardState:keyboardChanged];
    }
    
}

- (void)handleMoreClick:(UIButton *)sender {
    
    self.moreSelected = self.moreButton.selected = !self.moreButton.selected;
    self.voiceSelected = self.voiceButton.selected = NO;
    self.faceSelected = self.faceButton.selected = NO;
    
    BOOL keyBoardChanged = YES;
    
    if (sender.selected)
    {
        if (!self.textView.isFirstResponder)
        {
            keyBoardChanged = NO;
        }
        [self.textView resignFirstResponder];
    }else {
        [self.textView becomeFirstResponder];
    }
    
    [self resumeTextViewContentSize];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.recordButton.hidden = YES;
        self.textView.hidden = NO;
    } completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(chatInputView:moreButtonPressed:keyboardState:)])
    {
        [self.delegate chatInputView:self moreButtonPressed:sender.selected keyboardState:keyBoardChanged];
    }
}

- (void)handleSwitchBarClick:(UIButton *)sender {
    
    BOOL keyBoardChanged = YES;
    
    self.faceSelected = self.faceButton.selected = NO;
    self.moreSelected =  self.moreButton.selected = NO;
    
    if (!self.textView.isFirstResponder)
    {
        keyBoardChanged = NO;
    }
    
    [self.textView resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(chatInputViewSwitchBarButtonPressed:keyBoardState:)])
    {
        [self.delegate chatInputViewSwitchBarButtonPressed:self keyBoardState:keyBoardChanged];
    }
}

#pragma mark - 重写set方法
- (void)setAllowSwitchBar:(BOOL)allowSwitchBar {
    _allowSwitchBar = allowSwitchBar;
    if (allowSwitchBar) {
        self.switchBarButton.hidden = NO;
    } else {
        self.switchBarButton.hidden = YES;
    }
    [self didSubviewsFrame];
}

- (void)setAllowFace:(BOOL)allowFace {
    _allowFace = allowFace;
    if (allowFace) {
        self.faceButton.hidden = NO;
    } else {
        self.faceButton.hidden = YES;
    }
    [self didSubviewsFrame];
}

- (void)setAllowMore:(BOOL)allowMore {
    _allowMore = allowMore;
    if (allowMore) {
        self.moreButton.hidden = NO;
    } else {
        self.moreButton.hidden = YES;
    }
    [self didSubviewsFrame];
}

- (void)setAllowVoice:(BOOL)allowVoice {
    _allowVoice = allowVoice;
    if (allowVoice) {
        self.voiceButton.hidden = NO;
    } else {
        self.voiceButton.hidden = YES;
    }
    [self didSubviewsFrame];
}

#pragma mark - 计算textViewContentSize改变
- (CGFloat)getTextViewContentH:(LTTextView *)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceil([textView sizeThatFits:textView.frame.size].height);
    }
    return textView.contentSize.height;
}

- (CGFloat)fontWidth {
    return 28.0f;   //16号字体
}

- (CGFloat)maxLines {
    CGFloat h = [[UIScreen mainScreen] bounds].size.height;
    CGFloat line = 5;
    if (h == 480) {
        line = 3;
    } else if (h == 568) {
        line = 3.5;
    } else if (h == 667) {
        line = 4;
    } else if (h == 736) {
        line = 4.5;
    }
    return line;
}

- (void)layoutAndAnimateTextView:(LTTextView *)textView {
    
    CGFloat maxHeight = [self maxLines] * [self fontWidth];
    CGFloat contentH = [self getTextViewContentH:textView];
    
    BOOL isShrinking = contentH < self.previousTextViewHeight;
    CGFloat changeInHeight = contentH - self.previousTextViewHeight;
    
    if (!isShrinking && (self.previousTextViewHeight == maxHeight || self.textView.text.length == 0)) {
        changeInHeight = 0;
    } else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewHeight);
    }
    
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f animations:^{
            if (isShrinking) {
                if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                    self.previousTextViewHeight = MIN(contentH, maxHeight);
                }
                [self adjustTextViewHeightBy:changeInHeight];
            }
            
            CGRect inputViewFrame = self.frame;
            self.frame = CGRectMake(0.0f, 0.0f, inputViewFrame.size.width, inputViewFrame.size.height + changeInHeight);
            
            if (!isShrinking) {
                if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                    self.previousTextViewHeight = MIN(contentH, maxHeight);
                }
                [self adjustTextViewHeightBy:changeInHeight];
            }
            
        } completion:^(BOOL finished) {
        }];
        
        self.previousTextViewHeight = MIN(contentH, maxHeight);
    }
    
    if (self.previousTextViewHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
            [textView setContentOffset:bottomOffset animated:YES];
        });
    }
    
}

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight {
    
    //动态改变自身的高度和输入框的高度
    CGRect prevFrame = self.textView.frame;
    NSUInteger numLines = MAX([self.textView numberOfLines], [[self.textView.text componentsSeparatedByString:@"\n"] count] + 1);
    self.textView.frame = CGRectMake(prevFrame.origin.x, prevFrame.origin.y, prevFrame.size.width, prevFrame.size.height + changeInHeight);
    
    self.textView.contentInset = UIEdgeInsetsMake((numLines >= 6 ? 4.0f:0.0f), 0.0f, (numLines >= 6 ? 4.0f:0.0f), 0.0f);
    
    if (numLines >= 6) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.textView.contentSize.height - self.textView.bounds.size.height);
        [self.textView setContentOffset:bottomOffset animated:YES];
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length - 2, 1)];
    }
}

#pragma mark - 创建按钮
- (UIButton *)createButton:(LTChatButtonType)buttonType action:(SEL)sel {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    switch (buttonType) {
        case LTChatButtonTypeVoice:
            button.tag = 1;
            break;
        case LTChatButtonTypeFace:
            button.tag = 2;
            break;
        case LTChatButtonTypeMore:
            button.tag = 3;
            break;
        case LTChatButtonTypeSwitchBar:
            button.tag = 4;
            break;
            
        default:
            break;
    }
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    //自动调整控件与superview的顶部位置，保证与superview的底部距离不变
    button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    return button;
    
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    self.voiceSelected = self.voiceButton.selected = NO;
    self.faceSelected = self.faceButton.selected = NO;
    self.moreSelected = self.moreButton.selected = NO;
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatInputViewTextViewDidBeginEditing:)]) {
        [self.delegate chatInputViewTextViewDidBeginEditing:self.textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(chatInputViewSendText:)]) {
            self.currentText = @"";
            [self.delegate chatInputViewSendText:textView.text];
        }
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    self.currentText = textView.text;
    if ([self.delegate respondsToSelector:@selector(chatInputViewTextViewDidChange:)]) {
        [self.delegate chatInputViewTextViewDidChange:self.textView];
    }
}

- (void)textViewDeleteBackward:(LTTextView *)textView {
    if ([self.delegate respondsToSelector:@selector(chatInputViewTextViewDeleteBackward:)]) {
        [self.delegate chatInputViewTextViewDeleteBackward:self.textView];
    }
}

#pragma mark - KVO回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (object == self && [keyPath isEqualToString:@"self.textView.contentSize"]) {
        [self layoutAndAnimateTextView:self.textView];
    }
}

#pragma mark - 私有方法
- (void)adjustTextViewContentSize {
    
    //调整textView和recordButton的 frame
    self.currentText = self.textView.text;
    self.textView.text = @"";
    self.textView.contentSize = CGSizeMake(CGRectGetWidth(self.textView.frame), TextViewH);
    self.recordButton.frame = CGRectMake(self.textView.frame.origin.x, TextViewVerticalOffset, self.textView.frame.size.width, TextViewH);
}

- (void)resumeTextViewContentSize {
    self.textView.text = self.currentText;
}

@end
