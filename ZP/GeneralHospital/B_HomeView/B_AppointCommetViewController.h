//
//  B_AppointCommetViewController.h
//  zhipin
//
//  Created by kjx on 15/3/30.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface B_AppointCommetViewController : UcmedViewStyle<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITableView         *TableView;
    NSMutableArray      *ListArray;
    NSDictionary        *CommentDict;
    UIButton            *ClickBtn;
    UITextView          *TextView;
    NSMutableArray      *ScoreArray;
    NSMutableArray      *ComArray;
    NSMutableArray      *ImageArray;
    NSMutableArray      *StatuArray;
    
    NSMutableDictionary *UploadDict;
    long                ShopScore;
    UIView              *StarView;
    NSMutableDictionary *ShopDict;
    UIButton            *ShopBtn;
}

@property(nonatomic,strong)NSDictionary *UseDict;
@end
