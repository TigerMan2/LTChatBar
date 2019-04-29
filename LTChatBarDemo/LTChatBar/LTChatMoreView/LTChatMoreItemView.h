//
//  LTChatMoreItemView.h
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/29.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTChatMoreItemView : UIView

/** 所有视图 */
@property (nonatomic, strong) NSMutableArray  *moreUnitViews;

- (void)showMoreItemFromIndex:(NSInteger)fromIndex count:(NSInteger)count;

@end

