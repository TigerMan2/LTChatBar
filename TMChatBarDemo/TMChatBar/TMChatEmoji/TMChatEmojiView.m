//
//  TMChatEmojiView.m
//  TMChatBarDemo
//
//  Created by Luther on 2019/5/8.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "TMChatEmojiView.h"
#import "TMChatEmojiThemeView.h"
#import "TMChatEmojiBottomView.h"
#import "TMChatMacro.h"

extern NSString * const EmojiPageViewEmojiSelectedNotification;
extern NSString * const EmojiPageViewEmojiName;
extern NSString * const EmojiPageViewDeleteKey;
extern NSString * const EmojiPageViewEmojiThemeStyle;

@interface TMChatEmojiView () <UIScrollViewDelegate,TMChatEmojiBottomViewDelegate>

@property (nonatomic, strong) NSArray *emojiSources;

@end

@implementation TMChatEmojiView
{
    UIScrollView *_scrollView;
    TMChatEmojiBottomView *_bottomView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EmojiPageViewEmojiSelectedNotification object:nil];
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
    
    self.backgroundColor = kChatKeyBoardColor;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kEmojiViewHeight -  kChatEmojiBottomToolBarHeight)];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _bottomView = [[TMChatEmojiBottomView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame), self.frame.size.width, kChatEmojiBottomToolBarHeight)];
    _bottomView.delegate = self;
    [self addSubview:_bottomView];
    
    __weak typeof(self) weakSelf = self;
    _bottomView.addAction = ^{
        if ([weakSelf.delegate respondsToSelector:@selector(chatEmojiViewAddAction:)]) {
            [weakSelf.delegate chatEmojiViewAddAction:weakSelf];
        }
    };
    
    _bottomView.setAction = ^{
        if ([weakSelf.delegate respondsToSelector:@selector(chatEmojiViewSettingAction:)]) {
            [weakSelf.delegate chatEmojiViewSettingAction:weakSelf];
        }
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emojiPageViewEmojiSelected:) name:EmojiPageViewEmojiSelectedNotification object:nil];
    
}

#pragma mark - 通知
- (void)emojiPageViewEmojiSelected:(NSNotification *)noti {
    
    NSDictionary *info = noti.userInfo;
    NSString *emojiName = [info objectForKey:EmojiPageViewEmojiName];
    BOOL isDelete = [[info objectForKey:EmojiPageViewDeleteKey] boolValue];
    TMChatEmojiThemeStyle themeStyle = [[info objectForKey:EmojiPageViewEmojiThemeStyle] integerValue];
    
    if ([self.delegate respondsToSelector:@selector(chatEmojiView:emojiStyle:emojiName:isDeleteKey:)]) {
        [self.delegate chatEmojiView:self emojiStyle:themeStyle emojiName:emojiName isDeleteKey:isDelete];
    }
}

#pragma mark - 数据源
- (void)loadEmojiThemeItems:(NSArray <TMChatEmojiThemeModel *> *)themeItems {
    
    self.emojiSources = themeItems;
    
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * themeItems.count, 0);
    
    for (int i = 0; i < themeItems.count; i ++) {
        TMChatEmojiThemeView *view = [[TMChatEmojiThemeView alloc] initWithFrame:CGRectMake(i * CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
        [view loadEmojiTheme:themeItems[i]];
        [_scrollView addSubview:view];
    }
    
    [_bottomView loadfaceThemePickerSource:themeItems];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _scrollView) {
        
        CGFloat pageWidth = scrollView.frame.size.width;
        
        NSInteger currentIndex = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
        [_bottomView changeFaceSubjectIndex:currentIndex];
    }
}

#pragma mark - TMChatEmojiBottomViewDelegate
- (void)chatEmojiBottomViewSendAction:(TMChatEmojiBottomView *)bottomView {
    if ([self.delegate respondsToSelector:@selector(chatEmojiViewSendAction:)]) {
        [self.delegate chatEmojiViewSendAction:self];
    }
}

- (void)chatEmojiBottomView:(TMChatEmojiBottomView *)bottomView didPickerEmojiSubjectIndex:(NSInteger)emojiSubjectIndex {
    [_scrollView setContentOffset:CGPointMake(emojiSubjectIndex * self.frame.size.width, 0) animated:YES];
}



@end
