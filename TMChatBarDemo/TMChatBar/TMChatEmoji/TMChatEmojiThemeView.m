//
//  TMChatEmojiThemeView.m
//  TMChatBarDemo
//
//  Created by Luther on 2019/5/9.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "TMChatEmojiThemeView.h"
#import "TMChatEmojiPageView.h"
#import "TMChatMacro.h"

NSString *const PageEmojiViewIdentifier = @"PageEmojiViewIdentifier";

@interface TMChatEmojiThemeView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) TMChatEmojiThemeModel *themeModel;
@property (nonatomic, strong) NSArray *pageEmojiArray;

@end

@implementation TMChatEmojiThemeView
{
    UICollectionView *_collectionView;
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
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = self.bounds.size;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.pagingEnabled = YES;
    _collectionView.bounces = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    [_collectionView registerClass:[TMChatEmojiPageView class] forCellWithReuseIdentifier:PageEmojiViewIdentifier];
    
    [self addSubview:_collectionView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - kUIPageControllerHeight, self.frame.size.width, kUIPageControllerHeight)];
    _pageControl.currentPage = 0;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:_pageControl];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pageEmojiArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TMChatEmojiPageView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PageEmojiViewIdentifier forIndexPath:indexPath];
    cell.themeStyle = self.themeModel.themeStyle;
    [cell loadPerPageEmojiData:self.pageEmojiArray[indexPath.row]];
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _collectionView) {
        //每页宽度
        CGFloat pageWidth = scrollView.frame.size.width;
        //根据当前的坐标与页宽计算当前页码
        NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;
        [_pageControl setCurrentPage:currentPage];
    }
}

- (void)loadEmojiTheme:(TMChatEmojiThemeModel *)themeModel {
    
    _themeModel = themeModel;
    
    NSInteger numbersOfPage = [self numbersOfPerPage:themeModel];
    
    NSMutableArray *pagesArray = [[NSMutableArray alloc] init];
    NSInteger counts = themeModel.faceModels.count;
    
    NSMutableArray *page = nil;
    for (int i = 0; i < counts; i ++) {
        if (i % numbersOfPage == 0) {
            page = [NSMutableArray array];
            [pagesArray addObject:page];
        }
        
        [page addObject:themeModel.faceModels[i]];
    }
    
    self.pageEmojiArray = [NSMutableArray arrayWithArray:pagesArray];
    _pageControl.numberOfPages = self.pageEmojiArray.count;
    
}

- (NSInteger)numbersOfPerPage:(TMChatEmojiThemeModel *)themeModel {
    
    NSInteger perPageNum = 0;
    
    if (themeModel.themeStyle == TMChatEmojiThemeStyleSystem) {
        
        NSInteger colNumber = 7;
        if (isIPhone4_5)
            colNumber = 7;
        else if (isIPhone6_6s)
            colNumber = 8;
        else if (isIPhone6p_6sp)
            colNumber = 9;
        perPageNum = colNumber * 3 - 1;
    } else if (themeModel.themeStyle == TMChatEmojiThemeStyleCustom) {
        NSInteger colNumber = 7;
        if (isIPhone4_5)
            colNumber = 7;
        else if (isIPhone6_6s)
            colNumber = 8;
        else if (isIPhone6p_6sp)
            colNumber = 9;
        perPageNum = colNumber * 3 - 1;
    } else if (themeModel.themeStyle == TMChatEmojiThemeStyleGif) {
        perPageNum = 4 * 2;
    }
    
    return perPageNum;
}

@end
