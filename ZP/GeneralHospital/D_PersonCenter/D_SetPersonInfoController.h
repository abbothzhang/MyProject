//
//  D_SetPersonInfoController.h
//  GeneralHospital
//
//  Created by 夏科杰 on 14/12/21.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SPersonInfo)(UIImage *);
typedef void(^SPersonString)(NSString *);
typedef void(^SPersonDes)(NSString *);
typedef void(^SPersonSex)(NSString *);
@interface D_SetPersonInfoController : UcmedViewStyle<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UIImageView    *HeadImage;
    SPersonInfo    PersonInfo;
    SPersonString  PersonString;
    SPersonDes     PersonDes;
    SPersonSex     PersonSex;
    NSArray        *LineArray;
    NSMutableArray *LabelArray;
}
@property(nonatomic,retain)NSMutableDictionary *ReturnDict;
@property(nonatomic,retain)UIImage             *UseImage;
-(void)setPersonInfo:(SPersonInfo)personInfo;
-(void)setPersonString:(SPersonString)personString;
-(void)setPersonDes:(SPersonDes)personDes;
-(void)setPersonSex:(SPersonDes)personSex;
@end
