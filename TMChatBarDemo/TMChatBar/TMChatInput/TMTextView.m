//
//  TMTextView.m
//  TMChatBarDemo
//
//  Created by Luther on 2019/5/8.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "TMTextView.h"
#import "TMChatMacro.h"

@implementation TMTextView

@dynamic delegate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize {
    self.font = [UIFont systemFontOfSize:16.0f];
    self.textColor = [UIColor blackColor];
    self.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1.0].CGColor;
    self.layer.borderWidth = 0.65f;
    self.layer.cornerRadius = 5.0f;
    self.contentMode = UIViewContentModeRedraw;
    self.dataDetectorTypes = UIDataDetectorTypeNone;
    self.returnKeyType = UIReturnKeySend;
    self.enablesReturnKeyAutomatically = YES;
    
    _placeHolder = nil;
    _placeHolderColor = [UIColor lightGrayColor];
    
    [self addTextViewNotificationObservers];
    
}

- (void)dealloc {
    [self removeTextViewNotificationObserves];
}

- (void)deleteBackward {
    
    if (IsTextContainFace(self.text)) { //如果文字中有表情
        if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDeleteBackward:)]) {
            [self.delegate textViewDeleteBackward:self];
        }
    } else {
        [super deleteBackward];
    }
    
}

#pragma mark - TMTextView方法
- (NSUInteger)numberOfLines {
    return [TMTextView numberOfLinesForMessage:self.text];
}

+ (NSUInteger)maxCharactersPerLine {
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 33 : 109;
}

+ (NSUInteger)numberOfLinesForMessage:(NSString *)text {
    return (text.length / [self maxCharactersPerLine]) + 1;
}

#pragma mark - setter
- (void)setPlaceHolder:(NSString *)placeHolder {
    if ([_placeHolder isEqualToString:placeHolder]) {
        return;
    }
    
    _placeHolder = [placeHolder copy];
    [self setNeedsDisplay];
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    if ([_placeHolderColor isEqual:placeHolderColor]) {
        return;
    }
    
    _placeHolderColor = placeHolderColor;
    [self setNeedsDisplay];
}

#pragma mark - UITextView override
- (void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    [self setNeedsDisplay];
}

#pragma mark - Draw
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    if (self.text.length == 0 && self.placeHolder) {
        [self.placeHolderColor set];
        [self.placeHolder drawInRect:CGRectInset(rect, 7.0f, 7.5f) withAttributes:[self placeHolderTextAttributes]];
    }
    
}

#pragma mark - Notifications
- (void)addTextViewNotificationObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTextViewNofitication) name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTextViewNofitication) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTextViewNofitication) name:UITextViewTextDidEndEditingNotification object:self];
    
}

- (void)didReceiveTextViewNofitication {
    [self setNeedsDisplay];
}

- (void)removeTextViewNotificationObserves {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:self];
    
}

- (NSDictionary *)placeHolderTextAttributes {
    
    NSMutableParagraphStyle *patagraphStyle = [[NSMutableParagraphStyle alloc] init];
    patagraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    patagraphStyle.alignment = self.textAlignment;
    
    return @{
             NSFontAttributeName : self.font,
             NSForegroundColorAttributeName : self.placeHolderColor,
             NSParagraphStyleAttributeName : patagraphStyle
             };
    
}

@end
