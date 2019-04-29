//
//  LTChatMoreModel.m
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/29.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "LTChatMoreModel.h"

@implementation LTChatMoreModel

@end

@implementation LTChatMoreManager

- (NSMutableArray *)moreItemModels
{
    if (!_moreItemModels)
    {
        _moreItemModels = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"InputBoxMore" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *dic in array)
        {
            LTChatMoreModel *model = [LTChatMoreModel new];
            model.extendId            = dic[@"extendId"];
            model.name                = dic[@"name"];
            model.imageName           = dic[@"imageName"];
            [_moreItemModels addObject:model];
        }
    }
    
    return _moreItemModels;
}

@end
