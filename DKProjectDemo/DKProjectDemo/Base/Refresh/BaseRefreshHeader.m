//
//  BaseRefreshHeader.m
//  ZLBProject
//
//  Created by 刘雨奇 on 2017/11/27.
//  Copyright © 2017年 刘雨奇. All rights reserved.
//

#import "BaseRefreshHeader.h"

@implementation BaseRefreshHeader

#pragma mark - 重写父类的方法
- (void)prepare{
    [super prepare];
    //所有的自定义东西都放在这里
//    [self setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
//    [self setTitle:@"释放刷新" forState:MJRefreshStatePulling];
//    [self setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
//    [self setTitle:@"即将刷新的状态" forState:MJRefreshStateWillRefresh];
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    //一些其他属性设置
    /*
     // 设置字体
     self.stateLabel.font = [UIFont systemFontOfSize:15];
     self.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
     
     // 设置颜色
     self.stateLabel.textColor = [UIColor redColor];
     self.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
     // 隐藏时间
     self.lastUpdatedTimeLabel.hidden = YES;
     // 隐藏状态
     self.stateLabel.hidden = YES;
     // 设置自动切换透明度(在导航栏下面自动隐藏)
     self.automaticallyChangeAlpha = YES;
     */
}

//如果需要自己重新布局子控件
- (void)placeSubviews{
    [super placeSubviews];
    
    //如果需要自己重新布局子控件，请在这里设置
    //箭头
    //    self.arrowView.center =
}

@end
