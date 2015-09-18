//
//  UXActionSheet.m
//  SmartLeadingExamining
//
//  Created by 夏科杰 on 15/1/12.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "UXActionSheet.h"
#define LW 10
#define MAXLINE 4
#define LINEH 45
#define CH  45
#define UIColorFRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HIGHE [[UIScreen mainScreen] bounds].size.height
#define CCWIT(color) \
({\
CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);\
UIGraphicsBeginImageContext(rect.size);\
CGContextRef context = UIGraphicsGetCurrentContext();\
CGContextSetFillColorWithColor(context, [color CGColor]);\
CGContextFillRect(context, rect);\
UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();\
UIGraphicsEndImageContext();\
theImage;\
})\


@implementation UXActionSheet
@synthesize SheetDelegate;
- (id)initWithTitle:(NSString *)title
  cancelButtonTitle:(NSString *)cancelButtonTitle
               show:(ActionSheetBlock)ASBlock
             cancel:(ActionSheetCancel)Cancel
        selectArray:(NSArray *)array
  otherButtonTitles:(NSString *)item, ... NS_REQUIRES_NIL_TERMINATION;
{
    self = [self init];
    if (self) {
        SheetBlock=ASBlock;
        SheetCancel=Cancel;
        TitleName=cancelButtonTitle;
        id eachObject;
        va_list argumentList;
       
        if(array==nil){
             TitleArray=[[NSMutableArray alloc] init];
        if (item) // The first argument isn't part of the varargs list,
        {                                   // so we'll handle it separately.
            [TitleArray addObject: item];
            va_start(argumentList, item); // Start scanning for arguments after firstObject.
            while ((eachObject = va_arg(argumentList, id))) // As many times as we can get an argument of type "id"
                [TitleArray addObject: eachObject]; // that isn't nil, add it to self's contents.
            va_end(argumentList);
        }
        }else{
             TitleArray=[[NSMutableArray alloc] initWithArray:array];
        }
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.2];
        UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [self addGestureRecognizer:singleRecognizer];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([UIApplication sharedApplication].keyWindow);
            make.right.equalTo([UIApplication sharedApplication].keyWindow);
            make.top.equalTo([UIApplication sharedApplication].keyWindow);
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow);
        }];
        
        ActionView=[[UIView alloc] init];
        ActionView.backgroundColor=[UIColor whiteColor];
        [self addSubview:ActionView];
        [[ActionView layer] setMasksToBounds:YES];
        [[ActionView layer] setCornerRadius:10];
        [[ActionView layer] setBorderWidth:1];
        [[ActionView layer] setBorderColor:[[UIColor whiteColor] CGColor]];
        [ActionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(320-LW*2, ([TitleArray count]>MAXLINE?MAXLINE:[TitleArray count])*LINEH+LINEH+CH));
        }];

        UILabel *Labe=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320-LW*2, 45)];
        Labe.text=title;
        Labe.textColor=UIColorFRGB(0x8c8c8c);
        Labe.font=[UIFont systemFontOfSize:20];
        Labe.textAlignment=NSTextAlignmentCenter;
        Labe.backgroundColor=[UIColor clearColor];
        [ActionView addSubview:Labe];
        
        UIScrollView *ScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, 320-LW, ([TitleArray count]>MAXLINE?MAXLINE:[TitleArray count])*LINEH)];
        ScrollView.backgroundColor=[UIColor whiteColor];
        ScrollView.contentSize=CGSizeMake(0, [TitleArray count]*LINEH);
        [ActionView addSubview:ScrollView];
        
        UIImageView *lineImage=[[UIImageView alloc] initWithFrame:CGRectMake(0,45,320-LW, 1)];
        lineImage.backgroundColor=UIColorFRGB(0xbec6ca);
        [ActionView addSubview:lineImage];
        
        for (int i=0;i<[TitleArray count];i++) {
            
            UIButton *titleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            titleBtn.tag=i;
            titleBtn.frame=CGRectMake(0, (LINEH-1)*i, 320-LW, LINEH);
            [titleBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
            [titleBtn setTitle:[TitleArray objectAtIndex:i] forState:UIControlStateNormal];
            [titleBtn setTitleColor:UIColorFRGB(0x007aff) forState:UIControlStateNormal];
            [titleBtn setBackgroundImage:CCWIT(UIColorFRGB(0xffffff)) forState:UIControlStateNormal];
            [titleBtn setBackgroundImage:CCWIT(UIColorFRGB(0xaeaeae)) forState:UIControlStateHighlighted];
            [titleBtn addTarget:self action:@selector(selectIndex:) forControlEvents:UIControlEventTouchUpInside];
            [ScrollView addSubview:titleBtn];
            
            UIImageView *lineImage=[[UIImageView alloc] initWithFrame:CGRectMake(10,(LINEH-1)*i,320-LW-40,0.5)];
            lineImage.backgroundColor=i==0?UIColorFRGB(0xffffff):UIColorFRGB(0xbec6ca);
            [ScrollView addSubview:lineImage];
        }
        UIImageView *lineImage1=[[UIImageView alloc] initWithFrame:CGRectMake(0,45+ScrollView.frame.size.height,320-LW, 1)];
        lineImage1.backgroundColor=UIColorFRGB(0xbec6ca);
        [ActionView addSubview:lineImage1];
        
        UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.tag=[TitleArray count];
        cancelBtn.frame=CGRectMake(0, 45+ScrollView.frame.size.height+1, 320-LW, CH);
        [cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [cancelBtn setTitle:TitleName forState:UIControlStateNormal];
        [cancelBtn setTitle:TitleName forState:UIControlStateSelected];
        [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [cancelBtn setBackgroundImage:CCWIT([UIColor whiteColor]) forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:CCWIT(UIColorFRGB(0xaeaeae)) forState:UIControlStateSelected];
        [cancelBtn addTarget:self action:@selector(selectIndex:) forControlEvents:UIControlEventTouchUpInside];
        [ActionView addSubview:cancelBtn];
    }
    return self;
}

-(void)SingleTap
{
    SheetCancel();
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.hidden=YES;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)show:(ActionSheetBlock)ASBlock
     cancel:(ActionSheetCancel)Cancel;
{
    SheetBlock=ASBlock;
    SheetCancel=Cancel;
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo([UIApplication sharedApplication].keyWindow);
        //make.bottom.equalTo(View.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(320-LW*2, ([TitleArray count]>MAXLINE?MAXLINE:[TitleArray count])*LINEH+LINEH+CH));
    }];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
       
        self.hidden=NO;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)selectIndex:(UIButton *)sender
{
    
    if (sender.tag==[TitleArray count]) {
        [self SingleTap];
    }else
    {
        SheetBlock(sender.tag);
        [self SingleTap];
    }
}

@end
