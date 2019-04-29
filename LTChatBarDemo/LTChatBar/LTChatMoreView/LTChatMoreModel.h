//
//  LTChatMoreModel.h
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/29.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTChatMoreModel : NSObject

@property (nonatomic, strong) NSString *extendId;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *imageName;

@end

@interface LTChatMoreManager : NSObject

@property (nonatomic, strong) NSMutableArray *moreItemModels;

@end
