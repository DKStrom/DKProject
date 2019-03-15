//
//  UserInfoModel.m
//  community
//
//  Created by 大可 on 2018/9/4.
//  Copyright © 2018年 dajiang. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"userId" : @"id",
             @"phoneNum" : @"phone"
             };
}

//写入本地
-(void)writeToLocal{
    NSData *data = [self yy_modelToJSONData];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"%@",path);
    NSString *Json_path=[path stringByAppendingPathComponent:@"UserInfoModelFile.json"];
    //写入文件
    NSLog(@"%@",[data writeToFile:Json_path atomically:YES] ? @"Succeed":@"Failed");
}

//读取文件
+ (instancetype)readFromLocal{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *Json_path=[path stringByAppendingPathComponent:@"UserInfoModelFile.json"];
    //==Json数据
    NSData *data=[NSData dataWithContentsOfFile:Json_path];
    UserInfoModel *model = [UserInfoModel yy_modelWithJSON:data];
    return model;
}

// 删除userInfo文件
+(void)deleteUserInfo
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *Json_path=[path stringByAppendingPathComponent:@"UserInfoModelFile.json"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:Json_path error:nil];
}


@end
