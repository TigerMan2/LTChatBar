//
//  TMChatEmojiBottomView.m
//  TMChatBarDemo
//
//  Created by Luther on 2019/5/9.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "TMChatEmojiBottomView.h"
#import "TMChatMacro.h"
#import "TMChatEmojiThemeModel.h"

@implementation TMChatEmojiBottomView

{
    UIButton            *_addButton;
    UIScrollView        *_facePickerView;
    UIButton            *_sendButton;
    UIButton            *_settingButton;
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
    
    _addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    _addButton.frame = CGRectMake(0, 0, kChatEmojiBottomToolBarHeight, kChatEmojiBottomToolBarHeight);
    [_addButton addTarget:self action:@selector(clickAddAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addButton];
    
    _facePickerView = [[UIScrollView alloc] initWithFrame:CGRectMake(kChatEmojiBottomToolBarHeight, 0, kScreenWidth - 2 * kChatEmojiBottomToolBarHeight, kChatEmojiBottomToolBarHeight)];
    [self addSubview:_facePickerView];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _sendButton.frame = CGRectMake(kScreenWidth - kChatEmojiBottomToolBarHeight, 0, kChatEmojiBottomToolBarHeight, kChatEmojiBottomToolBarHeight);
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(clickSendAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendButton];
    
    _settingButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _settingButton.frame = _sendButton.frame;
    [_settingButton setTitle:@"设置" forState:UIControlStateNormal];
    [_settingButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [_settingButton addTarget:self action:@selector(clickSettingAction) forControlEvents:UIControlEventTouchUpInside];
    [_settingButton setHidden:YES];
    [self addSubview:_settingButton];
    
}

- (void)loadfaceThemePickerSource:(NSArray *)sources {
    
    for (int i = 0; i < sources.count; i ++) {
        TMChatEmojiThemeModel *themeM = sources[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        if (i == 0) {
            button.selected = YES;
        }
        button.tag = i + 100;
        [button setTitle:themeM.themeDecribe forState:UIControlStateNormal];
        [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(subjectPicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(kChatEmojiBottomToolBarHeight * i, 0, kChatEmojiBottomToolBarHeight, kChatEmojiBottomToolBarHeight);
        [_facePickerView addSubview:button];
        
        if (i == sources.count - 1) {
            NSInteger pages = CGRectGetMaxX(button.frame) / CGRectGetWidth(_facePickerView.frame) + 1;
            _facePickerView.contentSize = CGSizeMake(pages * CGRectGetWidth(_facePickerView.frame), 0);
        }
        
    }
}

- (void)subjectPicBtnClick:(UIButton *)sender {
    
    for (UIView *sub in _facePickerView.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)sub;
            if (btn == sender) {
                sender.selected = YES;
            }else {
                btn.selected = NO;
            }
        }
    }
    
    if (sender.tag-100 > 0) {
        _settingButton.hidden = NO;
        _sendButton.hidden = YES;
    }else {
        _settingButton.hidden = YES;
        _sendButton.hidden = NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(chatEmojiBottomView:didPickerEmojiSubjectIndex:)]) {
        [self.delegate chatEmojiBottomView:self didPickerEmojiSubjectIndex:(sender.tag - 100)];
    }
    
}

- (void)changeFaceSubjectIndex:(NSInteger)subjectIndex {
    
    [_facePickerView setContentOffset:CGPointMake(subjectIndex * kChatEmojiBottomToolBarHeight, 0) animated:YES];
    
    for (UIView *sub in _facePickerView.subviews) {
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)sub;
            if (button.tag - 100 == subjectIndex) {
                button.selected = YES;
            } else {
                button.selected = NO;
            }
        }
    }
    
    if (subjectIndex > 0) {
        _settingButton.hidden = NO;
        _sendButton.hidden = YES;
    } else {
        _settingButton.hidden = YES;
        _sendButton.hidden = NO;
    }
    
}

#pragma mark - 点击添加按钮
- (void)clickAddAction {
    if (self.addAction) {
        self.addAction();
    }
}

#pragma mark - 点击发送按钮
- (void)clickSendAction {
    if ([self.delegate respondsToSelector:@selector(chatEmojiBottomViewSendAction:)]) {
        [self.delegate chatEmojiBottomViewSendAction:self];
    }
}

#pragma mark - 点击设置按钮
- (void)clickSettingAction {
    if (self.setAction) {
        self.setAction();
    }
}

@end
