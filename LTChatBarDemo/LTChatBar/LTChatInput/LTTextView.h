//
//  LTTextView.h
//  LTChatBarDemo
//
//  Created by Luther on 2019/5/8.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTTextView;
@protocol LTTextViewDelegate <UITextViewDelegate>

- (void)textViewDeleteBackward:(LTTextView *)textView;

@end

@interface LTTextView : UITextView

@property (nonatomic, weak) id <LTTextViewDelegate> delegate;

/** 占位文字 */
@property (nonatomic, copy) NSString *placeHolder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeHolderColor;

- (NSUInteger)numberOfLines;

@end
