//
//  TMChatEmojiView.h
//  TMChatBarDemo
//
//  Created by Luther on 2019/5/8.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMChatEmojiThemeModel.h"

@class TMChatEmojiView;
@protocol TMChatEmojiViewDelegate <NSObject>

@optional
- (void)chatEmojiViewSendAction:(TMChatEmojiView *)emojiView;
- (void)chatEmojiViewAddAction:(TMChatEmojiView *)emojiView;
- (void)chatEmojiViewSettingAction:(TMChatEmojiView *)emojiView;

- (void)chatEmojiView:(TMChatEmojiView *)emojiView emojiStyle:(TMChatEmojiThemeStyle)emojiStyle emojiName:(NSString *)emojiName isDeleteKey:(BOOL)isDelete;

@end

@interface TMChatEmojiView : UIView

@property (nonatomic, weak) id <TMChatEmojiViewDelegate> delegate;

- (void)loadEmojiThemeItems:(NSArray <TMChatEmojiThemeModel *> *)themeItems;

@end

