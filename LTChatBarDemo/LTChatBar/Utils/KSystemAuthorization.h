//
//  KSystemAuthorization.h
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/26.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface KSystemAuthorization : NSObject

+ (instancetype)shareInstance;

/** 获取相机权限 */
- (BOOL)checkCameraAuthorization;

/** 获取语音权限 */
- (BOOL)checkAudioAuthorization;

/** 访问相册权限 */
- (BOOL)checkPhotoAlbumAuthorization;

- (void)settingAuthorizationWithTitle:(NSString *)title message:(NSString *)message cancel:(void (^)(BOOL))block;

@end
