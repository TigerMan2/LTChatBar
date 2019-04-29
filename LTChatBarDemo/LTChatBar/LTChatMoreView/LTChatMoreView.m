//
//  LTChatMoreView.m
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/25.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "LTChatMoreView.h"
#import "LTChatMoreItemView.h"
#import "LTChatMoreUnitView.h"
#import "LTChatBarHeader.h"
#import "LTChatMoreModel.h"
#import "UIColor+LT.h"
#import "UIView+Frame.h"

@interface LTChatMoreView () <UIScrollViewDelegate>
/** 页数 */
@property (nonatomic, assign) NSInteger pageNumber;
/** 数组 */
@property (nonatomic, strong) NSMutableArray *moreItemViews;

@end

@implementation LTChatMoreView

- (NSMutableArray *)moreItemViews
{
    if (!_moreItemViews) {
        _moreItemViews = [NSMutableArray arrayWithCapacity:1];
        
        for (int i = 0; i < self.pageNumber; i ++) {
            LTChatMoreItemView *moreItemView = [[LTChatMoreItemView alloc] initWithFrame:CGRectMake(kWIDTH * i, 0, kWIDTH, CHATBAR_MORE_VIEW_HEIGHT)];
            [moreItemView showMoreItemFromIndex:i count:8];
            [_moreItemViews addObject:moreItemView];
        }
    }
    
    return _moreItemViews;
}

- (NSInteger)pageNumber
{
    if (!_pageNumber)
    {
        LTChatMoreManager *inputBoxMoreManager = [[LTChatMoreManager alloc] init];
        NSInteger page = inputBoxMoreManager.moreItemModels.count / 8;
        NSInteger remainder = inputBoxMoreManager.moreItemModels.count % 8;
        _pageNumber = page + remainder;
    }
    
    return _pageNumber;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
    self.userInteractionEnabled = YES;
    self.topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, 1)];
    self.topLine.backgroundColor = [UIColor colorWithHexString:@"0xE6E6E6"];
    [self addSubview:self.topLine];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, CHATBAR_MORE_VIEW_HEIGHT - 30)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.scrollView.maxY, kWIDTH, 30)];
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"0xd8d8d8"];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.numberOfPages = self.pageNumber;
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pageControl];
    
    for (LTChatMoreItemView *itemView in self.moreItemViews) {
        [self.scrollView addSubview:itemView];
    }
    
    [self.scrollView setContentSize:CGSizeMake(kWIDTH * self.pageNumber, CHATBAR_MORE_VIEW_HEIGHT - 30)];
    
}

- (void)changePage:(UIPageControl *)pageCtrl {
    [self.scrollView setContentOffset:CGPointMake(kWIDTH * pageCtrl.currentPage, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentPage = scrollView.contentOffset.x / kWIDTH;
    self.pageControl.currentPage = currentPage;
}
@end
