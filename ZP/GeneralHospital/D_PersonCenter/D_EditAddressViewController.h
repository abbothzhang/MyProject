//
//  D_EditAddressViewController.h
//  GeneralHospital
//
//  Created by 夏科杰 on 14/12/27.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface D_EditAddressViewController :  UcmedViewStyle<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    UIScrollView   *ScrollView;
    UIPickerView   *PickerView;
    NSArray        *ListArray;
    NSMutableArray *SecondArray;
    UILabel        *CityLabel;
    int            ProvinceIndex;
    int            CityIndex;
    NSMutableArray *TextArray;
}
@property(nonatomic,retain) NSDictionary *InfoDict;
@property(nonatomic, assign)NSInteger tableviewIndex;
@end
