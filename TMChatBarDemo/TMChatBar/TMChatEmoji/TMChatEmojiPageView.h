//
//  TMChatEmojiPageView.h
//  TMChatBarDemo
//
//  Created by Luther on 2019/5/9.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMChatEmojiThemeModel.h"

@interface TMChatEmojiPageView : UICollectionViewCell

@property (nonatomic, assign) TMChatEmojiThemeStyle themeStyle;

- (void)loadPerPageEmojiData:(NSArray *)emojiData;

@end

