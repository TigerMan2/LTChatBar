//
//  LTChatEmojiMenuView.m
//  LTChatBarDemo
//
//  Created by Wade Wu on 2019/4/27.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "LTChatEmojiMenuView.h"

@implementation LTChatEmojiMenuView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self didInitialize];
    }
    return self;
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
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.addButton];
    [self addSubview:self.scrollView];
    [self addSubview:self.sendButton];
    
}

#pragma mark - getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(44, 0, kWIDTH - 2 * MENU_EMOJI_ITEM_HEIGHT - 20, MENU_EMOJI_ITEM_HEIGHT)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
    }
    return _scrollView;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(0, 0, MENU_EMOJI_ITEM_HEIGHT, MENU_EMOJI_ITEM_HEIGHT);
        [_addButton setImage:[UIImage imageNamed:@"icon_inputBox_menu_add"] forState:UIControlStateNormal];
        [_addButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    return _addButton;
}

@end
