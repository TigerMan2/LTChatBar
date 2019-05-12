//
//  LTChatMoreItem.h
//  LTChatBarDemo
//
//  Created by Luther on 2019/5/9.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTChatMoreItem : NSObject

@property (nonatomic, strong) NSString *itemPicName;
@property (nonatomic, strong) NSString *itemHighLightPicName;
@property (nonatomic, strong) NSString *itemName;

+ (instancetype)moreItemWithPicName:(NSString *)picName highLightPicName:(NSString *)highLightPicName itemName:(NSString *)itemName;

@end
