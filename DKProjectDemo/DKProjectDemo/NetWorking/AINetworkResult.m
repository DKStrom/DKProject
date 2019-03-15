//
//  AINetworkResult.m
//  EWoCartoon
//
//  Created by Crauson on 16/5/1.
//  Copyright © 2016年 Moguilay. All rights reserved.
//

#import "AINetworkResult.h"

@implementation AINetworkResult
{
}

+ (AINetworkResult *)createWithDic:(NSDictionary *)dic
{
    AINetworkResult* data = [[AINetworkResult alloc] init];
    [data setSourceDic:dic];
    return data;
}

//data对象
- (id)getDataObj
{
    if (_sourceDic != nil) {
        if ([[_sourceDic allKeys] containsObject:@"data"])
        {
            NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[_sourceDic objectForKey:@"data"]];
            return dict;
        }
        return _sourceDic;
    }
    return nil;
}

//data对象
- (id)getDataArray
{
    if (_sourceDic != nil) {
        if ([[_sourceDic allKeys] containsObject:@"data"])
        {
            NSArray *array = [NSArray arrayWithArray:[_sourceDic objectForKey:@"data"]];
            return array;
        }
        return nil;
    }
    return nil;
}

//result对象
- (id)getResultObj
{
    if (_sourceDic != nil) {
        if ([[_sourceDic allKeys] containsObject:@"result"]){
            return  [_sourceDic objectForKey:@"result"];
        }
        return _sourceDic;
    }
    return nil;
}

//result对象
- (id)getResultData
{
    if (_sourceDic != nil) {
        if ([[_sourceDic allKeys] containsObject:@"result"]){
            NSDictionary *dict = [_sourceDic objectForKey:@"result"];
            
            return [dict objectForKey:@"data"];
        }
        return _sourceDic;
    }
    return nil;
}

//result对象
- (id)getResultMessages
{
    if (_sourceDic != nil) {
        if ([[_sourceDic allKeys] containsObject:@"result"]){
            NSDictionary *dict = [_sourceDic objectForKey:@"result"];
            return [dict objectForKey:@"messages"];
        }
        return _sourceDic;
    }
    return nil;
}

- (NSString *)getResultPageIndex
{
    if (_sourceDic != nil) {
        if ([[_sourceDic allKeys] containsObject:@"result"]){
            return [[_sourceDic objectForKey:@"result"] objectForKey:@"pageIndex"];
        }
        return nil;
    }
    return nil;
}

// 获取网络请求状态码
- (int)getCode
{
    if (_sourceDic != nil) {
        id data = [_sourceDic objectForKey:@"code"];
        if(data)
        {
            return [data intValue];
        }
    }
    return 0;
}
// 获取网络请求提示信息
- (NSString *)getMessage
{
    if (_sourceDic != nil) {
        return [_sourceDic objectForKey:@"msg"];
    }
    return @"";
}


// 返回服务器处理是否成功
- (BOOL)isSucceed
{
    int code = [self getCode];
    
    if(code == 0)
    {
        NSLog(@"code是什么呢：%d",code);
        return YES;
    }else{
        return NO;
    }
}

-(id)getUserInfoResultObj{
    if (_sourceDic != nil) {
        if ([self isSucceed]) {
            return  [_sourceDic objectForKey:@"result"];

        }
        return nil;
    }
    return nil;
}


@end
