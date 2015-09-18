//
//  D_EditAddressViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14/12/27.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "D_EditAddressViewController.h"

@interface D_EditAddressViewController ()

@end

@implementation D_EditAddressViewController
@synthesize InfoDict;

-(void)saveAct
{
    /*
     http://app.zipn.cn/app/receiver/save.jhtml
     参数名称	数据类型	是否必须	说明
     address	string	是	详细地址
     phone	string	是	收货人手机号码
     consignee	string	是	收货人姓名
     areaId	int	是	收货人所在地区
     isDefault	boolean	否	是否设为默认地址，默认为false
     zipCode	string	否	邮政编码
     */
    if ([[((UITextField *)[TextArray objectAtIndex:0]).text stringByReplacingOccurrencesOfString:@" " withString:@""] length]==0) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"姓名不能为空！" delegate:self cancelButtonTitle:NSLocalizedString(@"sure", nil) otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([[((UITextField *)[TextArray objectAtIndex:1]).text stringByReplacingOccurrencesOfString:@" " withString:@""] length]==0) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号不能为空！" delegate:self cancelButtonTitle:NSLocalizedString(@"sure", nil) otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([[((UITextField *)[TextArray objectAtIndex:2]).text stringByReplacingOccurrencesOfString:@" " withString:@""] length]==0) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"邮编不能为空！" delegate:self cancelButtonTitle:NSLocalizedString(@"sure", nil) otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
//    if ([SecondArray count]==0 || [[((UITextField *)[TextArray objectAtIndex:3]).text stringByReplacingOccurrencesOfString:@" " withString:@""] length]==0) {
//        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择地区！" delegate:self cancelButtonTitle:NSLocalizedString(@"sure", nil) otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
    if ([[((UITextField *)[TextArray objectAtIndex:4]).text stringByReplacingOccurrencesOfString:@" " withString:@""] length]==0) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"详细地址不能为空！" delegate:self cancelButtonTitle:NSLocalizedString(@"sure", nil) otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/receiver/update.jhtml"]];
    NSString *areaID = nil;
    if (SecondArray.count != 0 && ![[[SecondArray objectAtIndex:CityIndex] ObjectForKey:@"name"] isEqualToString:((UITextField *)[TextArray objectAtIndex:3]).text]) {
        areaID = [[SecondArray objectAtIndex:CityIndex] ObjectForKey:@"id"];

    }else{
        areaID = [InfoDict objectForKey:@"areaId"];

    }
    
    [NetRequest setASIPostDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                ((UITextField *)[TextArray objectAtIndex:0]).text,@"consignee",
                                ((UITextField *)[TextArray objectAtIndex:1]).text,@"phone",
                                ((UITextField *)[TextArray objectAtIndex:2]).text,@"zipCode",
                                areaID,@"areaId",
                                ((UITextField *)[TextArray objectAtIndex:4]).text,@"address",
                                @"",@"isDefault",
                                [InfoDict objectForKey:@"id"], @"id",
                                
                                nil]
                       ApiName:@""
                     CanCancel:YES
                   SetHttpType:HttpPost
                     SetNotice:NoticeType1
                    SetNetWork:NetWorkTypeAS
                    SetProcess:ProcessType1
                    SetEncrypt:Encryption
                      SetCache:Cache
                      NetBlock:^(NSDictionary *ReturnDict){
                          NSLog(@"%@",ReturnDict);
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAdd" object:@{[NSNumber numberWithInteger:self.tableviewIndex] : ReturnDict}];
                          [self.navigationController popViewControllerAnimated:YES];
                          
                      }
                      NetError:^(int error) {
                      }
     ];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    ProvinceIndex=0;
    CityIndex=0;
    TextArray=[[NSMutableArray alloc] init];
    UIButton *addBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(0, 0, 50, 50)];
    [addBtn setTitle:@"保存" forState:UIControlStateNormal];
    [addBtn setTitle:@"保存" forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(saveAct) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:addBtn]];
    
    SecondArray=[[NSMutableArray alloc] init];
    NSArray *array=[[NSArray alloc] initWithObjects:
                    @[@0,[InfoDict objectForKey:@"consignee"],@45],
                    @[@45,[InfoDict objectForKey:@"phone"],@45],
                    @[@45,[InfoDict objectForKey:@"zipCode"],@45],
                    @[@45,[InfoDict objectForKey:@"areaName"],@68],
                    @[@68,[InfoDict objectForKey:@"address"],@68],
                    nil];
    NSArray *lineArray=[[NSArray alloc] initWithObjects:
                        @0,
                        @45,
                        @45,
                        @45,
                        @68,
                        @68,
                        nil];
    
    ScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE-64)];
    ScrollView.backgroundColor=[UIColor clearColor];
    ScrollView.contentInset=UIEdgeInsetsMake(16, 0, 0, 0);
    ScrollView.contentSize=CGSizeMake(0, 600);
    [self.view addSubview:ScrollView];
    
    int h=0;
    for (int i=0; i<[array count]; i++) {
        int height=[[[array objectAtIndex:i] objectAtIndex:0] intValue];
        h+=height;
        switch (i) {
            case 3:
            {
                UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, h, SCREEN_WIDTH, [[[array objectAtIndex:i] objectAtIndex:2] intValue])];
                backView.backgroundColor=[UIColor whiteColor];
                [ScrollView addSubview:backView];
                
                UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                selectBtn.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, [[[array objectAtIndex:i] objectAtIndex:2] intValue]);
                [selectBtn addTarget:self action:@selector(selectAct) forControlEvents:UIControlEventTouchUpInside];
                [backView addSubview:selectBtn];
                
                CityLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH-20, [[[array objectAtIndex:i] objectAtIndex:2] intValue])];
                CityLabel.numberOfLines=2;
                CityLabel.text=[[array objectAtIndex:i] objectAtIndex:1];
                CityLabel.textColor=UIColorFromRGB(0x000000);
                CityLabel.backgroundColor=[UIColor clearColor];
                CityLabel.font=[UIFont systemFontOfSize:20];
                CityLabel.textAlignment=NSTextAlignmentLeft;
                [selectBtn addSubview:CityLabel];
                [TextArray addObject:CityLabel];
            }
                break;
            default:
            {
                UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, h, SCREEN_WIDTH, [[[array objectAtIndex:i] objectAtIndex:2] intValue])];
                backView.backgroundColor=[UIColor whiteColor];
                [ScrollView addSubview:backView];
                
                UITextField *TextField=[[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, [[[array objectAtIndex:i] objectAtIndex:2] intValue])];
                TextField.tag=i;
                TextField.delegate=self;
                TextField.text=[[array objectAtIndex:i] objectAtIndex:1];
                [backView addSubview:TextField];
                [TextArray addObject:TextField];
            }
                break;
        }
    }
    int hei=0;
    for (int j=0; j<[lineArray count]; j++) {
        int height=[[lineArray objectAtIndex:j] intValue];
        hei+=height;
        UIImageView *lineImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, hei, SCREEN_WIDTH, 0.5)];
        lineImage.backgroundColor=UIColorFromRGB(0xdddddd);
        [ScrollView addSubview:lineImage];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    PickerView.hidden=YES;
    ScrollView.contentOffset=CGPointMake(0, textField.tag*45);
}

-(void)selectAct
{
    [((UITextField *)[TextArray objectAtIndex:0]) resignFirstResponder];
    [((UITextField *)[TextArray objectAtIndex:1]) resignFirstResponder];
    [((UITextField *)[TextArray objectAtIndex:2]) resignFirstResponder];
    [((UITextField *)[TextArray objectAtIndex:4]) resignFirstResponder];
    if (PickerView==nil) {
        PickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HIGHE-64-150, SCREEN_WIDTH, 150)];
        PickerView.delegate=self;
        //    显示选中框
        PickerView.showsSelectionIndicator=YES;
        [self.view addSubview:PickerView];
    }
    PickerView.hidden=NO;;
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:@"http://app.zipn.cn/app/common/area.jhtml"]];
    [NetRequest setASIPostDict:nil
                       ApiName:@""
                     CanCancel:YES
                   SetHttpType:HttpGet
                     SetNotice:NoticeType1
                    SetNetWork:NetWorkTypeAS
                    SetProcess:ProcessType1
                    SetEncrypt:Encryption
                      SetCache:Cache
                      NetBlock:^(NSDictionary *ReturnDict){
                          NSLog(@"%@",ReturnDict);
                          ListArray=[[NSArray alloc] initWithArray:[ReturnDict ObjectForKey:@"data"]];;
                          [PickerView reloadAllComponents];
                      }
                      NetError:^(int error) {
                      }
     ];
}

//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==0)
    {
        
        return [ListArray count];
    }else
    {
        return [SecondArray count];
    }
    
}

#pragma mark Picker Delegate Methods

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0) {
        return [[ListArray ObjectAtIndex:row] ObjectForKey:@"name"];
    }else{
        return [[SecondArray ObjectAtIndex:row] ObjectForKey:@"name"];
    }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0) {
        ProvinceIndex=row;
        
        ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.zipn.cn/app/common/area.jhtml?id=%@",[[ListArray ObjectAtIndex:row] ObjectForKey:@"id"]]]];
        [NetRequest setASIPostDict:nil
                           ApiName:@""
                         CanCancel:YES
                       SetHttpType:HttpGet
                         SetNotice:NoticeType1
                        SetNetWork:NetWorkTypeAS
                        SetProcess:ProcessType1
                        SetEncrypt:Encryption
                          SetCache:Cache
                          NetBlock:^(NSDictionary *ReturnDict){
                              NSLog(@"%@",ReturnDict);
                              [SecondArray removeAllObjects];
                              [SecondArray addObjectsFromArray:[ReturnDict ObjectForKey:@"data"]];
                              [PickerView reloadAllComponents];
                              if ([ListArray count]>0&&[SecondArray count]>0) {
                                  CityLabel.text=[NSString stringWithFormat:@"%@  %@",[[ListArray objectAtIndex:ProvinceIndex] ObjectForKey:@"name"],[[SecondArray objectAtIndex:CityIndex] ObjectForKey:@"name"]];
                              }
                              
                              
                          }
                          NetError:^(int error) {
                          }
         ];
    }else{
        CityIndex=row;
        if ([ListArray count]>0&&[SecondArray count]>0)
            CityLabel.text=[NSString stringWithFormat:@"%@  %@",[[ListArray objectAtIndex:ProvinceIndex] ObjectForKey:@"name"],[[SecondArray objectAtIndex:CityIndex] ObjectForKey:@"name"]];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
