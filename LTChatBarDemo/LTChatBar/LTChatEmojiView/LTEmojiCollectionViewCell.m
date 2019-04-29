//
//  LTEmojiCollectionViewCell.m
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/28.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "LTEmojiCollectionViewCell.h"
#import "LTChatBarHeader.h"
#import "UIView+Frame.h"
#import "UIColor+LT.h"

@implementation LTEmojiCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self imageView];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self imageView];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        self.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.lt_w - ITEM_WIDTH + 10)/2., (self.lt_w - ITEM_HEIGHT + 10)/2., ITEM_WIDTH -10 , ITEM_HEIGHT - 10)];
        _imageView.backgroundColor = self.backgroundColor;
        [self addSubview:_imageView];
    }
    return _imageView;
}

@end
