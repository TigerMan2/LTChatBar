//
//  TMChatEmojiBottomView.h
//  TMChatBarDemo
//
//  Created by Luther on 2019/5/9.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddActionBlock)(void);
typedef void(^SetActionBlock)(void);

@class TMChatEmojiBottomView;

@protocol TMChatEmojiBottomViewDelegate <NSObject>

- (void)chatEmojiBottomView:(TMChatEmojiBottomView *)bottomView didPickerEmojiSubjectIndex:(NSInteger)emojiSubjectIndex;
- (void)chatEmojiBottomViewSendAction:(TMChatEmojiBottomView *)bottomView;

@end

@interface TMChatEmojiBottomView : UIView

@property (nonatomic, weak) id <TMChatEmojiBottomViewDelegate> delegate;

@property (nonatomic, copy) AddActionBlock addAction;
@property (nonatomic, copy) SetActionBlock setAction;

- (void)loadfaceThemePickerSource:(NSArray *)sources;
- (void)changeFaceSubjectIndex:(NSInteger)subjectIndex;

@end
