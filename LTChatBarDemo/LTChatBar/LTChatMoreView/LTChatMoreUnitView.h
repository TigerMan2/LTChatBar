//
//  LTChatMoreUnitView.h
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/29.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTChatMoreModel;

@interface LTChatMoreUnitView : UIControl

/** 框 */
@property (nonatomic, strong) UIView *box;
/** 图标 */
@property (nonatomic, strong) UIImageView *imageView;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) LTChatMoreModel *moreModel;

@end
