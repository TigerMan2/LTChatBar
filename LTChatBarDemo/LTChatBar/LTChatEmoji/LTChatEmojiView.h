//
//  LTChatEmojiView.h
//  LTChatBarDemo
//
//  Created by Luther on 2019/5/8.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTChatEmojiThemeModel.h"

@class LTChatEmojiView;
@protocol LTChatEmojiViewDelegate <NSObject>

@optional
- (void)chatEmojiViewSendAction:(LTChatEmojiView *)emojiView;
- (void)chatEmojiViewAddAction:(LTChatEmojiView *)emojiView;
- (void)chatEmojiViewSettingAction:(LTChatEmojiView *)emojiView;

- (void)chatEmojiView:(LTChatEmojiView *)emojiView emojiStyle:(LTChatEmojiThemeStyle)emojiStyle emojiName:(NSString *)emojiName isDeleteKey:(BOOL)isDelete;

@end

@interface LTChatEmojiView : UIView

@property (nonatomic, weak) id <LTChatEmojiViewDelegate> delegate;

- (void)loadEmojiThemeItems:(NSArray <LTChatEmojiThemeModel *> *)themeItems;

@end

