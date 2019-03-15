//
//  BaseViewController.h
//  community
//
//  Created by 凤凰互联 on 2018/9/1.
//  Copyright © 2018年 dajiang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 所有控制器基类
 */
@interface BaseViewController : UIViewController

/**
 返回按钮（可以更改样式）
 */
@property(nonatomic, strong)UIButton * leftButton;

//提示框
- (void)showAlertControllerWithViewController:(BaseViewController *)VC Title:(NSString *)title message:(NSString *)message;
//只有文字没有菊花的提示框
- (void)showProgressHUDNoRotatingForString:(NSString *)progressString;
//无文字菊花
- (void)showProgressHUD;
//有时间的无文字菊花
- (void)showProgressHUDHiddenAfterDelay:(NSTimeInterval)delay;
//有时间的文字菊花
- (void)showProgressHUDHiddenAfterDelay:(NSTimeInterval)delay forString:(NSString *)progressString;
//有文字的菊花
- (void)showProgressHUDForString:(NSString *)progressString;
//隐藏菊花
- (void)hiddenProgressHUD;

@end
