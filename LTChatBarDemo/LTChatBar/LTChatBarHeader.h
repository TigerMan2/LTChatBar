//
//  LTChatBarHeader.h
//  LTChatBarDemo
//
//  Created by Wade Wu on 2019/4/27.
//  Copyright © 2019 mrstock. All rights reserved.
//

#ifndef LTChatBarHeader_h
#define LTChatBarHeader_h

#define kWIDTH  [UIScreen mainScreen].bounds.size.width
#define kHEIGHT [UIScreen mainScreen].bounds.size.height
// 判断是否iPhone X
#define IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
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

#define  kTabbarSafeBottomMargin            (IS_iPhoneX ? 34.f : 0.f)
#define  kTabbarHeight                      (IS_iPhoneX ? 83.f : 49.f)

// 菜单表情高度
static const CGFloat  MENU_EMOJI_ITEM_HEIGHT = 44;

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


#endif /* LTChatBarHeader_h */
