//
//  D_SignInViewController.h
//  zhipin
//
//  Created by kjx on 15/3/15.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface D_SignInViewController : UcmedViewStyle<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextViewDelegate>
{
    UITextView     *TextView;
    NSMutableArray *ListArray;
    NSMutableArray *ImageArray;
    UIView         *ImageView;
}
@property(nonatomic,strong)NSString *ShopId;

@end
