//
//  TMChatMoreView.h
//  TMChatBarDemo
//
//  Created by Luther on 2019/5/8.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMChatMoreItem;
@class TMChatMoreView;

@protocol TMChatMoreViewDelegate <NSObject>

@optional
- (void)chatMoreView:(TMChatMoreView *)moreView didSelectedIndex:(NSInteger)index;

@end

@interface TMChatMoreView : UIView

@property (nonatomic, weak) id <TMChatMoreViewDelegate> delegate;

- (void)loadMoreItems:(NSArray <TMChatMoreItem *> *)items;

@end
