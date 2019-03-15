//
//  UserInfoModel.h
//  community
//
//  Created by 大可 on 2018/9/4.
//  Copyright © 2018年 dajiang. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel : BaseModel

//获取的用户信息
@property NSString *userId;//用户Id
@property NSString *nickname;//用户名
@property NSString *phoneNum;//手机号
@property NSString *portraitUri;//头像地址
@property NSString *sex;//1-男，2-女
@property NSString *signature;//签名
@property NSString *province;//省份
@property NSString *city;//城市
@property NSString *region;//地区

//写入本地
-(void)writeToLocal;
//删除文件
+(void)deleteUserInfo;
//读取文件
+ (instancetype)readFromLocal;

@end
