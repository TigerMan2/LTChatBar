//
//  LTRecordView.m
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/26.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "LTRecordView.h"
#import "UIView+Frame.h"

@implementation LTRecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.userInteractionEnabled = YES;
        self.textLabel.text = @"按住 说话";
        [self.textLabel sizeToFit];
        [self addSubview:self.textLabel];
        self.textLabel.frame = CGRectMake((self.lt_w - self.textLabel.lt_w)/2, (self.lt_h - self.textLabel.lt_h)/2, self.textLabel.lt_w, self.textLabel.lt_h);
    }
    return self;
}

@end
