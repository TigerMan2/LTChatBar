//
//  LTRecordButton.h
//  LTChatBarDemo
//
//  Created by Luther on 2019/5/8.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTRecordButton;

typedef void(^LTRecordTouchDown)                        (LTRecordButton *recordButton);
typedef void(^LTRecordTouchUpOutside)                   (LTRecordButton *recordButton);
typedef void(^LTRecordTouchUpInside)                    (LTRecordButton *recordButton);
typedef void(^LTRecordTouchDragEnter)                   (LTRecordButton *recordButton);
typedef void(^LTRecordTouchDragInside)                  (LTRecordButton *recordButton);
typedef void(^LTRecordTouchDragOutside)                 (LTRecordButton *recordButton);
typedef void(^LTRecordTouchDragExit)                    (LTRecordButton *recordButton);

@interface LTRecordButton : UIButton

@property (nonatomic, copy) LTRecordTouchDown               recordTouchDownAction;
@property (nonatomic, copy) LTRecordTouchUpOutside          recordTouchUpOutsideAction;
@property (nonatomic, copy) LTRecordTouchUpInside           recordTouchUpInsideAction;
@property (nonatomic, copy) LTRecordTouchDragEnter          recordTouchDragEnterAction;
@property (nonatomic, copy) LTRecordTouchDragInside         recordTouchDragInsideAction;
@property (nonatomic, copy) LTRecordTouchDragOutside        recordTouchDragOutsideAction;
@property (nonatomic, copy) LTRecordTouchDragExit           recordTouchDragExitAction;

/** 正在录制 */
- (void)setButtonStateRecording;
/** 默认状态 */
- (void)setButtonStateNormal;

@end
