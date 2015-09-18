//
//  UcmedViewStyle.h
//  上海长海医院
//
//  Created by 夏 科杰 on 13-8-8.
//  Copyright (c) 2013年 卓健科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UcmedViewStyle : UIViewController
+ (UIImage *) CreateImageWithColor: (UIColor *) color;
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
@end
