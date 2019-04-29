//
//  LTChatEmojiMenuView.h
//  LTChatBarDemo
//
//  Created by Wade Wu on 2019/4/27.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTChatInputViewDelegate.h"

@interface LTChatEmojiMenuView : UIView
/* 添加表情按钮 */
@property (nonatomic, strong) UIButton *addButton;
/* 发送按钮 */
@property (nonatomic, strong) UIButton *sendButton;
/* 输入框下面的菜单栏 */
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *lastSelectEmojiGroup;

@property (nonatomic, assign) id <LTChatInputViewDelegate> delegate;

@end
