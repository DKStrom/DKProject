//
//  BaseViewController.m
//  community
//
//  Created by 凤凰互联 on 2018/9/1.
//  Copyright © 2018年 dajiang. All rights reserved.
//

#import "BaseViewController.h"
//#import <Masonry.h>

//菊花
#import <MBProgressHUD.h>
//全局滑动
//#import "UINavigationController+FDFullscreenPopGesture.h"

#define kProgressHUDFont kP2FitSize(45)
#define kProgressHUDColor [UIColor clearColor]

@interface BaseViewController ()<UIGestureRecognizerDelegate>
@property(nonatomic, strong)MBProgressHUD *progressHUD;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    self.navigationItem.hidesBackButton = YES;
    
    if (@available(iOS 11.0, *)) {
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setImage:[UIImage imageNamed:@"backWhite"] forState:UIControlStateNormal];
    [self.leftButton setFrame:CGRectMake(0, 0, 80, 50)];
    self.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -70, 0, 0);
    [self.leftButton addTarget:self action:@selector(leftBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    barButtonItem.title = @"";
    self.navigationItem.leftBarButtonItem= barButtonItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
    
-(void)leftBarBtnClicked:(UIButton*)sedner{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //隐藏nav 自定义
    //只有在二级页面生效
    if ([self.navigationController.viewControllers count] >= 2) {
        [self.leftButton setHidden:NO];
    }else{
        [self.leftButton setHidden:YES];
    }
}


//提示框
- (void)showAlertControllerWithViewController:(BaseViewController *)VC Title:(NSString *)title message:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:[NSString stringWithFormat:@"%@",message] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    //弹出提示框；
    [VC presentViewController:alert animated:true completion:nil];
}

//只有文字没有菊花的提示框
- (void)showProgressHUDNoRotatingForString:(NSString *)progressString{
    _progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressHUD.mode = MBProgressHUDModeText;
    _progressHUD.label.text = progressString;
    _progressHUD.label.font = [UIFont italicSystemFontOfSize:kProgressHUDFont];
    _progressHUD.bezelView.color = kProgressHUDColor;
    DKWeakType(self);
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            DKStrongType(weakself);
            [strongSelf.progressHUD hideAnimated:YES afterDelay:1.0];
            [strongSelf.progressHUD removeFromSuperViewOnHide];
        });
    });
}

//HUD.mode = MBProgressHUDModeAnnularDeterminate;

//无文字菊花
- (void)showProgressHUD{
    _progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressHUD.bezelView.color = kProgressHUDColor;
}

//有时间的无文字菊花
- (void)showProgressHUDHiddenAfterDelay:(NSTimeInterval)delay{
    _progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressHUD.bezelView.color = kProgressHUDColor;
    DKWeakType(self);
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            DKStrongType(weakself);
            [strongSelf.progressHUD hideAnimated:YES afterDelay:delay];
            [strongSelf.progressHUD removeFromSuperViewOnHide];
        });
    });
}

//有时间的文字菊花
- (void)showProgressHUDHiddenAfterDelay:(NSTimeInterval)delay forString:(NSString *)progressString{
    _progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressHUD.label.text = progressString;
    _progressHUD.label.font = [UIFont italicSystemFontOfSize:kProgressHUDFont];
    _progressHUD.bezelView.color = kProgressHUDColor;
    DKWeakType(self);
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            DKStrongType(weakself);
            [strongSelf.progressHUD hideAnimated:YES afterDelay:delay];
            [strongSelf.progressHUD removeFromSuperViewOnHide];
        });
    });
}

//有文字的菊花
- (void)showProgressHUDForString:(NSString *)progressString{
    _progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressHUD.label.text = progressString;
    _progressHUD.label.font = [UIFont italicSystemFontOfSize:kProgressHUDFont];
    _progressHUD.bezelView.color = kProgressHUDColor;
}

//圆环菊花
- (void)showProgressHUDAnnularDeterminate:(NSString *)progressString{
    _progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressHUD.mode = MBProgressHUDModeAnnularDeterminate;
    _progressHUD.bezelView.color = [UIColor clearColor];
}

//隐藏菊花
- (void)hiddenProgressHUD{
    DKWeakType(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        DKStrongType(weakself);
        [strongSelf.progressHUD hideAnimated:YES];
        [strongSelf.progressHUD removeFromSuperViewOnHide];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
