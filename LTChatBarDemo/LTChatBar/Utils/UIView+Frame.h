//
//  UIView+Frame.h
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/25.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat lt_x;
@property (nonatomic, assign) CGFloat lt_y;
@property (nonatomic, assign) CGFloat lt_w;
@property (nonatomic, assign) CGFloat lt_h;
@property (nonatomic, assign, readonly) CGFloat maxX;
@property (nonatomic, assign, readonly) CGFloat maxY;

@end
