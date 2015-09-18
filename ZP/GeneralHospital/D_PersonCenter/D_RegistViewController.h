//
//  D_RegistViewController.h
//  GeneralHospital
//
//  Created by 夏科杰 on 14/11/3.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "UcmedViewStyle.h"
#import "UXTextField.h"
@interface D_RegistViewController : UcmedViewStyle<UITextFieldDelegate,UIAlertViewDelegate>
{
    UIScrollView *ScrollView;
    UXTextField *PhoneNum;
    UXTextField *NumCode;
    UXTextField *Password;
    UIButton    *GetCode;
    UIButton    *RegistBtn;
    UXTextField *AreaCode;
}
@end
