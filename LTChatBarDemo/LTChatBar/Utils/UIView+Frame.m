//
//  UIView+Frame.m
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/25.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)lt_x {
    return self.frame.origin.x;
}

- (void)setLt_x:(CGFloat)lt_x {
    CGRect frame = self.frame;
    frame.origin.x = lt_x;
    self.frame = frame;
}

- (CGFloat)lt_y {
    return self.frame.origin.y;
}

- (void)setLt_y:(CGFloat)lt_y {
    CGRect frame = self.frame;
    frame.origin.y = lt_y;
    self.frame = frame;
}

- (CGFloat)lt_w {
    return self.frame.size.width;
}

- (void)setLt_w:(CGFloat)lt_w {
    CGRect frame = self.frame;
    frame.size.width = lt_w;
    self.frame = frame;
}

- (CGFloat)lt_h {
    return self.frame.size.height;
}

- (void)setLt_h:(CGFloat)lt_h {
    CGRect frame = self.frame;
    frame.size.height = lt_h;
    self.frame = frame;
}

- (CGFloat)maxX {
    return self.lt_x + self.lt_w;
}

- (CGFloat)maxY {
    return self.lt_y + self.lt_h;
}

@end
