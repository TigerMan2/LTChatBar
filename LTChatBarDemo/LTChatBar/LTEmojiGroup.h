//
//  LTEmojiGroup.h
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/28.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTChatBarHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTEmojiGroup : NSObject

// 表情类型
@property (nonatomic, assign) LTEmojiType emojiType;
// 表情组id
@property (nonatomic, copy) NSString    *groupID;
// 表情组名
@property (nonatomic, copy) NSString    *groupName;

@end

@class LTEmojiModel;
@interface LTEmojiGroupManager : NSObject

@property (nonatomic, strong) NSArray *emojiGroup;

@property (nonatomic, strong) NSMutableArray <LTEmojiModel *> *currentEmojiList;

@property (nonatomic, strong) LTEmojiGroup *currentGroup;

+ (instancetype)shareManager;

@end

NS_ASSUME_NONNULL_END
