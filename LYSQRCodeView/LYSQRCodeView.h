//
//  LYSQRCodeView.h
//  LYSQRCodeDemo
//
//  Created by HENAN on 2019/8/20.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LYSQRCodeView;

@protocol LYSQRCodeViewDelegate <NSObject>

@required
- (void)qrView:(LYSQRCodeView *)qrView didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects;

@optional
- (void)qrViewDidStartScan:(LYSQRCodeView *)qrView;
- (void)qrViewDidStopScan:(LYSQRCodeView *)qrView;
- (void)notHaveFlashlight;
@end

@interface LYSQRCodeView : UIView

// 代理
@property (nonatomic, assign) id<LYSQRCodeViewDelegate> delegate;

/**
 扫描识别类型
 
 默认是
 AVMetadataObjectTypeEAN13Code,
 AVMetadataObjectTypeEAN8Code,
 AVMetadataObjectTypeCode128Code, // 条形码
 AVMetadataObjectTypeQRCode       // 二维码
 */
@property (nonatomic, copy, null_resettable) NSArray<AVMetadataObjectType> *metadataObjectTypes;

// 活跃区域,区域内可检测二维码,区域外不可检测,默认LYSQRCodeView的bounds作为活跃区域
@property (nonatomic, assign) CGRect activeAreaRect;

// 默认AVCaptureSessionPresetHigh
@property(nonatomic, copy) AVCaptureSessionPreset sessionPreset;

// 初始化核心组件
- (void)initialization;

// 开始扫描
- (void)startScan;
// 停止扫描
- (void)stopScan;

// 识别图片中二维码
- (void)identificationCodeWithImg:(UIImage *)image callBack:(void(^)(NSString *message))callback;

// 开启闪光灯
- (void)openFlashlight;
// 关闭闪光灯
- (void)closeFlashlight;

@end

NS_ASSUME_NONNULL_END
