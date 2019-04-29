//
//  LTChatEmojiMenuView.m
//  LTChatBarDemo
//
//  Created by Wade Wu on 2019/4/27.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "LTChatEmojiMenuView.h"
#import "UIColor+LT.h"
#import "LTEmojiGroup.h"

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
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(MENU_EMOJI_ITEM_HEIGHT - 0.25, 5, 0.5, MENU_EMOJI_ITEM_HEIGHT - 10)];
    leftLine.backgroundColor = [UIColor colorWithHexString:@"0xE6E6E6"];
    [self addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(kWIDTH - MENU_EMOJI_ITEM_HEIGHT - 20 - 0.25, 0, 0.5, MENU_EMOJI_ITEM_HEIGHT)];
    rightLine.backgroundColor = [UIColor colorWithHexString:@"0xE6E6E6"];
    [self addSubview:rightLine];
    
    LTEmojiGroupManager *emojiManager = [LTEmojiGroupManager shareManager];
    
    NSArray *emojiGroup = [emojiManager emojiGroup];
    //设置contentsize
    self.scrollView.contentSize = CGSizeMake(emojiGroup.count * MENU_EMOJI_ITEM_HEIGHT, 0);
    
    LTEmojiGroup *lastEmojiGroup = emojiManager.currentGroup;
    
    __block NSInteger index = 0;
    if (emojiGroup.count == 1) {
        index = 0;
    }
    else {
        for (LTEmojiGroup *group in emojiGroup) {
            if ([group.groupID isEqualToString:lastEmojiGroup.groupID]) {
                break;
            }
            index ++;
        }
    }
    
    __block CGFloat originX = 0;
    kWeakSelf;
    //添加表情组
    [emojiGroup enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LTEmojiGroup *emojiModel = obj;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(originX * idx, 0, MENU_EMOJI_ITEM_HEIGHT, MENU_EMOJI_ITEM_HEIGHT)];
        [button setImage:[UIImage imageNamed:emojiModel.groupName] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
        
        button.imageView.backgroundColor = [UIColor clearColor];
        button.backgroundColor = idx == index ? [UIColor colorWithHexString:@"0xeeeeee"] : [UIColor whiteColor];
        button.tag = 10 + idx;
        [button addTarget:weakSelf action:@selector(didSelectEmojiGroup:) forControlEvents:UIControlEventTouchUpInside];
        [weakSelf.scrollView addSubview:button];
        originX = originX + MENU_EMOJI_ITEM_HEIGHT;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(originX - 0.25, 5, 0.5, MENU_EMOJI_ITEM_HEIGHT - 10)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
        [weakSelf.scrollView addSubview:line];
        if (idx == index) {
            weakSelf.lastSelectEmojiGroup = button;
            button.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteEmojiToEmpty) name:@"deleteEmojiToEmpty" object:nil];
    
}

- (void)deleteEmojiToEmpty {
    [self.sendButton setBackgroundColor:[UIColor whiteColor]];
    [self.sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

/** 选择的表情组 */
- (void)didSelectEmojiGroup:(UIButton *)sender {
    if (![self.lastSelectEmojiGroup isEqual:sender]) {
        NSArray *emojiGroups     = [[LTEmojiGroupManager shareManager] emojiGroup];
        LTEmojiGroup *emojiGroup  = emojiGroups[sender.tag - 10];
        sender.backgroundColor   = [UIColor colorWithHexString:@"0xeeeeee"];
        self.lastSelectEmojiGroup.backgroundColor = [UIColor whiteColor];
        self.lastSelectEmojiGroup = sender;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(emojiMenuView:didSelectEmojiGroup:)])
        {
            [self.delegate emojiMenuView:self didSelectEmojiGroup:emojiGroup];
        }
    }
}

/** 发送表情 */
- (void)sendEmojiAction:(UIButton *)sender {
    sender.backgroundColor = [UIColor whiteColor];
    [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiMenuView:sendEmoji:)]) {
        [self.delegate emojiMenuView:self sendEmoji:sender];
    }
}

/** 点击添加表情 */
- (void)clickAddButtonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiMenuView:clickAddAction:)]) {
        [self.delegate emojiMenuView:self clickAddAction:sender];
    }
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
        [_addButton addTarget:self action:@selector(clickAddButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(kWIDTH - MENU_EMOJI_ITEM_HEIGHT - 20, 0, MENU_EMOJI_ITEM_HEIGHT + 20, MENU_EMOJI_ITEM_HEIGHT);
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sendButton addTarget:self action:@selector(sendEmojiAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

@end
