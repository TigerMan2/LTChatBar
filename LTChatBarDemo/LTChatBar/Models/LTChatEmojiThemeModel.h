//
//  LTChateEmojiThemeModel.h
//  LTChatBarDemo
//
//  Created by Luther on 2019/5/9.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LTChatEmojiThemeStyle) {
    LTChatEmojiThemeStyleSystem,        //30*30
    LTChatEmojiThemeStyleCustom,        //40*40
    LTChatEmojiThemeStyleGif,           //60*60
};

@interface LTChatEmojiModel : NSObject

/** 表情标题 */
@property (nonatomic, strong) NSString *emojiTitle;
/** 表情图片 */
@property (nonatomic, strong) NSString *emojiIcon;

@end

@interface LTChatEmojiThemeModel : NSObject

@property (nonatomic, assign) LTChatEmojiThemeStyle themeStyle;
@property (nonatomic, strong) NSString *themeIcon;
@property (nonatomic, strong) NSString *themeDecribe;
@property (nonatomic, strong) NSArray *faceModels;

@end

