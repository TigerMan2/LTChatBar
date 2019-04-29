//
//  LTEmojiModel.h
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/26.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTEmojiModel : NSObject

// 表情id
@property (nonatomic, strong) NSString *emojiID;
// 表情名
@property (nonatomic, strong) NSString *emojiName;

@property (nonatomic, strong) NSString *name;

@end

NS_ASSUME_NONNULL_END
