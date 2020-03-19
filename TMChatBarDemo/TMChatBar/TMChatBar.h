//
//  TMChatBar.h
//  TMChatBarDemo
//
//  Created by Luther on 2019/5/8.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMChatInputView.h"
#import "TMChatEmojiView.h"
#import "TMChatMoreView.h"
#import "TMChatMoreItem.h"
#import "TMChatInputItem.h"
#import "TMChatEmojiThemeModel.h"

@class TMChatBar;

@protocol TMChatBarDelegate <NSObject>

@optional

/**
 *  语音状态
 */
- (void)chatKeyBoardDidStartRecording:(TMChatBar *)chatKeyBoard;
- (void)chatKeyBoardDidCancelRecording:(TMChatBar *)chatKeyBoard;
- (void)chatKeyBoardDidFinishRecoding:(TMChatBar *)chatKeyBoard;
- (void)chatKeyBoardWillCancelRecoding:(TMChatBar *)chatKeyBoard;
- (void)chatKeyBoardContineRecording:(TMChatBar *)chatKeyBoard;

/**
 *  输入状态
 */
- (void)chatKeyBoardTextViewDidBeginEditing:(UITextView *)textView;
- (void)chatKeyBoardSendText:(NSString *)text;
- (void)chatKeyBoardTextViewDidChange:(UITextView *)textView;

/**
 * 表情
 */
- (void)chatKeyBoardAddFaceSubject:(TMChatBar *)chatKeyBoard;
- (void)chatKeyBoardSetFaceSubject:(TMChatBar *)chatKeyBoard;

/**
 *  更多功能
 */
- (void)chatKeyBoard:(TMChatBar *)chatKeyBoard didSelectMorePanelItemIndex:(NSInteger)index;

@end

@protocol TMChatBarDataSource <NSObject>

@required
- (NSArray<TMChatMoreItem *> *)chatKeyBoardMoreItems;
- (NSArray<TMChatInputItem *> *)chatKeyBoardInputItems;
- (NSArray<TMChatEmojiThemeModel *> *)chatKeyBoardEmojiSubjectItems;

@end

@interface TMChatBar : UIView

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

@property (nonatomic, weak) id <TMChatBarDelegate> delegate;
@property (nonatomic, weak) id <TMChatBarDataSource> dataSource;
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
