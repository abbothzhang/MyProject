//
//  ImageUtil.m
//  CombinedNav
//
//  Created by albert on 14-9-11.
//  Copyright (c) 2014年 albert. All rights reserved.
//

#import "ImageUtil.h"

@implementation ImageUtil
+(UIImage*)scaleImg:(UIImage*)img toScale:(float)scale
{
    UIGraphicsBeginImageContext(CGSizeMake(img.size.width*scale, img.size.height*scale));
    [img drawInRect:CGRectMake(0, 0, img.size.width*scale, img.size.height*scale)];
    UIImage *scaledImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImg;
}

+(UIImage*)reSizeImg:(UIImage*)img toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *reSizeImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImg;
}

@end
