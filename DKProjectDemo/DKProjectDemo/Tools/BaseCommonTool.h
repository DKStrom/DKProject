//
//  BaseCommonTool.h
//  ZLBProject
//
//  Created by 刘雨奇 on 2017/8/12.
//  Copyright © 2017年 刘雨奇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NetWorkStatus) {
    NetWorkStatusIsNot = 0,
    NetWorkStatusIs2G,
    NetWorkStatusIs3G,
    NetWorkStatusIs4G,
    NetWorkStatusIsWIFI,
    NetWorkStatusIsUnknow
};

typedef void(^cleanCacheBlock)(void);

@interface BaseCommonTool : NSObject

#pragma mark - NSUserDefaults本地存储
+ (void)saveOfUserDefaults:(id)value forKey:(NSString *)key;
#pragma mark - NSUserDefaults本地取出
+ (id)fetchOfUserDefaultsForKey:(NSString *)key;
#pragma mark - NSUserDefaults本地删除
+ (void)deleteOfUserDefaultsForKey:(NSString *)key;
#pragma mark - NSUserDefaults本地删除所有数据
+ (void)deleteAllOfUserDefaults;
#pragma mark - NSUserDefaults本地判断有没有Key
+ (BOOL)isOfUserDefaultsForKey:(NSString *)key;

#pragma mark - Plist本地存储
+(void)saveOfPlist:(NSArray *)array forPlistPath:(NSString *)plistPath;
#pragma mark - Plist本地取出
+(id)fetchOfPlistForKey:(NSString *)plistPath;
#pragma mark - Plist本地删除
+(void)deleteOfPlistForKey:(NSString *)plistPath;
//#pragma mark - AES128加密(ECB模式)
//+(NSString*)encryptAES128ECBData:(NSString*)string;
//#pragma mark - AES128解密(ECB模式)
//+(NSString*)decryptAES128ECBData:(NSString*)string;
//#pragma mark - AES128加密(CBC模式)
//+(NSString*)encryptAES128CBCData:(NSString*)string;
//#pragma mark - AES128解密(CBC模式)
//+(NSString*)decryptAES128CBCData:(NSData*)data;

#pragma 验证手机号
+(BOOL)isMobileNumber:(NSString *)mobileNum;
#pragma mark 验证邮箱 0succ 1fail
+(BOOL)isStandardMail:(NSString *) mail;

#pragma mark NSTimer封装
+ (void)scheduledTimerWithTimeInterval:(NSTimeInterval)interval CompletionBlock:(void (^)(BaseCommonTool *tool))block;

#pragma mark 清理缓存
+(void)cleanCache:(cleanCacheBlock)block;
#pragma mark 整个缓存目录的大小
+(float)folderSizeAtPath;
/**
 *  计算单个文件大小
 */
+(long long)fileSizeAtPath:(NSString *)filePath;
#pragma mark 特殊符号
+ (BOOL)specialSymbolsJudgment:(NSString *)string;

#pragma mark 根据URL获取图片大小
+ (CGSize)getImageSizeWithURL:(id)URL;

#pragma mark 根据文字的内容，字体， 行高，返回文字的size
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize lineSpace:(CGFloat)lineH;

+(CGSize)computingLabelSizeWith:(NSString *)text andWidth:(CGFloat)width andHeight:(CGFloat)height andFont:(UIFont*)font;

#pragma mark 正则过滤表情
+ (NSString *)disableEmoji:(NSString *)text;

#pragma mark 转化时间成时间表示格式年月日
+(NSString*)dateStringToNSString:(NSString*)dateString;

#pragma mark 压缩图片到指定尺寸大小
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage;

#pragma mark 获取视频的第一帧图片
+ (UIImage*)getVideoPreViewImage:(NSURL *)path;

#pragma -mark 获取当前时间戳
+ (NSString*)getCurrentTimestamp;

//数组和字典转字符串
+ (NSString *)stringWithJSONObject:(id)json;
// json  解析成数组
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString;
// json  解析成字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

#pragma -mark 时间戳转NSDate
+(NSDate *)stringToDateFormt:(NSString *)timeStamp;

#pragma -mark 时间戳字符串转时间格式 yyyy年MM月dd日 HH时mm分
+(NSString *)stringToTimeStringFormt:(NSString *)timeStamp;

#pragma -mark 时间戳字符串转时间格式 MM/dd HH:mm
+(NSString *)stringToPublishTimeStringFormt:(NSString *)timeStamp;

#pragma -mark 时间戳转成微信时间
+(NSString *)dateLonglongForString:(NSInteger)receivedTime;

//字符串转时间戳 如：2017-4-10 17:15:10
+ (NSString *)getTimeStrWithString:(NSString *)str;
#pragma -mark 动画效果
+ (void)bounceAnimation:(CALayer*)layer;


/**
 判断对象是否为空

 @param object (nil、NSNil、@""、@0 以上4种返回YES)
 @return YES 为空  NO 为实例对象
 */
+ (BOOL)isNullOrNilWithObject:(id)object;

/**
 url是否是跳转APP类型的

 @param URL 链接字符串
 @return BOOL值结果
 */
+ (BOOL)isJumpToExternalAppWithURL:(NSURL *)URL;

/**
 app跳转链接

 @param scheme 链接字符串
 */
+ (void)openScheme:(NSString *)scheme;

/**
 获取系统表情数组

 @param expression 系统表情数组
 */
+ (void)getSystemExpressionArray:(void(^)(NSArray *expressionAr))expression;

@end
