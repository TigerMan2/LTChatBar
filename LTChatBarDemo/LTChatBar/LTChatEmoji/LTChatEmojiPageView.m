//
//  LTChatEmojiPageView.m
//  LTChatBarDemo
//
//  Created by Luther on 2019/5/9.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "LTChatEmojiPageView.h"
#import "LTChatMacro.h"
#import "LTChatEmojiButton.h"

#define DeleteKey       @"DeleteKey"

#define EmojiContainerHeight       kEmojiViewHeight - kChatEmojiBottomToolBarHeight - kUIPageControllerHeight

NSString * const EmojiPageViewEmojiSelectedNotification = @"EmojiPageViewEmojiSelectedNotification";
NSString * const EmojiPageViewEmojiName = @"EmojiPageViewEmojiName";
NSString * const EmojiPageViewDeleteKey = @"EmojiPageViewDeleteKey";
NSString * const EmojiPageViewEmojiThemeStyle = @"EmojiPageViewEmojiThemeStyle";

@interface LTChatEmojiPageView ()

/** 按钮数组 */
@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation LTChatEmojiPageView

- (void)prepareForReuse {
    [super prepareForReuse];
    NSLog(@"prepareForReuse----------------------");
    NSLog(@"%zd",self.themeStyle);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self didInitSystemEmoji];
    }
    return self;
}

- (void)setThemeStyle:(LTChatEmojiThemeStyle)themeStyle {
    
    if (_themeStyle != themeStyle) {
        _themeStyle = themeStyle;
        switch (themeStyle) {
            case LTChatEmojiThemeStyleSystem:
                [self didInitSystemEmoji];
                break;
            case LTChatEmojiThemeStyleCustom:
                [self didInitCustomEmoji];
                break;
            case LTChatEmojiThemeStyleGif:
                [self didInitGifEmoji];
                break;
                
            default:
                break;
        }
    }
}

- (void)didInitSystemEmoji {
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger cols = 8;
    if (isIPhone4_5) {
        cols = 7;
    } else if (isIPhone6_6s) {
        cols = 8;
    } else if (isIPhone6p_6sp) {
        cols = 9;
    }
    
    NSInteger lines = 3;
    
    CGFloat item = 40.0f;
    NSInteger edgeDistance = 10.0f;
    
    CGFloat vMargin = (EmojiContainerHeight - lines * item) / (lines + 1);
    CGFloat hMargin = (CGRectGetWidth(self.bounds) - cols * item - 2 * edgeDistance) / cols;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < lines; i ++) {
        for (int j = 0; j < cols; j ++) {
            LTChatEmojiButton *button = [LTChatEmojiButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(j*item+edgeDistance+j*hMargin, i*item+(i+1)*vMargin, item, item);
            [button addTarget:self action:@selector(emojiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            [array addObject:button];
        }
    }
    
    self.buttons = array;
    
}

- (void)didInitCustomEmoji {
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger cols = 7;
    if (isIPhone4_5) {cols = 7;}else if (isIPhone6_6s) {cols = 8;}else if (isIPhone6p_6sp){cols = 9;}
    
    NSInteger lines = 3;
    CGFloat item = 40.f;
    NSInteger edgeDistance = 10;
    
    CGFloat vMargin = (EmojiContainerHeight - lines * item) / (lines+1);
    CGFloat hMargin = (CGRectGetWidth(self.bounds) - cols * item - 2*edgeDistance) / cols;
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < lines; ++i) {
        for (int j = 0; j < cols; ++j) {
            LTChatEmojiButton *button = [LTChatEmojiButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(j*item+edgeDistance+j*hMargin,i*item+(i+1)*vMargin,item,item);
            [button addTarget:self action:@selector(emojiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            [array addObject:button];
        }
    }
    self.buttons = array;
}

- (void)didInitGifEmoji {
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger cols = 4;
    NSInteger lines = 2;
    CGFloat item = 60.f;
    
    CGFloat vMargin = (EmojiContainerHeight - lines * item) / (lines+1);
    CGFloat hMargin = (CGRectGetWidth(self.bounds) - cols * item) / (cols+1);
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < lines; ++i) {
        for (int j = 0; j < cols; ++j) {
            LTChatEmojiButton *button = [LTChatEmojiButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(j*item+(j+1)*hMargin,i*item+(i+1)*vMargin,item,item);
            [button addTarget:self action:@selector(emojiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            [array addObject:button];
        }
    }
    self.buttons = array;
}

- (void)loadPerPageEmojiData:(NSArray *)emojiData {
    switch (_themeStyle) {
        case LTChatEmojiThemeStyleSystem:
            [self loadSystemEmoji:emojiData];
            break;
        case LTChatEmojiThemeStyleCustom:
            [self loadCustomEmoji:emojiData];
            break;
        case LTChatEmojiThemeStyleGif:
            [self loadGifEmoji:emojiData];
            break;
            
        default:
            break;
    }
}

- (void)loadSystemEmoji:(NSArray *)emojiData {
    
    for (int i = 0; i < emojiData.count; i ++) {
        LTChatEmojiModel *model = emojiData[i];
        LTChatEmojiButton *button = self.buttons[i];
        button.hidden = NO;
        [button setTitle:model.emojiIcon forState:UIControlStateNormal];
        [button setImage:nil forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:25.0f];
        button.faceTitle = model.emojiTitle;
    }
    
    LTChatEmojiButton *button = self.buttons[emojiData.count];
    button.hidden = NO;
    [button setTitle:nil forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"Delete_ios7"] forState:UIControlStateNormal];
    button.faceTitle = DeleteKey;
    
    for (NSUInteger i = emojiData.count + 1; i < self.buttons.count; ++i) {
        LTChatEmojiButton *button = self.buttons[i];
        button.hidden = YES;
        button.faceTitle = nil;
        [button setTitle:nil forState:UIControlStateNormal];
        [button setImage:nil forState:UIControlStateNormal];
    }
    
}

- (void)loadCustomEmoji:(NSArray *)emojiData {
    
    for (int i = 0; i < emojiData.count; i ++) {
        LTChatEmojiModel *model = emojiData[i];
        LTChatEmojiButton *button = self.buttons[i];
        button.hidden = NO;
        [button setImage:[UIImage imageNamed:model.emojiIcon] forState:UIControlStateNormal];
        button.faceTitle = model.emojiTitle;
    }
    
    LTChatEmojiButton *button = self.buttons[emojiData.count];
    button.hidden = NO;
    [button setTitle:nil forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"Delete_ios7"] forState:UIControlStateNormal];
    button.faceTitle = DeleteKey;
    
    for (NSUInteger i = emojiData.count + 1; i < self.buttons.count; ++i) {
        LTChatEmojiButton *button = self.buttons[i];
        button.hidden = YES;
        button.faceTitle = nil;
        [button setImage:nil forState:UIControlStateNormal];
    }
}

- (void)loadGifEmoji:(NSArray *)emojiData {
    
    for (int i = 0; i < emojiData.count; i ++) {
        LTChatEmojiModel *model = emojiData[i];
        LTChatEmojiButton *button = self.buttons[i];
        button.hidden = NO;
        [button setImage:[UIImage imageNamed:model.emojiIcon] forState:UIControlStateNormal];
        button.faceTitle = model.emojiTitle;
    }
    for (NSUInteger i = emojiData.count + 1; i < self.buttons.count; ++i) {
        LTChatEmojiButton *button = self.buttons[i];
        button.hidden = YES;
        button.faceTitle = nil;
        [button setImage:nil forState:UIControlStateNormal];
    }
}

- (void)emojiButtonClick:(LTChatEmojiButton *)sender {
    
    BOOL deleteKey = NO;
    if ([sender.faceTitle isEqualToString:DeleteKey]) {
        deleteKey = YES;
    }
    
    NSDictionary *emojiInfo = @{
                                EmojiPageViewEmojiName : sender.faceTitle ? sender.faceTitle : @"",
                                EmojiPageViewDeleteKey : @(deleteKey),
                                EmojiPageViewEmojiThemeStyle : @(self.themeStyle)
                                };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EmojiPageViewEmojiSelectedNotification object:self userInfo:emojiInfo];
    
}

@end
