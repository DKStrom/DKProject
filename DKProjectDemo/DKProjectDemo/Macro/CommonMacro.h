//
//  MacroDefinition.h
//  TaxiProject
//
//  Created by 刘雨奇 on 2017/1/5.
//  Copyright © 2017年 刘雨奇. All rights reserved.
//

#ifndef CommonMacro_h
#define CommonMacro_h

#pragma 常用宏

//修复打印不全的问题
#ifdef DEBUG

#define DKLog( s, ... ) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] UTF8String] );
#else

#define DKLog( s, ... ) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] UTF8String] );

#endif


#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define mFont(fsize) [UIFont systemFontOfSize:fsize]
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromARGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:((float)((rgbValue & 0xFF000000) >> 24))/255.0].

#define THEMECOLOR ColorWithRGB(0xff542E)
#define BACKGROUDCOLOR ColorWithRGB(0xefeff4)

#define MainScreen [UIScreen mainScreen]

#define screenWidth  [UIScreen mainScreen].bounds.size.width
#define screenHeight  [UIScreen mainScreen].bounds.size.height

//布局 iphone 8 一倍
#define kFitSize(v) ((v)/375.0f*[[UIScreen mainScreen] bounds].size.width)
////布局 iphone 8 二倍
//#define k2FitSize(v) ((v)/750.0f*[[UIScreen mainScreen] bounds].size.width)
//布局 iphone 8p 二倍
#define kP2FitSize(v) ((v)/1242.0f*[[UIScreen mainScreen] bounds].size.width)

//判断NavBar高度
#define kNavBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height + 44)

//判断NavBar高度 ，不带状态栏(判断是不是iphone X)
#define kNavBarHeightNoStateBar 44

#define kTabBarHeight IS_iPhoneX ? 83 : 49
//STATUSBAR 高度
#define kSTATUSBAR_HEIGHT ([UIApplication sharedApplication].statusBarFrame.size.height)
//判断是不是iphone X
#define IS_iPhoneX ((kSTATUSBAR_HEIGHT == 44) ? YES : NO)
#define kIs_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//弱引用/强引用  可配对引用在外面用WeakSelf(self)，block用StrongSelf(self)  也可以单独引用在外面用WeakSelf(self) block里面用weakself
#define DKWeakType(type)  __weak typeof(type) weak##type = type
#define DKStrongType(type)  __strong __typeof(type) strongSelf = type

//weak 和 strong
//#if DEBUG
//#define rac_keywordify autoreleasepool {}
//#else
//#define rac_keywordify try {} @catch (...) {}
//#endif
//
//#define rac_weakify_(INDEX, CONTEXT, VAR) \
//CONTEXT __typeof__(VAR) metamacro_concat(VAR, _weak_) = (VAR);
//
//#define rac_strongify_(INDEX, VAR) \
//__strong __typeof__(VAR) VAR = metamacro_concat(VAR, _weak_);
//
//#define DKWeakify(...) \
//rac_keywordify \
//metamacro_foreach_cxt(rac_weakify_,, __weak, __VA_ARGS__)
//
//#define DKStrongify(...) \
//rac_keywordify \
//_Pragma("clang diagnostic push") \
//_Pragma("clang diagnostic ignored \"-Wshadow\"") \
//metamacro_foreach(rac_strongify_,, __VA_ARGS__) \
//_Pragma("clang diagnostic pop")


#define SYSTEM_VERSION_GRETER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

//属性转字符串
#define LMJKeyPath(obj, key) @(((void)obj.key, #key))

//RGB(三色)
#define UIColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
//RGB(十六进制)
#define ColorWithRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//RGB(十六进制)
#define ColorWithRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

//随机色
#define RANDOM_COLOR [UIColor colorWithHue: (arc4random() % 256 / 256.0) saturation:((arc4random()% 128 / 256.0 ) + 0.5) brightness:(( arc4random() % 128 / 256.0 ) + 0.5) alpha:1]

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24)



#endif /* MacroDefinition_h */





