//
//  UXAlertView.h
//  浙一医护版
//
//  Created by 夏科杰 on 14-8-5.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^UXAlertBlock)(int);
@interface UXAlertView : UIAlertView
{
    UXAlertBlock AlertBlock;
}
-(void)ShowBlock:(UXAlertBlock)alertBlock;
@end
