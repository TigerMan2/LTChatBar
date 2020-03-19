//
//  ViewController.m
//  TMChatBarDemo
//
//  Created by Luther on 2019/5/8.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "ViewController.h"
#import "TMChatBar.h"

@interface ViewController () <TMChatBarDataSource,TMChatBarDelegate>

/** chatkeyBoard */
@property (nonatomic, strong) TMChatBar *chatKeyBoard;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.frame = CGRectMake(50, 150, 120, 44);
    [btn1 setTitle:@"让键盘弹起" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor purpleColor];
    [btn1 addTarget:self action:@selector(clickBtnUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 170, 150, 120, 44);
    [btn2 setTitle:@"让键盘下去" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor purpleColor];
    [btn2 addTarget:self action:@selector(clickBtnDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    self.chatKeyBoard = [TMChatBar keyBoardWithNavgationBarTranslucent:YES];
    
    self.chatKeyBoard.delegate = self;
    self.chatKeyBoard.dataSource = self;
    
    self.chatKeyBoard.placeHolder = @"请输入消息，请输入消息，请输入消息，请输入消息，请输入消息，请输入消息，请输入消息，请输入消息";
    [self.view addSubview:self.chatKeyBoard];
}

- (void)clickBtnUp:(UIButton *)btn
{
    [self.chatKeyBoard keyboardUp];
}

- (void)clickBtnDown:(UIButton *)btn
{
    [self.chatKeyBoard keyboardDown];
}

- (void)chatKeyBoard:(TMChatBar *)chatKeyBoard didSelectMorePanelItemIndex:(NSInteger)index {
    NSLog(@"-------%ld",index);
}

- (void)chatKeyBoardSendText:(NSString *)text {
    NSLog(@"----------%@",text);
}

#pragma mark -- ChatKeyBoardDataSource
- (NSArray<TMChatMoreItem *> *)chatKeyBoardMoreItems
{
    TMChatMoreItem *item1 = [TMChatMoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    TMChatMoreItem *item2 = [TMChatMoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    TMChatMoreItem *item3 = [TMChatMoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    TMChatMoreItem *item4 = [TMChatMoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    TMChatMoreItem *item5 = [TMChatMoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    TMChatMoreItem *item6 = [TMChatMoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    TMChatMoreItem *item7 = [TMChatMoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    TMChatMoreItem *item8 = [TMChatMoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    TMChatMoreItem *item9 = [TMChatMoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    return @[item1, item2, item3, item4, item5, item6, item7, item8, item9];
}
- (NSArray<TMChatInputItem *> *)chatKeyBoardInputItems
{
    TMChatInputItem *item1 = [TMChatInputItem barItemWithNormalImageStr:@"face" selectedImageStr:@"keyboard" highLightImageStr:@"face_HL" itemType:TMChatButtonTypeFace];
    
    TMChatInputItem *item2 = [TMChatInputItem barItemWithNormalImageStr:@"voice" selectedImageStr:@"keyboard" highLightImageStr:@"voice_HL" itemType:TMChatButtonTypeVoice];
    
    TMChatInputItem *item3 = [TMChatInputItem barItemWithNormalImageStr:@"more_ios" selectedImageStr:nil highLightImageStr:@"more_ios_HL" itemType:TMChatButtonTypeMore];
    
    TMChatInputItem *item4 = [TMChatInputItem barItemWithNormalImageStr:@"switchDown" selectedImageStr:nil highLightImageStr:nil itemType:TMChatButtonTypeSwitchBar];
    
    return @[item1, item2, item3, item4];
}

- (NSArray<TMChatEmojiThemeModel *> *)chatKeyBoardEmojiSubjectItems
{
    NSMutableArray *subjectArray = [NSMutableArray array];
    
    NSArray *sources = @[@"face", @"systemEmoji",@"emotion",@"systemEmoji",@"face",@"systemEmoji",@"emotion",@"emotion",@"face",@"face",@"emotion",@"face", @"emotion",@"face", @"emotion"];
    
    for (int i = 0; i < sources.count; ++i)
    {
        NSString *plistName = sources[i];
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
        NSDictionary *faceDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSArray *allkeys = faceDic.allKeys;
        
        TMChatEmojiThemeModel *themeM = [[TMChatEmojiThemeModel alloc] init];
        
        if ([plistName isEqualToString:@"face"]) {
            themeM.themeStyle = TMChatEmojiThemeStyleCustom;
            themeM.themeDecribe = [NSString stringWithFormat:@"f%d", i];
            themeM.themeIcon = @"section0_emotion0";
        }else if ([plistName isEqualToString:@"systemEmoji"]){
            themeM.themeStyle = TMChatEmojiThemeStyleSystem;
            themeM.themeDecribe = @"sEmoji";
            themeM.themeIcon = @"";
        }
        else {
            themeM.themeStyle = TMChatEmojiThemeStyleGif;
            themeM.themeDecribe = [NSString stringWithFormat:@"e%d", i];
            themeM.themeIcon = @"f_static_000";
        }
        
        
        NSMutableArray *modelsArr = [NSMutableArray array];
        
        for (int i = 0; i < allkeys.count; ++i) {
            NSString *name = allkeys[i];
            TMChatEmojiModel *fm = [[TMChatEmojiModel alloc] init];
            fm.emojiTitle = name;
            fm.emojiIcon = [faceDic objectForKey:name];
            [modelsArr addObject:fm];
        }
        themeM.faceModels = modelsArr;
        
        [subjectArray addObject:themeM];
    }
    return subjectArray;
}


@end
