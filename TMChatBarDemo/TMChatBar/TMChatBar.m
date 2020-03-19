//
//  TMChatBar.m
//  TMChatBarDemo
//
//  Created by Luther on 2019/5/8.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "TMChatBar.h"
#import "TMChatMacro.h"
#import "NSString+Emoji.h"

@interface TMChatBar () <TMChatInputViewDelegate,TMChatEmojiViewDelegate,TMChatMoreViewDelegate>

{
    __weak UITableView *_associateTableView;    //chatKeyBoard关联的表
}

@property (nonatomic, strong) TMChatInputView *inputView;
@property (nonatomic, strong) TMChatEmojiView *emojiView;
@property (nonatomic, strong) TMChatMoreView *moreView;

/** 聊天键盘上一次的y坐标 */
@property (nonatomic, assign) CGFloat lastChatkeyboardY;

@end

@implementation TMChatBar

#pragma mark -- life

+ (instancetype)keyBoard
{
    return [self keyBoardWithNavgationBarTranslucent:YES];
}

/**
 *  如果导航栏是透明的，则键盘的初始位置为 kScreenHeight-kChatToolBarHeight
 *
 *  否则，导航栏的高度为 kScreenHeight-kChatToolBarHeight-64
 */
+ (instancetype)keyBoardWithNavgationBarTranslucent:(BOOL)translucent
{
    CGRect frame = CGRectZero;
    if (translucent) {
        frame = CGRectMake(0, kScreenHeight - kChatToolBarHeight, kScreenWidth, kChatKeyBoardHeight);
    }else {
        frame = CGRectMake(0, kScreenHeight - kChatToolBarHeight - 64, kScreenWidth, kChatKeyBoardHeight);
    }
    return [[self alloc] initWithFrame:frame];
}

+ (instancetype)keyBoardWithParentViewBounds:(CGRect)bounds
{
    CGRect frame = CGRectMake(0, bounds.size.height - kChatToolBarHeight, kScreenWidth, kChatKeyBoardHeight);
    return [[self alloc] initWithFrame:frame];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [self removeObserver:self forKeyPath:@"self.inputView.frame"];
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
    
    [self addSubview:self.inputView];
    [self addSubview:self.emojiView];
    [self addSubview:self.moreView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self addObserver:self forKeyPath:@"self.inputView.frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

#pragma mark - 跟随键盘的坐标变化
- (void)keyBoardWillChangeFrame:(NSNotification *)noti {
    
    //键盘已经弹起，表情按钮被选中
    if (self.inputView.faceSelected) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            self.moreView.hidden = YES;
            self.emojiView.hidden = NO;
            
            self.lastChatkeyboardY = self.frame.origin.y;
            self.frame = CGRectMake(0, [self getSuperViewH] - CGRectGetHeight(self.frame), kScreenWidth, CGRectGetHeight(self.frame));
            self.emojiView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - kEmojiViewHeight, kScreenWidth, kEmojiViewHeight);
            self.moreView.frame = CGRectMake(0, CGRectGetHeight(self.frame), kScreenWidth, kMorePanelHeight);
            
            [self updateAssociateTableViewFrame];
            
        } completion:nil];
    }
    //键盘已经弹起时，more按钮被选中
    else if (self.inputView.moreSelected) {
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            self.moreView.hidden = NO;
            self.emojiView.hidden = YES;
            
            self.lastChatkeyboardY = self.frame.origin.y;
            self.frame = CGRectMake(0, [self getSuperViewH] - CGRectGetHeight(self.frame), kScreenWidth, CGRectGetHeight(self.frame));
            self.moreView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - kMorePanelHeight, kScreenWidth, kMorePanelHeight);
            self.emojiView.frame = CGRectMake(0, CGRectGetHeight(self.frame), kScreenWidth, kEmojiViewHeight);
            
            [self updateAssociateTableViewFrame];
            
        } completion:nil];
    } else {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            CGRect begin = [[[noti userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
            CGRect end = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
            CGFloat duration = [[[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            
            CGFloat inputViewH = CGRectGetHeight(self.frame) - kMorePanelHeight;
            CGFloat targetY = end.origin.y - inputViewH - (kScreenHeight - [self getSuperViewH]);
            
            if (begin.size.height>0 && (begin.origin.y - end.origin.y) > 0) {
                //键盘弹起 (包括，第三方键盘回调三次问题，监听仅执行最后一次)
                self.lastChatkeyboardY = self.frame.origin.y;
                self.frame = CGRectMake(0, targetY, kScreenWidth, CGRectGetHeight(self.frame));
                self.moreView.frame = CGRectMake(0, CGRectGetHeight(self.frame), kScreenWidth, kMorePanelHeight);
                self.emojiView.frame = CGRectMake(0, CGRectGetHeight(self.frame), kScreenWidth, kEmojiViewHeight);
                
                [self updateAssociateTableViewFrame];
            } else if (end.origin.y == kScreenHeight && begin.origin.y!=end.origin.y && duration > 0) {
                
                //键盘收起
                self.lastChatkeyboardY = self.frame.origin.y;
                self.frame = CGRectMake(0, targetY, CGRectGetWidth(self.frame), self.frame.size.height);
                
                [self updateAssociateTableViewFrame];
            } else if ((begin.origin.y-end.origin.y<0) && duration == 0) {
                
                //键盘切换
                self.lastChatkeyboardY = self.frame.origin.y;
                self.frame = CGRectMake(0, targetY, CGRectGetWidth(self.frame), self.frame.size.height);
                
                [self updateAssociateTableViewFrame];
                
            }
        }];
    }
}

/** 调整关联表的高度 */
- (void)updateAssociateTableViewFrame {
    
    //表原来的偏移量
    CGFloat original = _associateTableView.contentOffset.y;
    
    //键盘的y坐标的偏移量
    CGFloat keyboardOffset = self.frame.origin.y - self.lastChatkeyboardY;
    
    //更新表的frame
    _associateTableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.origin.y);
    
    //表的超出frame内容高度
    CGFloat tableViewContentDiffer = _associateTableView.contentSize.height - _associateTableView.frame.size.height;
    
    //是否键盘的偏移量，超过了表的整个tableViewContentDiffer
    CGFloat offset = 0;
    if (fabs(tableViewContentDiffer) > fabs(keyboardOffset)) {
        offset = original - keyboardOffset;
    } else {
        offset = tableViewContentDiffer;
    }
    
    if (_associateTableView.contentSize.height+_associateTableView.contentInset.top+_associateTableView.contentInset.bottom>_associateTableView.frame.size.height) {
        _associateTableView.contentOffset = CGPointMake(0, offset);
    }
    
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self && [keyPath isEqualToString:@"self.inputView.frame"]) {
        
        CGRect newRect = [[change objectForKey:NSKeyValueChangeNewKey] CGRectValue];
        CGRect oldRect = [[change objectForKey:NSKeyValueChangeOldKey] CGRectValue];
        CGFloat changeHeight = newRect.size.height - oldRect.size.height;
        
        self.lastChatkeyboardY = self.frame.origin.y;
        self.frame = CGRectMake(0, self.frame.origin.y - changeHeight, self.frame.size.width, self.frame.size.height + changeHeight);
        self.emojiView.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kEmojiViewHeight, CGRectGetWidth(self.frame), kEmojiViewHeight);
        self.moreView.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kMorePanelHeight, CGRectGetWidth(self.frame), kMorePanelHeight);
        
        [self updateAssociateTableViewFrame];
    }
}

#pragma mark - TMChatInputViewDelegate
/** 语音按钮点击 */
- (void)chatInputView:(TMChatInputView *)inputView voiceButtonPressed:(BOOL)select keyboardState:(BOOL)change {
    if (select && change == NO) {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.lastChatkeyboardY = self.frame.origin.y;
            CGFloat y = self.frame.origin.y;
            y = [self getSuperViewH] - self.inputView.frame.size.height;
            self.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
            
            [self updateAssociateTableViewFrame];
            
        }];
    }
}
/** 表情按钮点击 */
- (void)chatInputView:(TMChatInputView *)inputView faceButtonPressed:(BOOL)select keyboardState:(BOOL)change {
    if (select && change == NO) {
        self.moreView.hidden = YES;
        self.emojiView.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            
            self.lastChatkeyboardY = self.frame.origin.y;
            self.frame = CGRectMake(0, [self getSuperViewH]-CGRectGetHeight(self.frame), kScreenWidth, CGRectGetHeight(self.frame));
            self.emojiView.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kEmojiViewHeight, CGRectGetWidth(self.frame), kEmojiViewHeight);
            self.moreView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kMorePanelHeight);
            
            [self updateAssociateTableViewFrame];
            
        }];
    }
}
/** more按钮点击 */
- (void)chatInputView:(TMChatInputView *)inputView moreButtonPressed:(BOOL)select keyboardState:(BOOL)change {
    if (select && change == NO) {
        self.moreView.hidden = NO;
        self.emojiView.hidden = YES;
        [UIView animateWithDuration:0.25 animations:^{
            
            self.lastChatkeyboardY = self.frame.origin.y;
            self.frame = CGRectMake(0, [self getSuperViewH]-CGRectGetHeight(self.frame), kScreenWidth, CGRectGetHeight(self.frame));
            self.moreView.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kMorePanelHeight, CGRectGetWidth(self.frame), kMorePanelHeight);
            self.emojiView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kEmojiViewHeight);
            
            [self updateAssociateTableViewFrame];
            
        }];
    }
}
- (void)chatInputViewSwitchBarButtonPressed:(TMChatInputView *)inputView keyBoardState:(BOOL)change {
    if (change == NO) {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.lastChatkeyboardY = self.frame.origin.y;
            
            CGFloat y = self.frame.origin.y;
            y = [self getSuperViewH] - kChatToolBarHeight;
            self.frame = CGRectMake(0,[self getSuperViewH], self.frame.size.width, self.frame.size.height);
//            self.OAtoolbar.frame = CGRectMake(0, 0, self.frame.size.width, kChatToolBarHeight);
            self.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
            
            [self updateAssociateTableViewFrame];
            
        }];
    } else {
        self.lastChatkeyboardY = self.frame.origin.y;
        
        CGFloat y = [self getSuperViewH] - kChatToolBarHeight;
        self.frame = CGRectMake(0, [self getSuperViewH], self.frame.size.width, self.frame.size.height);
//        self.OAtoolbar.frame = CGRectMake(0, 0, self.frame.size.width, kChatToolBarHeight);
        self.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
        
        [self updateAssociateTableViewFrame];
    }
}

- (void)chatInputViewDidStartRecording:(TMChatInputView *)inputView {
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardDidStartRecording:)]) {
        [self.delegate chatKeyBoardDidStartRecording:self];
    }
}
- (void)chatInputViewDidCancelRecording:(TMChatInputView *)inputView {
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardDidCancelRecording:)]) {
        [self.delegate chatKeyBoardDidCancelRecording:self];
    }
}
- (void)chatInputViewDidFinishRecoding:(TMChatInputView *)inputView {
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardDidFinishRecoding:)]) {
        [self.delegate chatKeyBoardDidFinishRecoding:self];
    }
}
- (void)chatInputViewWillCancelRecoding:(TMChatInputView *)inputView {
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardWillCancelRecoding:)]) {
        [self.delegate chatKeyBoardWillCancelRecoding:self];
    }
}
- (void)chatInputViewContineRecording:(TMChatInputView *)inputView {
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardContineRecording:)]) {
        [self.delegate chatKeyBoardContineRecording:self];
    }
}

- (void)chatInputViewTextViewDidBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardTextViewDidBeginEditing:)]) {
        [self.delegate chatKeyBoardTextViewDidBeginEditing:textView];
    }
}
- (void)chatInputViewSendText:(NSString *)text {
    [self.inputView clearTextViewContent];
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardSendText:)]) {
        [self.delegate chatKeyBoardSendText:text];
    }
}
- (void)chatInputViewTextViewDidChange:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardTextViewDidChange:)]) {
        [self.delegate chatKeyBoardTextViewDidChange:textView];
    }
}
- (void)chatInputViewTextViewDeleteBackward:(TMTextView *)textView {
    
    NSRange range = textView.selectedRange;
    NSString *handleText;
    NSString *appendText;
    if (range.location == textView.text.length) {
        handleText = textView.text;
        appendText = @"";
    }else {
        handleText = [textView.text substringToIndex:range.location];
        appendText = [textView.text substringFromIndex:range.location];
    }
    
    if (handleText.length > 0) {
        
        [self deleteBackward:handleText appendText:appendText];
    }
    
}

#pragma mark - TMChatEmojiViewDelegate

- (void)chatEmojiViewSendAction:(TMChatEmojiView *)emojiView {
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardSendText:)]) {
        [self.delegate chatKeyBoardSendText:self.inputView.textView.text];
    }
    [self.inputView clearTextViewContent];
}
- (void)chatEmojiViewAddAction:(TMChatEmojiView *)emojiView {
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardAddFaceSubject:)]) {
        [self.delegate chatKeyBoardAddFaceSubject:self];
    }
}
- (void)chatEmojiViewSettingAction:(TMChatEmojiView *)emojiView {
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardSetFaceSubject:)]) {
        [self.delegate chatKeyBoardSetFaceSubject:self];
    }
}

- (void)chatEmojiView:(TMChatEmojiView *)emojiView emojiStyle:(TMChatEmojiThemeStyle)emojiStyle emojiName:(NSString *)emojiName isDeleteKey:(BOOL)isDelete {
    NSString *text = self.inputView.textView.text;
    
    if (isDelete == YES)
    {
        if (text.length <= 0) {
            [self.inputView setTextViewContent:@""];
        }else {
            [self deleteBackward:text appendText:@""];
        }
    }else {
        [self.inputView setTextViewContent:[text stringByAppendingString:emojiName]];
    }
}

#pragma mark - TMChatMoreViewDelegate
- (void)chatMoreView:(TMChatMoreView *)moreView didSelectedIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(chatKeyBoard:didSelectMorePanelItemIndex:)]) {
        [self.delegate chatKeyBoard:self didSelectMorePanelItemIndex:index];
    }
}

#pragma mark - TMChatBarDataSource
- (void)setDataSource:(id<TMChatBarDataSource>)dataSource
{
    _dataSource = dataSource;
    if (dataSource == nil) {
        return;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chatKeyBoardInputItems)]) {
        NSArray<TMChatInputItem *> *barItems = [self.dataSource chatKeyBoardInputItems];
        [self.inputView loadBarItems:barItems];
    }
    
    if ([self.dataSource respondsToSelector:@selector(chatKeyBoardMoreItems)]) {
        NSArray<TMChatMoreItem *> *moreItems = [self.dataSource chatKeyBoardMoreItems];
        [self.moreView loadMoreItems:moreItems];
    }
    
    if ([self.dataSource respondsToSelector:@selector(chatKeyBoardEmojiSubjectItems)]) {
        NSArray<TMChatEmojiThemeModel *> *themeItems = [self.dataSource chatKeyBoardEmojiSubjectItems];
        [self.emojiView loadEmojiThemeItems:themeItems];
    }
}

#pragma mark - Setter
- (void)setAssociateTableView:(UITableView *)associateTableView {
    if (_associateTableView != associateTableView) {
        _associateTableView = associateTableView;
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    [self.inputView setTextViewPlaceHolder:placeHolder];
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    _placeHolderColor = placeHolderColor;
    [self.inputView setTextViewPlaceHolderColor:placeHolderColor];
}

- (void)setAllowVoice:(BOOL)allowVoice {
    _allowVoice = allowVoice;
    self.inputView.allowVoice = allowVoice;
}

- (void)setAllowFace:(BOOL)allowFace {
    _allowFace = allowFace;
    self.inputView.allowFace = allowFace;
}

- (void)setAllowMore:(BOOL)allowMore {
    _allowMore = allowMore;
    self.inputView.allowMore = allowMore;
}

- (void)setAllowSwitchBar:(BOOL)allowSwitchBar {
    _allowSwitchBar = allowSwitchBar;
    self.inputView.allowSwitchBar = allowSwitchBar;
}

- (void)keyboardUp
{
    [self.inputView.textView becomeFirstResponder];
}

- (void)keyboardDown
{
    if ([self.inputView.textView isFirstResponder])
    {
        [self.inputView.textView resignFirstResponder];
    }
    else
    {
        if(([self getSuperViewH] - CGRectGetMinY(self.frame)) > self.inputView.frame.size.height)
        {
            [UIView animateWithDuration:0.25 animations:^{
                
                self.lastChatkeyboardY = self.frame.origin.y;
                CGFloat y = self.frame.origin.y;
                y = [self getSuperViewH] - self.inputView.frame.size.height;
                self.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
                
                [self updateAssociateTableViewFrame];
                
            }];
            
        }
    }
}

#pragma mark - 回删表情或文字

- (void)deleteBackward:(NSString *)text appendText:(NSString *)appendText
{
    if (IsTextContainFace(text)) { // 如果最后一个是表情
        
        NSRange startRang = [text rangeOfString:@"[" options:NSBackwardsSearch];
        NSString *current = [text substringToIndex:startRang.location];
        [self.inputView setTextViewContent:[current stringByAppendingString:appendText]];
        self.inputView.textView.selectedRange = NSMakeRange(current.length, 0);
        
    }else { // 如果最后一个系统键盘输入的文字
        
        if (text.length >= 2) {
            
            NSString *tempString = [text substringWithRange:NSMakeRange(text.length - 2, 2)];
            
            if ([tempString isEmoji]) { // 如果是Emoji表情
                NSString *current = [text substringToIndex:text.length - 2];
                
                [self.inputView setTextViewContent:[current stringByAppendingString:appendText]];
                self.inputView.textView.selectedRange = NSMakeRange(current.length, 0);
                
            }else { // 如果是纯文字
                NSString *current = [text substringToIndex:text.length - 1];
                [self.inputView setTextViewContent:[current stringByAppendingString:appendText]];
                self.inputView.textView.selectedRange = NSMakeRange(current.length, 0);
            }
            
        }else { // 如果是纯文字
            
            NSString *current = [text substringToIndex:text.length - 1];
            [self.inputView setTextViewContent:[current stringByAppendingString:appendText]];
            self.inputView.textView.selectedRange = NSMakeRange(current.length, 0);
        }
    }
}


- (CGFloat)getSuperViewH
{
    if (self.superview == nil) {
        NSException *excp = [NSException exceptionWithName:@"ChatKeyBoardException" reason:@"未添加到父视图上面" userInfo:nil];
        [excp raise];
    }
    
    return self.superview.frame.size.height;
}

#pragma mark - 懒加载
- (TMChatInputView *)inputView {
    if (!_inputView) {
        _inputView = [[TMChatInputView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kChatToolBarHeight)];
        _inputView.delegate = self;
    }
    return _inputView;
}

- (TMChatEmojiView *)emojiView {
    if (!_emojiView) {
        _emojiView = [[TMChatEmojiView alloc] initWithFrame:CGRectMake(0, kChatKeyBoardHeight - kEmojiViewHeight, kScreenWidth, kEmojiViewHeight)];
        _emojiView.delegate = self;
    }
    return _emojiView;
}

- (TMChatMoreView *)moreView {
    if (!_moreView) {
        _moreView = [[TMChatMoreView alloc] initWithFrame:CGRectMake(0, kChatKeyBoardHeight-kMorePanelHeight, kScreenWidth, kMorePanelHeight)];
        _moreView.delegate = self;
    }
    return _moreView;
}
@end
