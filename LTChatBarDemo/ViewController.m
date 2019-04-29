//
//  ViewController.m
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/25.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "ViewController.h"
#import "LTChatBar/LTChatBar.h"
#import "LTChatBar/UIView+Frame.h"

@interface ViewController () <LTChatBarDelegate>

@property (nonatomic, strong) LTChatBar *chatBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chatBar = [[LTChatBar alloc] initWithFrame:CGRectMake(0, self.view.lt_h - kTabbarHeight, kWIDTH, kTabbarHeight)];
    self.chatBar.delegate = self;
    [self.view addSubview:self.chatBar];
    
}

#pragma mark - KInputBoxViewCtrl代理
- (void)chatBar:(LTChatBar *)chatBar didChangeInputViewHeight:(CGFloat)height {
    self.chatBar.frame = CGRectMake(0, self.view.lt_h - height, kWIDTH, height);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
