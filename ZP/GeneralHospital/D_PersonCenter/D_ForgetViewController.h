//
//  D_ForgetViewController.h
//  GeneralHospital
//
//  Created by 夏科杰 on 14/11/18.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "UcmedViewStyle.h"
#import "UXTextField.h"
@interface D_ForgetViewController : UcmedViewStyle<UITextFieldDelegate,UIAlertViewDelegate>
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
