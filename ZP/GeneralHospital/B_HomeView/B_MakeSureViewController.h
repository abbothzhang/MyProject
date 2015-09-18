//
//  B_MakeSureViewController.h
//  GeneralHospital
//
//  Created by 夏科杰 on 15/1/4.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UXTextField.h"
@interface B_MakeSureViewController : UcmedViewStyle<UITextFieldDelegate,UIActionSheetDelegate>
{
 
    NSMutableDictionary *DetailDict;
    UIScrollView        *ScrollView;
    UILabel             *NameLabel;
    UILabel             *AddressLabel;
    UXTextField         *TextField;
    NSDictionary        *SellDict;
   
}


@end
