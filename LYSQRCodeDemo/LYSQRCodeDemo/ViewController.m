//
//  ViewController.m
//  LYSQRCodeDemo
//
//  Created by HENAN on 2019/7/19.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import "ViewController.h"
#import "ScanViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    ScanViewController *vc = [[ScanViewController alloc] init];
    
    [self presentViewController:vc animated:YES completion:nil];
}

@end
