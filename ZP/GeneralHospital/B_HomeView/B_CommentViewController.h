//
//  B_CommentViewController.h
//  GeneralHospital
//
//  Created by 夏科杰 on 15/1/29.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface B_CommentViewController : UcmedViewStyle<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITableView         *TableView;
    NSMutableArray      *ListArray;
    NSDictionary        *CommentDict;
    UIButton            *ClickBtn;
    
    NSMutableArray      *ScoreArray;
    NSMutableArray      *ComArray;
    NSMutableArray      *ImageArray;
    NSMutableArray      *StatuArray;
    
    NSMutableDictionary *UploadDict;
    
}
@property(nonatomic,strong)NSDictionary *UseDict;
@end
