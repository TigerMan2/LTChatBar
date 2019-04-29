//
//  LTChatBarHeader.h
//  LTChatBarDemo
//
//  Created by Wade Wu on 2019/4/27.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef LTChatBarHeader_h
#define LTChatBarHeader_h

#define kWIDTH  [UIScreen mainScreen].bounds.size.width
#define kHEIGHT [UIScreen mainScreen].bounds.size.height
// 判断是否iPhone X
#define IS_iPhoneX ([[UIScreen mainScreen] bounds].size.height >= 812)
//底部间距
#define bottomSpace (IS_iPhoneX ? 44 + 10 : 10)
// 输入框与父视图的间隔
#define CHATBAR_BACKGROUND_SPACE 8
// 输入框高度
#define CHATBAR_HEIGHT 49
// 输入框字体颜色
#define CHATBAR_TEXTCOLOR [UIColor darkGrayColor]
// 输入字体大小
#define CHATBAR_TEXT_FONT 15
// 输入框最大高度
#define CHATBAR_TEXT_MAX_HEIGHT 104
// 输入文本框的默认高度
#define CHATBAR_TEXT_MIN_HEIGHT 34
// 表情框高度
#define CHATBAR_EMOJI_VIEW_HEIGHT 215
#define CHATBAR_EMOJI_HEIGHT 141

// 输入框更多视图高度
#define CHATBAR_MORE_VIEW_HEIGHT 215
// item之间的横线间隔
#define CHATBAR_MORE_ITEM_H_INTERVAL 15
// item的宽度
#define CHATBAR_MORE_ITEM_WIDTH 60
// item之间的纵向间隔
#define CHATBAR_MORE_ITEM_V_INTERVAL (kWIDTH - 4 * CHATBAR_MORE_ITEM_WIDTH)/5.f

#define CHATBAR_MORE_ITEM_HEIGHT (CHATBAR_MORE_VIEW_HEIGHT - 10 - 2 * CHATBAR_MORE_ITEM_H_INTERVAL) / 2.f

#define  kTabbarSafeBottomMargin            (IS_iPhoneX ? 34.f : 0.f)
#define  kTabbarHeight                      (IS_iPhoneX ? 83.f : 49.f)

// 常规表情一行能显示的个数
#define NORMARL_EMOJI_ROW_COUNT kWIDTH >= 375 ? 8 : 7

// 对于block的弱引用
#define kWeakSelf           __weak __typeof(self)weakSelf = self;

// 菜单表情高度
static const CGFloat  MENU_EMOJI_ITEM_HEIGHT = 44;
// item宽度
static const CGFloat ITEM_WIDTH = 40;
// item高度
static const CGFloat ITEM_HEIGHT = 40;

static const CGFloat krowSpacing = 5;
// 动画表情一行能显示的个数
static const CGFloat GIF_EMOJI_ROW_COUNT = 4;



typedef NS_ENUM(NSUInteger, LTChatBarStatus) {
    LTChatBarStatusNone = 0,    //  无状态
    LTChatBarStatusVoice,       //  语音
    LTChatBarStatusEmoji,       //  表情
    LTChatBarStatusMore,        //  更多
    LTChatBarStatusKeyboard     //  键盘
};

typedef NS_ENUM(NSUInteger, LTChatBarRecordStatus) {
    LTChatBarRecordStatusNone   =   0,  //  初始状态
    LTChatBarRecordStatusRecording,     //  正在录音
    LTChatBarRecordStatusMoveOutSide,   //  移出
    LTChatBarRecordStatusMoveInSide,    //  移进
    LTChatBarRecordStatusCancel,        //  上滑取消录音
    LTChatBarRecordStatusEnd,           //  录音结束
    LTChatBarRecordStatusToolShot       //  录音太短
};

typedef NS_ENUM(NSUInteger, LTEmojiType) {
    LTEmojiTypeNormal,
    LTEmojiTypeGif
};

typedef NS_OPTIONS(NSUInteger, LTInputViewMoreStatus) {
    LTInputViewMoreStatusNone = 0,   // 无
    LTInputViewMoreStatusPhoto,      // 相册选择照片
    LTInputViewMoreStatusTakePhoto,  // 拍摄
    LTInputViewMoreStatusMail,       // 云邮
    LTInputViewMoreStatusCallPhone,  // 拨打电话
    LTInputViewMoreStatusVideo,      // 视频通话
    LTInputViewMoreStatusCard,       // 个人名片
    LTInputViewMoreStatusLocation,   // 位置
    LTInputViewMoreStatusFile        // 文件
};


#endif /* LTChatBarHeader_h */
