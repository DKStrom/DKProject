//
//  AINetworkResult.h
//  EWoCartoon
//
//  Created by Crauson on 16/5/1.
//  Copyright © 2016年 Moguilay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AINetworkResult : NSObject

@property(nonatomic, strong)NSDictionary *sourceDic;

+ (AINetworkResult *)createWithDic:(NSDictionary *)dic;

//data
- (id)getDataObj;
//date数组
- (id)getDataArray;
//result数组
- (id)getResultObj;
//result中的data数组
- (id)getResultData;
//result中的messages数组
- (id)getResultMessages;
//PageIndex数据
- (NSString *)getResultPageIndex;
// 返回服务器处理是否成功
- (BOOL)isSucceed;
// 获取网络请求状态码
- (int)getCode;
// 获取网络请求提示信息
- (NSString *)getMessage;

@end
