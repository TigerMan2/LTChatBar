//
//  LTChatMoreView.m
//  LTChatBarDemo
//
//  Created by Luther on 2019/5/8.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "LTChatMoreView.h"
#import "LTChatMacro.h"
#import "LTChatMoreItem.h"

@class LTChatMoreItemView;

typedef void(^ItemViewAction)(LTChatMoreItemView *itemView);

@interface LTChatMoreItemView : UIView

@property (nonatomic, copy) ItemViewAction itemAction;

@end

@implementation LTChatMoreItemView
{
    UIButton *_iconButton;
    UILabel *_nameLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize {
    
    _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _iconButton.frame = CGRectMake(0, 0, kMoreItemIconSize, kMoreItemIconSize);
    [_iconButton addTarget:self action:@selector(iconClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_iconButton];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kMoreItemIconSize, kMoreItemIconSize, kMoreItemH - kMoreItemIconSize)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:_nameLabel];
    
}

- (void)iconClickAction:(UIButton *)sender {
    if (self.itemAction) {
        self.itemAction(self);
    }
}

- (void)updateViewWithItem:(LTChatMoreItem *)item {
    [_iconButton setImage:[UIImage imageNamed:item.itemPicName] forState:UIControlStateNormal];
    [_iconButton setImage:[UIImage imageNamed:item.itemHighLightPicName] forState:UIControlStateHighlighted];
    
    _nameLabel.text = item.itemName;
}

@end

@interface LTChatMoreView ()<UIScrollViewDelegate>

@end

@implementation LTChatMoreView
{
    UIScrollView *_contentView;
    UIPageControl *_pageControl;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize {
    
    self.backgroundColor = kChatKeyBoardColor;
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kMorePanelHeight - kUIPageControllerHeight)];
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.pagingEnabled = YES;
    _contentView.delegate = self;
    [self addSubview:_contentView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentView.frame), self.frame.size.width, kUIPageControllerHeight)];
    _pageControl.hidesForSinglePage = YES;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:_pageControl];
    
}

- (void)loadMoreItems:(NSArray <LTChatMoreItem *> *)items {
    
    NSInteger maxLinesOfPage = 2;
    NSInteger maxColsOfPage = 4;
    
    NSInteger pages = (items.count / (maxColsOfPage * maxLinesOfPage)) + 1;
    _pageControl.numberOfPages = pages;
    _contentView.contentSize = CGSizeMake(self.frame.size.width * pages, 0);
    
    CGFloat hMargin = (CGRectGetWidth(_contentView.frame) - kMoreItemIconSize * maxColsOfPage) / (maxColsOfPage + 1);
    CGFloat vMargin = (CGRectGetHeight(_contentView.frame) - kMoreItemH *maxLinesOfPage) / (maxLinesOfPage + 1);
    
    for (int i = 0; i < items.count; i ++) {
        
        NSInteger pageIndex = i / (maxLinesOfPage * maxColsOfPage);
        
        CGFloat x = pageIndex * CGRectGetWidth(_contentView.frame) + (i % maxColsOfPage)*(kMoreItemIconSize + hMargin) + hMargin;
        CGFloat y = ((i - pageIndex * (maxLinesOfPage * maxColsOfPage)) / maxColsOfPage) * (kMoreItemH + vMargin) + vMargin;
        
        LTChatMoreItem *item = items[i];
        LTChatMoreItemView *view = [[LTChatMoreItemView alloc] initWithFrame:CGRectMake(x, y, kMoreItemIconSize, kMoreItemH)];
        [view updateViewWithItem:item];
        view.tag = i;
        view.itemAction = ^(LTChatMoreItemView *itemView) {
            if ([self.delegate respondsToSelector:@selector(chatMoreView:didSelectedIndex:)]) {
                [self.delegate chatMoreView:self didSelectedIndex:itemView.tag];
            }
        };
        [_contentView addSubview:view];
        
    }
}

#pragma mark -- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _contentView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger currentIndex = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
        _pageControl.currentPage = currentIndex;
    }
}

@end
