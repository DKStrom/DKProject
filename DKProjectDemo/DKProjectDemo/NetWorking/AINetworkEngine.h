//
//  AINetworkEngine.h
//  EWoCartoon
//
//  Created by Crauson on 16/5/1.
//  Copyright © 2016年 Moguilay. All rights reserved.
//

#import "AFNetworking.h"
#import "AINetworkResult.h"

@interface AINetworkEngine : AFHTTPSessionManager

+ (AINetworkEngine *)sharedClient;
+ (AINetworkEngine *)sharedClientWithoutBaseURL;

- (id)initWithBaseURL:(NSURL *)url;

/**
 *  @brief        【get】方式获取网络信息
 *  @parameters   path:路径  eg：rest/hairstyle/detail
 *                parems:参数，用字典保存，注意参数的顺序
 *  @       请求完成后，数据返回在块内（成功后的数据字典或者错误）
 */
- (void)getWithApi:(NSString *)api parameters:(NSDictionary *)params CompletionBlock:(void (^)(AINetworkResult *result, NSError *error))block;

/**
 *  @brief        【post】方式获取网络信息
 *  @parameters   path:    路径  eg：rest/hairstyle/detail
 *                parems:  参数，用字典保存，注意参数的顺序(不包括文件格式的)
 *  @       请求完成后，数据返回在块内（成功后的数据字典或者错误）
 */
- (void)postWithApi:(NSString *)api parameters:(NSDictionary *)params CompletionBlock:(void (^)(AINetworkResult *result, NSError *error))block;

/**
 *  @brief        【post】方式获取网络信息(加header数据)
 *  @parameters   path:    路径  eg：rest/hairstyle/detail
 *                parems:  参数，用字典保存，注意参数的顺序(不包括文件格式的)
*                parems:  参数，用字典保存，注意参数的顺序(不包括文件格式的)
 *  @       请求完成后，数据返回在块内（成功后的数据字典或者错误）
 */
- (void)postWithApi:(NSString *)api headerAndParameters:(NSDictionary *)params CompletionBlock:(void (^)(AINetworkResult *result, NSError *error))block;

/**
 *  @brief        【post】方式上传图片
 *  @parameters   path:    路径  eg：rest/hairstyle/detail
 *                parems:  参数，用字典保存，注意参数的顺序(不包括文件格式的)
 *  @       请求完成后，数据返回在块内（成功后的数据字典或者错误）
 */
- (void)postImagesWithApi:(NSString *)api parameters:(NSDictionary *)params images:(NSArray *)array CompletionBlock:(void (^)(AINetworkResult *result, NSError *error))block;

/**
 *  @brief        【post】方式上传动态图片（缩略图）
 *  @parameters   path:    路径  eg：rest/hairstyle/detail
 *                parems:  参数，用字典保存，注意参数的顺序(不包括文件格式的)
 *  @       请求完成后，数据返回在块内（成功后的数据字典或者错误）
 */
- (void)postDynamicsImagesWithApi:(NSString *)api parameters:(NSDictionary *)params images:(NSArray *)array CompletionBlock:(void (^)(AINetworkResult *result, NSError *error))block;


/**
 *  @brief        【post】方式上传视频
 *  @parameters   path:    路径  eg：rest/hairstyle/detail
 *                parems:  参数，用字典保存，注意参数的顺序(不包括文件格式的)
 *  @       请求完成后，数据返回在块内（成功后的数据字典或者错误）
 */
- (void)postVideoWithApi:(NSString *)api parameters:(NSDictionary *)params CompletionBlock:(void (^)(AINetworkResult *result, NSError *error))block;


/**
 *  @brief        下载文件
 *  @parameters   severPath:    服务端路径  eg：rest/images/1.png
 *                parems:  参数，用字典保存，注意参数的顺序(不包括文件格式的)
 *  @       请求完成后，数据返回在块内（成功后的数据字典或者错误）
 */
//-(void)downLoadFile:(NSString *)severPath
//      andOutPutpath:(NSString *)localPath
//    CompletionBlock:(void (^)(NSDictionary *posts, NSError *error))block;


@end
