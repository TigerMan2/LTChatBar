//
//  LTEmojiGroup.m
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/28.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "LTEmojiGroup.h"
#import "LTChatBarHeader.h"
#import "LTEmojiModel.h"

@implementation LTEmojiGroup

@end

static LTEmojiGroupManager *manager = nil;
@implementation LTEmojiGroupManager

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
    });
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [LTEmojiGroupManager shareManager];
}


- (instancetype)init {
    self = [super init];
    if (self) {
        kWeakSelf;
        NSLock *lock = [NSLock new];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            [weakSelf emojiGroup];
            weakSelf.currentEmojiList = [NSMutableArray array];
            NSArray *emojiList = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:weakSelf.currentGroup.groupID ofType:@"plist"]];
            for (NSDictionary *dic in emojiList) {
                [lock lock];
                LTEmojiModel *model = [LTEmojiModel new];
                model.emojiName    = dic[@"face_name"];
                model.name         = dic[@"name"];
                model.emojiID      = dic[@"facd_id"];
                [weakSelf.currentEmojiList addObject:model];
                [lock unlock];
            }
        });
    }
    return self;
}
// 表情的组数
- (NSArray *)emojiGroup {
    
    if (!_emojiGroup) {
        LTEmojiGroup *group = [LTEmojiGroup new];
        group.emojiType    = LTEmojiTypeNormal;
        group.groupID      = @"normal_emoji";
        group.groupName    = @"emoji_normal";
        _emojiGroup        = [NSArray arrayWithObjects:group, nil];
    }
    return _emojiGroup;
}

- (LTEmojiGroup *)currentGroup {
    if (!_currentGroup) {
        _currentGroup = [self.emojiGroup firstObject];
    }
    return _currentGroup;
}


@end
