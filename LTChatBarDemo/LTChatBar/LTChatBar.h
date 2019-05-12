//
//  LTChatBar.h
//  LTChatBarDemo
//
//  Created by Luther on 2019/5/8.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTChatInputView.h"
#import "LTChatEmojiView.h"
#import "LTChatMoreView.h"
#import "LTChatMoreItem.h"
#import "LTChatInputItem.h"
#import "LTChatEmojiThemeModel.h"

@class LTChatBar;

@protocol LTChatBarDelegate <NSObject>

@optional

/**
 *  语音状态
 */
- (void)chatKeyBoardDidStartRecording:(LTChatBar *)chatKeyBoard;
- (void)chatKeyBoardDidCancelRecording:(LTChatBar *)chatKeyBoard;
- (void)chatKeyBoardDidFinishRecoding:(LTChatBar *)chatKeyBoard;
- (void)chatKeyBoardWillCancelRecoding:(LTChatBar *)chatKeyBoard;
- (void)chatKeyBoardContineRecording:(LTChatBar *)chatKeyBoard;

/**
 *  输入状态
 */
- (void)chatKeyBoardTextViewDidBeginEditing:(UITextView *)textView;
- (void)chatKeyBoardSendText:(NSString *)text;
- (void)chatKeyBoardTextViewDidChange:(UITextView *)textView;

/**
 * 表情
 */
- (void)chatKeyBoardAddFaceSubject:(LTChatBar *)chatKeyBoard;
- (void)chatKeyBoardSetFaceSubject:(LTChatBar *)chatKeyBoard;

/**
 *  更多功能
 */
- (void)chatKeyBoard:(LTChatBar *)chatKeyBoard didSelectMorePanelItemIndex:(NSInteger)index;

@end

@protocol LTChatBarDataSource <NSObject>

@required
- (NSArray<LTChatMoreItem *> *)chatKeyBoardMoreItems;
- (NSArray<LTChatInputItem *> *)chatKeyBoardInputItems;
- (NSArray<LTChatEmojiThemeModel *> *)chatKeyBoardEmojiSubjectItems;

@end

@interface LTChatBar : UIView

/**
 *  默认是导航栏透明，或者没有导航栏
 */
+ (instancetype)keyBoard;

/**
 *  当导航栏不透明时（强制要导航栏不透明）
 *
 *  @param translucent 是否透明
 *
 *  @return keyboard对象
 */
+ (instancetype)keyBoardWithNavgationBarTranslucent:(BOOL)translucent;


/**
 *  直接传入父视图的bounds过来
 *
 *  @param bounds 父视图的bounds，一般为控制器的view
 *
 *  @return keyboard对象
 */
+ (instancetype)keyBoardWithParentViewBounds:(CGRect)bounds;

@property (nonatomic, weak) id <LTChatBarDelegate> delegate;
@property (nonatomic, weak) id <LTChatBarDataSource> dataSource;
/** 设置关联的表 */
@property (nonatomic, weak) UITableView *associateTableView;
/** 占位文字 */
@property (nonatomic, strong) NSString *placeHolder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeHolderColor;
/** 语音是否开启，默认开启 */
@property (nonatomic, assign) BOOL allowVoice;
/** 表情是否开启，默认开启 */
@property (nonatomic, assign) BOOL allowFace;
/** 更多是否开启，默认开启 */
@property (nonatomic, assign) BOOL allowMore;
/** 切换bar是否开启，默认关闭 */
@property (nonatomic, assign) BOOL allowSwitchBar;

/** 弹起 */
- (void)keyboardUp;
/** 收回 */
- (void)keyboardDown;

@end
