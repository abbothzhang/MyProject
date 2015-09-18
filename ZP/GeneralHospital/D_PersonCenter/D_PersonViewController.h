//
//  D_PersonCenterViewController.h
//  至品购物
//
//  Created by 夏科杰 on 14-9-6.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface D_PersonViewController : UIViewController<UIGestureRecognizerDelegate , UINavigationControllerDelegate>
{
  
    UIImageView         *HeadImage;
    UILabel             *NameLabel;
    UILabel             *MoodLabel;
    UILabel             *SLabel;
}
@end
