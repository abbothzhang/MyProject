//
//  UcmedViewStyle.m
//  上海长海医院
//
//  Created by 夏 科杰 on 13-8-8.
//  Copyright (c) 2013年 卓健科技. All rights reserved.
//  公共继承页面

#import "UcmedViewStyle.h"
#import "MobClick.h"

@implementation UcmedViewStyle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}
+ (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData   = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    //NSLog(@"%@",returnStr);
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

+ (UIImage *)CreateImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(UIImage* )scaleImage:(UIImage* )image
{
    CGFloat top = 30; // 顶端盖高度
    CGFloat bottom = 35 ; // 底端盖高度
    CGFloat left = 50; // 左端盖宽度
    CGFloat right = 50; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    return [[UIImage imageNamed:@"center_login_button.png"] resizableImageWithCapInsets:insets];
}


-(void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
//    self.view.backgroundColor=UIColorFromRGB(0xecf9fe);
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"++++++++++%@",NSStringFromClass(self.class));
    
    [MobClick beginLogPageView: NSStringFromClass(self.class)];
    [MobClick event:NSStringFromClass(self.class)];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"++++++++++%@",NSStringFromClass(self.class));
    [MobClick endLogPageView: NSStringFromClass(self.class)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor=UIColorFromRGB(0xf8f8f8);
    /******************************************/
    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 30, 30)];
    [btn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [btn setTitle:@"\ue626" forState:UIControlStateNormal];
    [btn setTitle:@"\ue626" forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btn]];
    /****************公用返回按钮****************/
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, 2.0);
    NSDictionary *dictText = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIColor whiteColor], UITextAttributeTextColor,
                              [UIFont systemFontOfSize:20],UITextAttributeFont,
                              [UIColor colorWithWhite:1.0f alpha:1.0f],UITextAttributeTextShadowColor, shadow,NSShadowAttributeName,nil] ;
//    [self.navigationController.navigationBar setTitleTextAttributes:dictText];

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
