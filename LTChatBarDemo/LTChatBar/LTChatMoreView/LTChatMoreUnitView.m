//
//  LTChatMoreUnitView.m
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/29.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "LTChatMoreUnitView.h"
#import "UIView+Frame.h"
#import "LTChatBarHeader.h"
#import "LTChatMoreModel.h"

@implementation LTChatMoreUnitView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize {
    
    self.box = [[UIView alloc] initWithFrame:CGRectMake(5, 10, self.lt_w - 10, self.lt_w - 10)];
    self.box.layer.cornerRadius  = 5;
    self.box.layer.masksToBounds = YES;
    self.box.layer.borderColor   = [UIColor lightTextColor].CGColor;
    self.box.layer.borderWidth   = 1;
    self.box.backgroundColor     = [UIColor whiteColor];
    [self addSubview:self.box];
    
    CGFloat width  = self.box.lt_w - 22;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.box.lt_w - width) / 2, (self.box.lt_h - width) / 2, width, width)];
    [self.box addSubview:self.imageView];
    self.imageView.userInteractionEnabled = YES;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.box.maxY + 5, CHATBAR_MORE_ITEM_WIDTH, 20)];
    self.titleLabel.textColor     = [UIColor lightGrayColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font          = [UIFont systemFontOfSize:14];
    [self addSubview:self.titleLabel];
}

- (void)setMoreModel:(LTChatMoreModel *)moreModel
{
    _moreModel = moreModel;
    if (moreModel.imageName) {
        self.imageView.image = [UIImage imageNamed:moreModel.imageName];
    }
    self.titleLabel.text     = moreModel.name;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
