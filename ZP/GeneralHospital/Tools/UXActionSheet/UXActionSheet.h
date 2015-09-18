//
//  UXActionSheet.h
//  SmartLeadingExamining
//
//  Created by 夏科杰 on 15/1/12.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@protocol UXActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

typedef void (^ActionSheetBlock)(long);
typedef void (^ActionSheetCancel)(void);

@interface UXActionSheet : UIView
{
    NSMutableArray    *TitleArray;
    NSString          *TitleName;
    UIView            *ActionView;
    ActionSheetBlock  SheetBlock;
    ActionSheetCancel SheetCancel;
}
@property(nonatomic,assign)id <UXActionSheetDelegate>SheetDelegate;
- (id)initWithTitle:(NSString *)title
  cancelButtonTitle:(NSString *)cancelButtonTitle
               show:(ActionSheetBlock)ASBlock
             cancel:(ActionSheetCancel)Cancel
        selectArray:(NSArray *)array
  otherButtonTitles:(NSString *)item, ... NS_REQUIRES_NIL_TERMINATION;

@end