//
//  LTChatEmojiView.h
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/25.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTChatEmojiMenuView.h"

@interface LTChatEmojiView : UIView

@property (nonatomic, weak) id <LTChatInputViewDelegate> delegate;
/** 表情菜单 */
@property (nonatomic, strong) LTChatEmojiMenuView *menuView;

@end
