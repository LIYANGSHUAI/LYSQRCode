//
//  LYSQRCodeView.m
//  LYSQRCodeDemo
//
//  Created by HENAN on 2019/8/20.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import "LYSQRCodeView.h"

@interface LYSQRCodeView ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@end

@implementation LYSQRCodeView

- (void)initialization
{
    // 初始化相机设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 初始化输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // 初始化输出流
    self.output = [[AVCaptureMetadataOutput alloc] init];
    
    // 设置代理，主线程刷新
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 初始化链接对象
    self.session = [[AVCaptureSession alloc] init];
    
    // 高质量采集率
    [self.session setSessionPreset:self.sessionPreset];
    if ([self.session canAddInput:input]) [self.session addInput:input];
    if ([self.session canAddOutput:self.output]) [self.session addOutput:self.output];
    
    // 设置扫描类型
    self.output.metadataObjectTypes = self.metadataObjectTypes;
    
    // 更新界面
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = self.bounds;
    [self.layer addSublayer:self.preview];
    
    // 设置活跃区域
    [self coverToMetadataOutputRectOfInterestForRect:self.activeAreaRect];
}

- (AVCaptureSessionPreset)sessionPreset
{
    if (!_sessionPreset) {
        _sessionPreset = AVCaptureSessionPresetHigh;
    }
    return _sessionPreset;
}

- (NSArray<AVMetadataObjectType> *)metadataObjectTypes
{
    if (!_metadataObjectTypes) {
        _metadataObjectTypes = [NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil];
    }
    return _metadataObjectTypes;
}

- (CGRect)activeAreaRect
{
    if (CGRectIsEmpty(_activeAreaRect)) {
        _activeAreaRect = self.bounds;
    }
    return _activeAreaRect;
}

- (void)startScan
{
    [self.session startRunning];
    if (self.delegate && [self.delegate respondsToSelector:@selector(qrViewDidStartScan:)]) {
        [self.delegate qrViewDidStartScan:self];
    }
}
- (void)coverToMetadataOutputRectOfInterestForRect:(CGRect)cropRect
{
    CGSize size = self.preview.bounds.size;
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 0.0;
    
    if ([_session.sessionPreset isEqualToString:AVCaptureSessionPreset1920x1080]) {
        p2 = 1920./1080.;
    }
    else if ([_session.sessionPreset isEqualToString:AVCaptureSessionPreset352x288]) {
        p2 = 352./288.;
    }
    else if ([_session.sessionPreset isEqualToString:AVCaptureSessionPreset1280x720]) {
        p2 = 1280./720.;
    }
    else if ([_session.sessionPreset isEqualToString:AVCaptureSessionPresetiFrame960x540]) {
        p2 = 960./540.;
    }
    else if ([_session.sessionPreset isEqualToString:AVCaptureSessionPresetiFrame1280x720]) {
        p2 = 1280./720.;
    }
    else if ([_session.sessionPreset isEqualToString:AVCaptureSessionPresetHigh]) {
        p2 = 1920./1080.;
    }
    else if ([_session.sessionPreset isEqualToString:AVCaptureSessionPresetMedium]) {
        p2 = 480./360.;
    }
    else if ([_session.sessionPreset isEqualToString:AVCaptureSessionPresetLow]) {
        p2 = 192./144.;
    }
    else if ([_session.sessionPreset isEqualToString:AVCaptureSessionPresetPhoto]) { // 暂时未查到具体分辨率，但是可以推导出分辨率的比例为4/3
        p2 = 4./3.;
    }
    else if ([_session.sessionPreset isEqualToString:AVCaptureSessionPresetInputPriority]) {
        p2 = 1920./1080.;
    }
    else if (@available(iOS 9.0, *)) {
        if ([_session.sessionPreset isEqualToString:AVCaptureSessionPreset3840x2160]) {
            p2 = 3840./2160.;
        }
    } else {
        
    }
    if ([self.preview.videoGravity isEqualToString:AVLayerVideoGravityResize]) {
        self.output.rectOfInterest = CGRectMake((cropRect.origin.y)/size.height,(size.width-(cropRect.size.width+cropRect.origin.x))/size.width, cropRect.size.height/size.height,cropRect.size.width/size.width);
    } else if ([self.preview.videoGravity isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
        if (p1 < p2) {
            CGFloat fixHeight = size.width * p2;
            CGFloat fixPadding = (fixHeight - size.height)/2;
            self.output.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                                    (size.width-(cropRect.size.width+cropRect.origin.x))/size.width,
                                                    cropRect.size.height/fixHeight,
                                                    cropRect.size.width/size.width);
        } else {
            CGFloat fixWidth = size.height * (1/p2);
            CGFloat fixPadding = (fixWidth - size.width)/2;
            self.output.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,             (size.width-(cropRect.size.width+cropRect.origin.x)+fixPadding)/fixWidth,
                                                    cropRect.size.height/size.height,
                                                    cropRect.size.width/fixWidth);
        }
    } else if ([self.preview.videoGravity isEqualToString:AVLayerVideoGravityResizeAspect]) {
        if (p1 > p2) {
            CGFloat fixHeight = size.width * p2;
            CGFloat fixPadding = (fixHeight - size.height)/2;
            self.output.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                                    (size.width-(cropRect.size.width+cropRect.origin.x))/size.width,
                                                    cropRect.size.height/fixHeight,
                                                    cropRect.size.width/size.width);
        } else {
            CGFloat fixWidth = size.height * (1/p2);
            CGFloat fixPadding = (fixWidth - size.width)/2;
            self.output.rectOfInterest = CGRectMake(cropRect.origin.y/size.height, (size.width-(cropRect.size.width+cropRect.origin.x)+fixPadding)/fixWidth,
                                                    cropRect.size.height/size.height,
                                                    cropRect.size.width/fixWidth);
        }
    }
}
- (void)stopScan
{
    [self.session stopRunning];
    if (self.delegate && [self.delegate respondsToSelector:@selector(qrViewDidStopScan:)]) {
        [self.delegate qrViewDidStopScan:self];
    }
}

- (void)openFlashlight
{
    if (![self.device hasTorch]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(notHaveFlashlight)]) {
            [self.delegate notHaveFlashlight];
        }
        return;
    }
    [self.device lockForConfiguration:nil];
    [self.device setTorchMode:AVCaptureTorchModeOn];
    [self.device unlockForConfiguration];
}

- (void)closeFlashlight
{
    if (![self.device hasTorch]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(notHaveFlashlight)]) {
            [self.delegate notHaveFlashlight];
        }
        return;
    }
    [self.device lockForConfiguration:nil];
    [self.device setTorchMode:AVCaptureTorchModeOff];
    [self.device unlockForConfiguration];
}

- (void)identificationCodeWithImg:(UIImage *)image callBack:(void(^)(NSString *message))callback
{
    //识别图片
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    //识别结果
    if (features.count > 0) {
        CIQRCodeFeature *frature = [features firstObject];
        if (callback) {
            callback(frature.messageString);
        }
    }else{
        if (callback) {
            callback(nil);
        }
    }
}

// AVCaptureMetadataOutputObjectsDelegate 代理方法
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(qrView:didOutputMetadataObjects:)]) {
        [self.delegate qrView:self didOutputMetadataObjects:metadataObjects];
    }
}
@end
