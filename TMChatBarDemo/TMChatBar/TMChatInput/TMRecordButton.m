//
//  TMRecordButton.m
//  TMChatBarDemo
//
//  Created by Luther on 2019/5/8.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "TMRecordButton.h"

#define kGetColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@implementation TMRecordButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self didInitailize];
    }
    return self;
}

- (void)didInitailize {
    
    self.hidden = YES;
    self.backgroundColor = kGetColor(247, 247, 247);
    
    [self setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    self.layer.cornerRadius = 5.0f;
    self.layer.borderWidth = 0.5f;
    self.layer.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0].CGColor;
    
    [self addTarget:self action:@selector(recordTouchDown) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(recordTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(recordTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(recordTouchDragEnter) forControlEvents:UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(recordTouchDragInside) forControlEvents:UIControlEventTouchDragInside];
    [self addTarget:self action:@selector(recordTouchDragOutside) forControlEvents:UIControlEventTouchDragOutside];
    [self addTarget:self action:@selector(recordTouchDragExit) forControlEvents:UIControlEventTouchDragExit];
    
}

- (void)setButtonStateRecording {
    self.backgroundColor = kGetColor(214, 215, 220);
    [self setTitle:@"松开 发送" forState:UIControlStateNormal];
}

- (void)setButtonStateNormal {
    self.backgroundColor = kGetColor(247, 247, 247);
    [self setTitle:@"按住 说话" forState:UIControlStateNormal];
}

- (void)recordTouchDown {
    if (self.recordTouchDownAction) {
        self.recordTouchDownAction(self);
    }
}

- (void)recordTouchUpInside {
    if (self.recordTouchUpInsideAction) {
        self.recordTouchUpInsideAction(self);
    }
}

- (void)recordTouchUpOutside {
    if (self.recordTouchUpOutsideAction) {
        self.recordTouchUpOutsideAction(self);
    }
}

- (void)recordTouchDragEnter {
    if (self.recordTouchDragEnterAction) {
        self.recordTouchDragEnterAction(self);
    }
}

- (void)recordTouchDragInside {
    if (self.recordTouchDragInsideAction) {
        self.recordTouchDragInsideAction(self);
    }
}

- (void)recordTouchDragOutside {
    if (self.recordTouchDragOutsideAction) {
        self.recordTouchDragOutsideAction(self);
    }
}

- (void)recordTouchDragExit {
    if (self.recordTouchDragExitAction) {
        self.recordTouchDragExitAction(self);
    }
}
@end
