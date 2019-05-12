//
//  LTChatMoreView.h
//  LTChatBarDemo
//
//  Created by Luther on 2019/5/8.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTChatMoreItem;
@class LTChatMoreView;

@protocol LTChatMoreViewDelegate <NSObject>

@optional
- (void)chatMoreView:(LTChatMoreView *)moreView didSelectedIndex:(NSInteger)index;

@end

@interface LTChatMoreView : UIView

@property (nonatomic, weak) id <LTChatMoreViewDelegate> delegate;

- (void)loadMoreItems:(NSArray <LTChatMoreItem *> *)items;

@end
