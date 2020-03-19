//
//  TMRecordButton.h
//  TMChatBarDemo
//
//  Created by Luther on 2019/5/8.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMRecordButton;

typedef void(^TMRecordTouchDown)                        (TMRecordButton *recordButton);
typedef void(^TMRecordTouchUpOutside)                   (TMRecordButton *recordButton);
typedef void(^TMRecordTouchUpInside)                    (TMRecordButton *recordButton);
typedef void(^TMRecordTouchDragEnter)                   (TMRecordButton *recordButton);
typedef void(^TMRecordTouchDragInside)                  (TMRecordButton *recordButton);
typedef void(^TMRecordTouchDragOutside)                 (TMRecordButton *recordButton);
typedef void(^TMRecordTouchDragExit)                    (TMRecordButton *recordButton);

@interface TMRecordButton : UIButton

@property (nonatomic, copy) TMRecordTouchDown               recordTouchDownAction;
@property (nonatomic, copy) TMRecordTouchUpOutside          recordTouchUpOutsideAction;
@property (nonatomic, copy) TMRecordTouchUpInside           recordTouchUpInsideAction;
@property (nonatomic, copy) TMRecordTouchDragEnter          recordTouchDragEnterAction;
@property (nonatomic, copy) TMRecordTouchDragInside         recordTouchDragInsideAction;
@property (nonatomic, copy) TMRecordTouchDragOutside        recordTouchDragOutsideAction;
@property (nonatomic, copy) TMRecordTouchDragExit           recordTouchDragExitAction;

/** 正在录制 */
- (void)setButtonStateRecording;
/** 默认状态 */
- (void)setButtonStateNormal;

@end
