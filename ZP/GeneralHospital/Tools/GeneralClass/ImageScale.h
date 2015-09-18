//
//  ImageScale.h
//  掌握健康3.0
//
//  Created by 夏 科杰 on 13-8-30.
//  Copyright (c) 2013年 卓健科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIImage(Scale)
- (UIImage*)imageScaledSize:(CGSize)size;
- (UIImage*)imageScaledMiniSize:(CGSize)size;
+ (UIImage*)imageWithURL:(NSString *)strUrl;
+ (UIImage *)rotateImage:(UIImage *)aImage Type:(UIImageOrientation)type;
@end
