//
//  TMTextView.h
//  TMChatBarDemo
//
//  Created by Luther on 2019/5/8.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMTextView;
@protocol TMTextViewDelegate <UITextViewDelegate>

- (void)textViewDeleteBackward:(TMTextView *)textView;

@end

@interface TMTextView : UITextView

@property (nonatomic, weak) id <TMTextViewDelegate> delegate;

/** 占位文字 */
@property (nonatomic, copy) NSString *placeHolder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeHolderColor;

- (NSUInteger)numberOfLines;

@end
