//
//  B_LocationViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 15/1/29.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "B_LocationViewController.h"
#define H 45
@interface B_LocationViewController ()

@end

@implementation B_LocationViewController
@synthesize Location;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"当前城市:%@", self.cityName];
    CityDict=[[NSMutableDictionary alloc] init];
    ListArray=[[NSMutableArray alloc] init];
    TableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE-64)];
    TableView.backgroundColor=[UIColor clearColor];
    TableView.delegate=self;
    TableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TableView.dataSource=self;
    [self.view addSubview:TableView];
    NSLog(@"LAT-->  %.6f, lon ---   %.6f", Location.latitude,Location.longitude);
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://app.zipn.cn/app/common/city_list.jhtml?latitude=%lf&longitude=%lf",Location.latitude,Location.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [NetRequest setASIPostDict:nil
                       ApiName:@""
                     CanCancel:YES
                   SetHttpType:HttpGet
                     SetNotice:NoticeType1
                    SetNetWork:NetWorkTypeAS
                    SetProcess:ProcessType8
                    SetEncrypt:Encryption
                      SetCache:Cache
                      NetBlock:^(NSDictionary *ReturnDict){
                          NSLog(@"ret----------》    %@",ReturnDict);
                          NSString *cityName = [[ReturnDict objectForKey:@"data"] objectForKey:@"currentCityName"];
                          if (cityName) {
                              self.title=[NSString stringWithFormat:@"当前城市:%@",[[ReturnDict objectForKey:@"data"] objectForKey:@"currentCityName"]];

                          }
                          
                          
//                          [ListArray addObject:@[@"定位城市",@[[[ReturnDict objectForKey:@"data"] objectForKey:@"currentCityName"]]]];
                          
                          NSMutableArray *nameArray = [NSMutableArray array ];
                          NSMutableArray *codeArray = [NSMutableArray array ];
                          NSArray *ary = [[ReturnDict objectForKey:@"data"] objectForKey:@"openCityList"];
                          for (NSDictionary *dic in ary) {
                              NSString *cityName = [dic objectForKey:@"cityName"];
                              NSString *cityCode = [dic objectForKey:@"cityCode"];

                              [nameArray addObject:cityName];
                              [codeArray addObject:cityCode];
                          }
                          NSLog(@"BANE      %@", nameArray);
                          [ListArray addObject:@[@"开通城市", codeArray, nameArray]];
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [TableView reloadData];
                          });
                      }
                      NetError:^(int error) {
                      }
     ];
    
    // Do any additional setup after loading the view.
}

-(void)setLocationBlock:(LocationBlock)locationBlock
{
    LocationB=locationBlock;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [ListArray count];
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{

    return  [[[ListArray ObjectAtIndex:section] lastObject] count];
}

-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return H;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    viewHeader.backgroundColor = UIColorFromRGB(0xefefef);
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30-0.5, SCREEN_WIDTH, 0.5)];
    lineImage.backgroundColor=UIColorFromRGB(0xaaaaaa);
    [viewHeader addSubview:lineImage];
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 310, 20)];
    labTitle.text=[[ListArray ObjectAtIndex:section] firstObject];
    labTitle.backgroundColor = [UIColor clearColor];
    labTitle.font=[UIFont systemFontOfSize:13];
    labTitle.textColor = UIColorFromRGB(0x666666);
    [viewHeader addSubview:labTitle];
    return viewHeader;
}


-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSUInteger section =[indexPath section];
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];

    }
    for (id view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.backgroundColor=[UIColor clearColor];

    UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 0,SCREEN_WIDTH-20, H)];

    titleLabel.text=[[[ListArray ObjectAtIndex:section] lastObject] objectAtIndex:row];
    titleLabel.textColor=UIColorFromRGB(0x333333);
    titleLabel.numberOfLines=2;
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:titleLabel];
    
    UILabel* arrowLabel=[[UILabel alloc] initWithFrame:CGRectMake(290, 0,40, H)];
    arrowLabel.text=@"\ue629";
    [arrowLabel setFont:[UIFont fontWithName:@"icomoon" size:16]];
    arrowLabel.textColor=UIColorFromRGB(0x888888);
    arrowLabel.backgroundColor=[UIColor clearColor];
    arrowLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:arrowLabel];

    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, H-0.5, SCREEN_WIDTH-10, 0.5)];
    lineImage.backgroundColor=UIColorFromRGB(0xaaaaaa);
    [cell.contentView addSubview:lineImage];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择时listArray   %@",ListArray);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row=[indexPath row];
    
    NSString *string = [[[ListArray ObjectAtIndex:indexPath.section] lastObject] objectAtIndex:row];
    NSString *code = [[[ListArray objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCity" object:@{@"city" : string, @"code" : code}];
    [self.navigationController popViewControllerAnimated:YES];
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
