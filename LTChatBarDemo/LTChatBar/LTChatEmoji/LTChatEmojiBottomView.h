//
//  LTChatEmojiBottomView.h
//  LTChatBarDemo
//
//  Created by Luther on 2019/5/9.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddActionBlock)(void);
typedef void(^SetActionBlock)(void);

@class LTChatEmojiBottomView;

@protocol LTChatEmojiBottomViewDelegate <NSObject>

- (void)chatEmojiBottomView:(LTChatEmojiBottomView *)bottomView didPickerEmojiSubjectIndex:(NSInteger)emojiSubjectIndex;
- (void)chatEmojiBottomViewSendAction:(LTChatEmojiBottomView *)bottomView;

@end

@interface LTChatEmojiBottomView : UIView

@property (nonatomic, weak) id <LTChatEmojiBottomViewDelegate> delegate;

@property (nonatomic, copy) AddActionBlock addAction;
@property (nonatomic, copy) SetActionBlock setAction;

- (void)loadfaceThemePickerSource:(NSArray *)sources;
- (void)changeFaceSubjectIndex:(NSInteger)subjectIndex;

@end
