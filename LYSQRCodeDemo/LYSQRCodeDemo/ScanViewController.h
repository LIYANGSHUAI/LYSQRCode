//
//  ScanViewController.h
//  H5Dev
//
//  Created by liyangshuai on 2018/4/13.
//  Copyright © 2018年 liyangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanViewController : UIViewController
@property(nonatomic, copy)void(^successCallback)(NSDictionary *result);
@end
