//
//  LTChatMoreItemView.m
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/29.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "LTChatMoreItemView.h"
#import "LTChatMoreModel.h"
#import "LTChatMoreUnitView.h"
#import "UIView+Frame.h"
#import "LTChatBarHeader.h"

@implementation LTChatMoreItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)showMoreItemFromIndex:(NSInteger)fromIndex count:(NSInteger)count {
    
    LTChatMoreManager *manager = [[LTChatMoreManager alloc] init];
    LTChatMoreUnitView *lastUnitView = nil;
    
    NSArray *moreModels = manager.moreItemModels;
    
    NSInteger circleIndex = 0;
    NSInteger diffrienceValue = 0;
    if (count > moreModels.count) {
        diffrienceValue = count - moreModels.count;
    }
    count = count - diffrienceValue;
    
    for (NSInteger i = fromIndex; i < count + fromIndex; i ++) {
        
        LTChatMoreUnitView *unitView = nil;
        if (circleIndex < self.moreUnitViews.count) {
            unitView = [self.moreUnitViews objectAtIndex:circleIndex];
        } else {
            if (circleIndex % 4 != 0) {
                CGFloat originY = lastUnitView != nil ? lastUnitView.lt_y : CHATBAR_MORE_ITEM_H_INTERVAL;
                unitView = [[LTChatMoreUnitView alloc] initWithFrame:CGRectMake(lastUnitView.maxX + CHATBAR_MORE_ITEM_V_INTERVAL, originY, CHATBAR_MORE_ITEM_WIDTH, CHATBAR_MORE_ITEM_HEIGHT)];
            } else {
                CGFloat originY = lastUnitView != nil ? lastUnitView.maxY : CHATBAR_MORE_ITEM_H_INTERVAL;
                unitView = [[LTChatMoreUnitView alloc] initWithFrame:CGRectMake(CHATBAR_MORE_ITEM_V_INTERVAL, originY, CHATBAR_MORE_ITEM_WIDTH, CHATBAR_MORE_ITEM_HEIGHT)];
            }
            
            [self addSubview:unitView];
            [self.moreUnitViews addObject:unitView];
            lastUnitView = unitView;
        }
        
        circleIndex += 1;
        [unitView addTarget:self action:@selector(didselecteMoreUnitView:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i >= manager.moreItemModels.count || i < 0)
        {
            [unitView setHidden:YES];
        }
        else
        {
            LTChatMoreModel *moreModel = moreModels[i];
            unitView.tag = i;
            [unitView setMoreModel:moreModel];
            [unitView setHidden:NO];
        }
    }
}

- (void)didselecteMoreUnitView:(LTChatMoreUnitView *)unitView
{
    LTInputViewMoreStatus inputBoxMoreStatus = unitView.tag + 1;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KInputBoxDidSelectedMoreView" object:nil userInfo:@{@"status":@(inputBoxMoreStatus)}];
    
}

@end
