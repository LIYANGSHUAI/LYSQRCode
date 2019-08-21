//
//  ViewController.m
//  LYSQRCodeDemo
//
//  Created by HENAN on 2019/7/19.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import "ViewController.h"
#import "LYSQRCodeView.h"
@interface ViewController ()<LYSQRCodeViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (nonatomic, strong) LYSQRCodeView *codeView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.codeView = [[LYSQRCodeView alloc] initWithFrame:self.view.bounds];
    self.codeView.delegate = self;
    [self.contentView addSubview:self.codeView];
    self.codeView.activeAreaRect = CGRectMake(CGRectGetWidth(self.view.bounds)/2.0-200/2.0, CGRectGetHeight(self.view.bounds)/2.0-200/2.0, 200, 200);
    [self.codeView initialization];
    [self.codeView startScan];
    
    self.borderView.layer.borderWidth = 1;
    self.borderView.layer.borderColor = [UIColor redColor].CGColor;
}

- (void)qrView:(LYSQRCodeView *)qrView didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects
{
    NSLog(@"%@",metadataObjects);
}

@end
