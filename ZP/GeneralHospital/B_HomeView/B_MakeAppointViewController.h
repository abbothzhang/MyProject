//
//  B_MakeAppointViewController.h
//  zhipin
//
//  Created by 夏科杰 on 15/3/1.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface B_MakeAppointViewController : UcmedViewStyle<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSDictionary *AppointDict;
    UIButton     *TimeBtn;
    UIButton     *PeopleBtn;
    UIScrollView *ScrollView;
    UITextField  *TextField;
    
    UIButton     *ManBtn;
    UIButton     *WomenBtn;
    UILabel      *PriceLabel;
    UILabel      *ScoreLabel;
    UITextField  *UserName;
    UITextField  *PhoneName;
    UIPickerView *SelectPicker;
    NSArray      *DateArray;
    NSArray      *TimeArray;
    long         DateIndex;
    __block long TimeIndex;
    __block long NumIndex;

}

@end
