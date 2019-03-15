//
//  NSString+Extension.h
//  EWoCartoon
//
//  Created by Moguilay on 16/4/22.
//  Copyright © 2016年 Moguilay. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)
/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
@end
