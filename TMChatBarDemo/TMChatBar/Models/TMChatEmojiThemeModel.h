//
//  TMChateEmojiThemeModel.h
//  TMChatBarDemo
//
//  Created by Luther on 2019/5/9.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TMChatEmojiThemeStyle) {
    TMChatEmojiThemeStyleSystem,        //30*30
    TMChatEmojiThemeStyleCustom,        //40*40
    TMChatEmojiThemeStyleGif,           //60*60
};

@interface TMChatEmojiModel : NSObject

/** 表情标题 */
@property (nonatomic, strong) NSString *emojiTitle;
/** 表情图片 */
@property (nonatomic, strong) NSString *emojiIcon;

@end

@interface TMChatEmojiThemeModel : NSObject

@property (nonatomic, assign) TMChatEmojiThemeStyle themeStyle;
@property (nonatomic, strong) NSString *themeIcon;
@property (nonatomic, strong) NSString *themeDecribe;
@property (nonatomic, strong) NSArray *faceModels;

@end

