//
//  LTHorizontalPageFlowlayout.h
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/28.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTHorizontalPageFlowlayout : UICollectionViewFlowLayout

/** 列间距 */
@property (nonatomic, assign) CGFloat columnSpacing;
/** 行间距 */
@property (nonatomic, assign) CGFloat rowSpacing;
/** CollectionView的内边距 */
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
/** 多少行 */
@property (nonatomic, assign) NSInteger rowCount;
/** 每行展示多少item */
@property (nonatomic, assign) NSInteger itemCountPerRow;
/** 所有item的数组 */
@property (nonatomic, strong) NSMutableArray *attributesArrayM;

@property (nonatomic, assign) NSInteger pageNumber;

/**
 设置行列间距及collectionView的内边距
 */
- (void)setColumnSpacing:(CGFloat)columnSpacing
              rowSpacing:(CGFloat)rowSpacing
              edgeInsets:(UIEdgeInsets)edgeInsets;
/**
 设置多少行及每行展示的item个数
 */
- (void)setRowCount:(NSInteger)rowCount
    itemCountPerRow:(NSInteger)itemCountPerRow;

#pragma mark - 构造方法
/**
 设置多少行及每行展示的item个数
 */
+ (instancetype)KHorizontalPageFlowlayoutWithRowCount:(NSInteger)rowCount
                                      itemCountPerRow:(NSInteger)itemCountPerRow;
/**
 设置多少行及每行展示的item个数
 */
- (instancetype)initWithRowCount:(NSInteger)rowCount
                 itemCountPerRow:(NSInteger)itemCountPerRow;


@end

NS_ASSUME_NONNULL_END

