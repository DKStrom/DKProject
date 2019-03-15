//
//  NSString+Extension.m
//  EWoCartoon
//
//  Created by Moguilay on 16/4/22.
//  Copyright © 2016年 Moguilay. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
