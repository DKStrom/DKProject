//
//  BaseCommonTool.m
//  ZLBProject
//
//  Created by 刘雨奇 on 2017/8/12.
//  Copyright © 2017年 刘雨奇. All rights reserved.
//

#import "BaseCommonTool.h"
#import "GTMBase64.h"
#import "NSData+AES.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <ifaddrs.h>
#import <MJExtension/NSString+MJExtension.h>
#import <ImageIO/ImageIO.h>
//按时间获取视频的一帧图片
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>
#import <MediaPlayer/MediaPlayer.h>

static float G_uiWidthRate = .0f; // 获取屏幕宽度比例
static float G_uiFontRate = 0.f;  // 获取字体大小比例


@implementation BaseCommonTool

//NSUserDefaults本地存储
+ (void)saveOfUserDefaults:(id)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//NSUserDefaults本地取出
+ (id)fetchOfUserDefaultsForKey:(NSString *)key{
    
    id fetchValue = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    return fetchValue;
}
//NSUserDefaults本地删除
+ (void)deleteOfUserDefaultsForKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

//NSUserDefaults本地删除所有数据
+(void)deleteAllOfUserDefaults{
    NSString *appDomain = [[NSBundle mainBundle]bundleIdentifier];
    [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
}

//NSUserDefaults本地判断有没有Key
+ (BOOL)isOfUserDefaultsForKey:(NSString *)key{

    if ([[NSUserDefaults standardUserDefaults] valueForKey:key]) {
        return YES;
    }
    return NO;
}

#pragma mark - Plist本地存储
+(void)saveOfPlist:(NSArray *)array forPlistPath:(NSString *)plistPath{
    NSString *homeDir = NSHomeDirectory();
    NSLog(@"homeDir = %@",homeDir);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docDir = [paths objectAtIndex:0];
    NSString* path =  [docDir stringByAppendingPathComponent:plistPath];

    if ([array writeToFile:path atomically:YES]) {
        NSLog(@"成功");
    }else{
        NSLog(@"失败");
    }
}

#pragma mark - Plist本地取出
+(id)fetchOfPlistForKey:(NSString *)plistPath{
    NSString *homeDir = NSHomeDirectory();
    NSLog(@"homeDir = %@",homeDir);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docDir = [paths objectAtIndex:0];
    NSString* path =  [docDir stringByAppendingPathComponent:plistPath];
    NSMutableArray *dataArr = [[NSMutableArray alloc] initWithContentsOfFile:path];
    return dataArr;
}

#pragma mark - Plist本地删除
+(void)deleteOfPlistForKey:(NSString *)plistPath{
    NSFileManager *fileMger = [NSFileManager defaultManager];
    NSString *xiaoXiPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:plistPath];
//如果文件路径存在的话
    BOOL bRet = [fileMger fileExistsAtPath:xiaoXiPath];
    if (bRet) {
        NSError *err;
        [fileMger removeItemAtPath:xiaoXiPath error:&err];
    }
    
}



//#pragma mark - AES加密ECB模式
//+(NSString*)encryptAES128ECBData:(NSString*)string
//{
//    return [NSData AES128Encrypt:string key:Base64_Key];
//}

//#pragma mark - AES解密ECB模式
//+(NSString*)decryptAES128ECBData:(NSString*)string
//{
//    return [NSData AES128Decrypt:string key:Base64_Key];
//}
//
//#pragma mark - AES加密CBC模式
////将string转成带密码的string
//+(NSString*)encryptAES128CBCData:(NSString*)string
//{
//    //将nsstring转化为nsdata
//    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
//    //使用密码对nsdata进行加密
//    NSData *encryptedData = [data AES128EncryptWithKey:Base64_Key];
//    NSString *result = [[NSString alloc] initWithData:[encryptedData base64EncodedDataWithOptions:0]  encoding:NSUTF8StringEncoding];
//    return result;
//}
//#pragma mark - AES解密CBC模式
////将带密码的data转成string
//+(NSString*)decryptAES128CBCData:(NSData*)data
//{
//    //使用密码对data进行解密
//    NSData *decryData = [data AES128DecryptWithKey:Base64_Key];
//    //将解了密码的nsdata转化为nsstring
//    NSString *str = [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
//    return str;
//}


#pragma mark 验证邮箱 0succ 1fail
+(BOOL)isStandardMail:(NSString *) mail{
    
    if (mail == nil || [mail isEqualToString:@""]) {
        return FALSE;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:mail];
    
    
}

#pragma 验证手机号
+(BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11){
        return NO;
    }
    
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    /**
     25     * 大陆地区固话及小灵通
     26     * 区号：010,020,021,022,023,024,025,027,028,029
     27     * 号码：七位或八位
     28     */
    //  NSString * PHS = @"^(0[0-9]{2})\\d{8}$|^(0[0-9]{3}(\\d{7,8}))$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }else{
        return NO;
    }
    
}

//是否存在文件
+(BOOL)FileExistAtPath:(NSString*)_filePath
{
    
    NSString *filePath =  [NSHomeDirectory() stringByAppendingFormat:@"/Library/Private Documents/%@/%@.jpg",_filePath,_filePath];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ( [fileManager fileExistsAtPath:filePath]) {
        return  YES;
    }
    return NO;
}

//创建文件夹
+(BOOL)CreateDictionary:(NSString*)path
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil])
    {
        return  YES;
    }
    return  NO;
}
//移动文件夹

+(BOOL)MoveFileAtPath:(NSString*)path toPath:(NSString*)mPath{
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager moveItemAtPath:path toPath:mPath error:nil])
    {
        return  YES;
    }
    return  NO;
}
//删除文件夹
+(BOOL)DeleteDictionary:(NSString*)path
{
    
    
    NSString *filePath =  [NSHomeDirectory() stringByAppendingFormat:@"/Library/Private Documents/%@/%@.jpg",path,path];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager removeItemAtPath:filePath error:nil])
    {
        return  YES;
    }
    return  NO;
}

//核心函数  获得参数   获取URL中参数值得函数
+(NSString*)URLPaser:(NSString*)url andParaName:(NSString*)CS{
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",CS];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];
        return [tagValue stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
        
    }
    return @"";
}

#pragma -mark 数字转换成千万单位
+(NSString *)numToNumWithNum:(int)num{
    
    float nums = 0.0;
    NSString *returnStr = @"";
    if (num/10000) {
        nums = num/10000.0;
        returnStr = [NSString stringWithFormat:@"%.1f万",nums];
    }else{
        returnStr = [NSString stringWithFormat:@"%d",num];
    }
    
    return returnStr;
}


//获取当前时间戳（单位：毫秒）
+ (NSString*)getCurrentTimestamp{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a = [dat timeIntervalSince1970] * 1000;
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    return timeString;
    
}

#pragma -mark时间转换
+(NSString*)dateToNSString:(NSDate*)date
{
    
    NSTimeInterval late = [date timeIntervalSince1970]*1;
    
    NSString * timeString = nil;
    
    NSDate * dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    
    NSTimeInterval cha = now - late;
    if (cha/3600 < 1) {
        
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        int num= [timeString intValue];
        
        if (num <= 1) {
            
            timeString = [NSString stringWithFormat:@"刚刚"];
            
        }else{
            
            timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
            
        }
        
    }
    
    if (cha/3600 > 1 && cha/86400 < 1) {
        
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        timeString = [NSString stringWithFormat:@"%@小时前", timeString];
        
    }
    
    if (cha/86400 > 1)
        
    {
        
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        int num = [timeString intValue];
        
        if (num < 2) {
            
            timeString = [NSString stringWithFormat:@"昨天"];
            
        }else if(num == 2){
            
            timeString = [NSString stringWithFormat:@"前天"];
            
        }else if (num > 2 && num <7){
            
            timeString = [NSString stringWithFormat:@"%@天前", timeString];
            
        }
        //        else if (num >= 7 && num <= 10) {
        //
        //            timeString = [NSString stringWithFormat:@"1周前"];
        //
        //        }
        else if(num >= 7){
            
            timeString = [NSString stringWithFormat:@"%@天前", timeString];
            
        }
        
    }
    
    
    
    return timeString;
}

#pragma -mark NSDate转时间戳
+(NSString*)dateToNSStringFormt:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

#pragma -mark 时间戳转NSDate
+(NSDate *)stringToDateFormt:(NSString *)timeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *datestr = [dateFormatter dateFromString:dateStr];
    return datestr;
}

#pragma -mark 时间戳字符串转时间格式 yyyy年MM月dd日 HH时mm分
+(NSString *)stringToTimeStringFormt:(NSString *)timeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

#pragma -mark 时间戳字符串转时间格式 MM/dd HH:mm
+(NSString *)stringToPublishTimeStringFormt:(NSString *)timeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd HH:mm"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+(NSString *)timeOfDay:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return  strDate;
    
}

//字符串转时间戳 如：2017-4-10 17:15:10
+ (NSString *)getTimeStrWithString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]*1000];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}

#pragma 时间戳转成微信时间
+(NSString *)dateLonglongForString:(NSInteger)receivedTime{

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:receivedTime/1000];
    NSString *timeString = [[self stringFromDate:date] substringToIndex:10];
    NSString *temp = [self getyyyymmdd];
    NSString *nowDateString = [NSString stringWithFormat:@"%@-%@-%@",[temp substringToIndex:4],[temp substringWithRange:NSMakeRange(4, 2)],[temp substringWithRange:NSMakeRange(6, 2)]];
    
    if ([timeString isEqualToString:nowDateString]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSString *showtimeNew = [formatter stringFromDate:date];
        return [NSString stringWithFormat:@"%@",showtimeNew];
    }else{
        return [NSString stringWithFormat:@"%@",timeString];
    }
}

+(NSString *)getyyyymmdd{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyyMMdd";
    NSString *dayStr = [formatDay stringFromDate:now];
    return dayStr;
}

+(NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}


//判断字符是不是数字
+(BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//URL Encode
//+(NSString *)URLEncodedString:(NSString *)str
//{
//
//    NSString *encodedValue = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
//                                                                                                  (CFStringRef)str, nil,
//                                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
//    return encodedValue;
//}



// 16 进制转换 RGB

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

// json  解析成字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

// json  解析成数组
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return arr;
}

//数组和字典转字符串
+ (NSString *)stringWithJSONObject:(id)json{
    if (json == nil) {
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    if ([jsonStr length] && error == nil){
        return jsonStr;
    }else{
        return nil;
    }
}

//dateToNSStringMothAndDay   dateToNSStringDay
//转化时间成时间表示格式
+(NSString*)dateToNSStringMothAndDay:(long long)date{
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:date/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *strDate = [dateFormatter stringFromDate:d];
    return strDate;
    
}


//转化时间成时间表示格式
+(NSString*)dateToNSStringMothAndDayAndHMS:(long long)date{
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:date/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:d];
    return strDate;
    
    
}


//转化时间成时间表示格式
+(NSString*)dateToNSStringDay:(long long )date{
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:date/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *strDate = [dateFormatter stringFromDate:d];
    return strDate;
}


//转化时间成时间表示格式
+(NSString*)dateToNSStringYear:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

//转化时间成时间表示格式
+(NSString*)dateToNSStringTime:(NSDate*)date{
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}


//转化时间成时间表示格式
+(NSString*)dateStringToNSString:(NSString*)dateString{
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateString intValue]];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    NSDate *date1 = [NSDate dateFromString:dateString format:dateFormatter];
//    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
//    NSString *strDate = [dateFormatter stringFromDate:date];
    
//    NSString *str=@"1368082020";//时间戳
    
    NSTimeInterval time=[dateString doubleValue]/1000;//因为时差问题要加8小时 == 28800 sec
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSLog(@"date:%@",[detaildate description]);
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}



//判断是否为浮点形：

+(BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}


+(CGSize)computingLabelSizeWith:(NSString *)text andWidth:(CGFloat)width andHeight:(CGFloat)height andFont:(UIFont*)font{
    CGSize size=CGSizeMake(0, 0);
    if (!text  || [text isEqualToString:@""]) {
        
    }else{
        NSString *content = text;
        CGSize constraint = CGSizeMake(width, height);
        NSDictionary * attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:content
         attributes:attributes];
        CGRect rect = [attributedText boundingRectWithSize:constraint
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        
        size = rect.size;
    }
    return size;
    
    
}



+(float) getUIWidthRate
{
    if(G_uiWidthRate == .0f)
    {
        G_uiWidthRate = screenWidth/320.0f;
    }
    return G_uiWidthRate;
}

+(float) getUIFontRate
{
    if(G_uiFontRate == .0f)
    {
        G_uiFontRate = screenWidth/320.0f;
    }
    return G_uiFontRate;
}
//+(float)getStrWidth:(NSString*)str withFontSize:(float)size
//{
//    CGSize textMaxSize = CGSizeMake(screenWidth, MAXFLOAT);
//    CGSize textRealSize = [str sizeWithFont:[UIFont systemFontOfSize:size] maxSize:textMaxSize];
//    return textRealSize.width;
//}


+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

+(NetWorkStatus)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NetWorkStatus netStatus = NetWorkStatusIsUnknow;
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            switch (netType) {
                case 0:
                    netStatus = NetWorkStatusIsNot;
                    //无网模式
                    break;
                case 1:
                    netStatus = NetWorkStatusIs2G;
                    break;
                case 2:
                    netStatus = NetWorkStatusIs3G;
                    break;
                case 3:
                    netStatus = NetWorkStatusIs4G;
                    break;
                case 5:
                    netStatus = NetWorkStatusIsWIFI;
                    break;
                default:
                    netStatus = NetWorkStatusIsUnknow;
                    break;
            }
        }
    }
    //根据状态选择
    return netStatus;
}

+ (CGFloat)getViewHeight:(NSString *)content attribute:(NSDictionary *)attribute width:(CGFloat)width
{
    //    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
    CGSize size = [content boundingRectWithSize:CGSizeMake(width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.height;
}

+ (void)scheduledTimerWithTimeInterval:(NSTimeInterval)interval CompletionBlock:(void (^)(BaseCommonTool *tool))block
{
    if (@available(iOS 10.0, *)) {
        [NSTimer scheduledTimerWithTimeInterval:interval repeats:NO block:^(NSTimer * _Nonnull timer) {
            if (block) {
                BaseCommonTool *tool = [[BaseCommonTool alloc]init];
                block(tool);
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

/**
 *  计算单个文件大小
 */
+(long long)fileSizeAtPath:(NSString *)filePath{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize];
    }
    return 0;
}

/**
 *  计算整个目录大小
 */
+(float)folderSizeAtPath
{
    NSString *folderPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSFileManager * manager=[NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) {
        return 0 ;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [self fileSizeAtPath :fileAbsolutePath];
    }
    
    return folderSize/( 1024.0 * 1024.0 );
}

/**
 *  清理缓存
 */
+(void)cleanCache:(cleanCacheBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //文件路径
        NSString *directoryPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        
        NSArray *subpaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
        
        for (NSString *subPath in subpaths) {
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
        //返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    });
    
}


/// 特殊符号
+ (BOOL)specialSymbolsJudgment:(NSString *)string{
    //数学符号
    NSString *matSym = @"﹢﹣×÷±/=≌∽≦≧≒﹤﹥≈≡≠=≤≥<>≮≯∷∶∫∮∝∞∧∨∑∏∪∩∈∵∴⊥∥∠⌒⊙√∟⊿㏒㏑%‰⅟½⅓⅕⅙⅛⅔⅖⅚⅜¾⅗⅝⅞⅘≂≃≄≅≆≇≈≉≊≋≌≍≎≏≐≑≒≓≔≕≖≗≘≙≚≛≜≝≞≟≠≡≢≣≤≥≦≧≨≩⊰⊱⋛⋚∫∬∭∮∯∰∱∲∳%℅‰‱øØπ";
    
    //标点符号
    NSString *punSym = @"。，、＇：∶；?‘’“”〝〞ˆˇ﹕︰﹔﹖﹑·¨….¸;！´？！～—ˉ｜‖＂〃｀@﹫¡¿﹏﹋﹌︴々﹟#﹩$﹠&﹪%*﹡﹢﹦﹤‐￣¯―﹨ˆ˜﹍﹎+=<＿_-ˇ~﹉﹊（）〈〉‹›﹛﹜『』〖〗［］《》〔〕{}「」【】︵︷︿︹︽_﹁﹃︻︶︸﹀︺︾ˉ﹂﹄︼❝❞!():,'[]｛｝^・.·．•＃＾＊＋＝＼＜＞＆§⋯`－–／—|\"\\";
    
    //    //单位符号＊·
    //    NSString *unitSym = @"°′″＄￥〒￠￡％＠℃℉﹩﹪‰﹫㎡㏕㎜㎝㎞㏎m³㎎㎏㏄º○¤%$º¹²³";
    //
    //    //货币符号
    //    NSString *curSym = @"₽€£Ұ₴$₰¢₤¥₳₲₪₵元₣₱฿¤₡₮₭₩ރ円₢₥₫₦zł﷼₠₧₯₨Kčर₹ƒ₸￠";
    
    //制表符
    NSString *tabSym = @"─ ━│┃╌╍╎╏┄ ┅┆┇┈ ┉┊┋┌┍┎┏┐┑┒┓└ ┕┖┗ ┘┙┚┛├┝┞┟┠┡┢┣ ┤┥┦┧┨┩┪┫┬ ┭ ┮ ┯ ┰ ┱ ┲ ┳ ┴ ┵ ┶ ┷ ┸ ┹ ┺ ┻┼ ┽ ┾ ┿ ╀ ╁ ╂ ╃ ╄ ╅ ╆ ╇ ╈ ╉ ╊ ╋ ╪ ╫ ╬═║╒╓╔ ╕╖╗╘╙╚ ╛╜╝╞╟╠ ╡╢╣╤ ╥ ╦ ╧ ╨ ╩ ╳╔ ╗╝╚ ╬ ═ ╓ ╩ ┠ ┨┯ ┷┏ ┓┗ ┛┳ ⊥ ﹃ ﹄┌ ╮ ╭ ╯╰";
    
    NSString *judgment = [NSString stringWithFormat:@"%@%@%@",matSym,punSym,tabSym];
    
    
    //屏蔽特俗字符
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:judgment] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if(basicTest){
        if([string isEqualToString:@""]){
            return YES;
        }
        return NO;
    }
    
    return YES;
    
}


+ (CGSize)getImageSizeWithURL:(id)URL{
    NSURL * url = nil;
    if ([URL isKindOfClass:[NSURL class]]) {
        url = URL;
    }
    if ([URL isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:URL];
    }
    if (!URL) {
        return CGSizeZero;
    }
    CGImageSourceRef imageSourceRef =  CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0, height = 0;
    if (imageSourceRef) {
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        if (imageProperties != NULL) {
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
}

// 根据文字的内容，字体， 行高，返回文字的size
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize lineSpace:(CGFloat)lineH
{
    if (text == nil) {
        return CGSizeZero;
    }
    NSDictionary *dict = nil;
    if (lineH != 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = lineH;
        dict = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    }else
    {
        dict = @{NSFontAttributeName:font};
    }
    CGSize size = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

/**
 *  正则过滤表情
 */
+ (NSString *)disableEmoji:(NSString *)text
{
    if (!text.length) return text;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}


/**
 *  图片压缩到指定大小
 *  @param targetSize  目标图片的大小
 *  @param sourceImage 源图片
 *  @return 目标图片
 */
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

//按时间获取视频的一帧图片
// 获取视频第一帧
+ (UIImage*)getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:path];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    
    NSError *error = nil;
    CMTime time= CMTimeMakeWithSeconds(0.0, 600);
    CMTime actualTime;
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if(error){
        NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
        return nil;
    }
    CMTimeShow(actualTime);
    UIImage *image=[UIImage imageWithCGImage:cgImage];
    //保存到相册
    //UIImageWriteToSavedPhotosAlbum(image,nil, nil, nil);
    CGImageRelease(cgImage);
    
    return image;
}

+ (void)bounceAnimation:(CALayer*)layer{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.5;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2f, 1.2f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.1f, @0.4f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [layer addAnimation:popAnimation forKey:nil];
}

//判断是否为空
+ (BOOL)isNullOrNilWithObject:(id)object
{
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return NO;
}


+ (BOOL)isJumpToExternalAppWithURL:(NSURL *)URL{
    NSSet *validSchemes = [NSSet setWithArray:@[@"http", @"https"]];
    return ![validSchemes containsObject:URL.scheme];
}

+ (void)openScheme:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        //iOS 10 以后的方法
        [application openURL:URL options:@{}
           completionHandler:^(BOOL success) {
               NSLog(@"Open %@: %d",scheme,success);
           }];
    } else {
        //iOS 10 以前的方法
        BOOL success = [application openURL:URL];
        NSLog(@"Open %@: %d",scheme,success);
    }
}


#pragma mark 获取系统表情数组
+ (void)getSystemExpressionArray:(void(^)(NSArray *expressionAr))expression
{
    // EMOJI_CODE_TO_SYMBOL 是宏定义的转换函数 #define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);
    NSMutableArray *returnAr = [NSMutableArray new];
    // 使用同步操作，把所有的值获取后再返还数组。
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        for (int i = 0x1F600; i <= 0x1F64F; i++)
        {
            if (i < 0x1F641 || i > 0x1F644)
            {
                int number = EMOJI_CODE_TO_SYMBOL(i);
                NSString *epressionStr = [[NSString alloc] initWithBytes:&number length:sizeof(number) encoding:NSUTF8StringEncoding];
                [returnAr addObject:epressionStr];
            }
        }
    });
    //打印数组中的值
    for (int i = 0 ; i < returnAr.count; i ++)
    {
        NSLog(@"returnAr[%d]%@", i,returnAr[i]);
    }
    expression(returnAr);
}


@end
