//
//  KSystemAuthorization.m
//  LTChatBarDemo
//
//  Created by Luther on 2019/4/26.
//  Copyright © 2019 mrstock. All rights reserved.
//

#import "KSystemAuthorization.h"

static KSystemAuthorization *_instance = nil;

@implementation KSystemAuthorization

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

/** 获取相机权限 */
- (BOOL)checkCameraAuthorization {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block BOOL isAuthorization = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined || authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        isAuthorization = NO;
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            isAuthorization = granted;
            dispatch_semaphore_signal(semaphore);
        }];
    } else {
        isAuthorization = YES;
        dispatch_semaphore_signal(semaphore);
    }
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return isAuthorization;
}

/** 获取语音权限 */
- (BOOL)checkAudioAuthorization {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block BOOL isAuthorization = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined || authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        isAuthorization = NO;
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            isAuthorization = granted;
            dispatch_semaphore_signal(semaphore);
        }];
    } else {
        isAuthorization = YES;
        dispatch_semaphore_signal(semaphore);
    }
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return isAuthorization;
}

/** 访问相册权限 */
- (BOOL)checkPhotoAlbumAuthorization {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block BOOL isAuthorization = NO;
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                //授权成功或者已授权
                isAuthorization = YES;
                dispatch_semaphore_signal(semaphore);
            } else {
                isAuthorization = NO;
                dispatch_semaphore_signal(semaphore);
                return ;
            }
        }];
    } else if (status == PHAuthorizationStatusDenied) {
        [self settingAuthorizationWithTitle:@"权限设置" message:@"录音需要访问你的麦克风权限" cancel:^(BOOL isCancel) {
            
        }];
        isAuthorization = NO;
        dispatch_semaphore_signal(semaphore);
    } else {
        isAuthorization = YES;
        dispatch_semaphore_signal(semaphore);
    }
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return isAuthorization;
}

/** 跳转到设置页面 */
- (void)requestSettingForAuth {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

/**
 权限设置
 
 @param title 提示标题
 @param message 提示内容
 @param block 回调
 */
- (void)settingAuthorizationWithTitle:(NSString *)title message:(NSString *)message cancel:(void (^)(BOOL))block
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        block(YES);
    }];
    UIAlertAction *setting = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block(NO);
        [self requestSettingForAuth];
        return;
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:setting];
    
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [viewController presentViewController:alertController animated:YES completion:nil];
}

@end
