//
//  D_LeaveMessageViewController.m
//  zhipin
//
//  Created by kjx on 15/3/15.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "D_LeaveMessageViewController.h"
#import "D_SignInViewController.h"
#import "UIButton+WebCache.h"
#define HHW 3
@interface D_LeaveMessageViewController ()

@end

@implementation D_LeaveMessageViewController

@synthesize ShopId;
-(void)SignInAct
{
    D_SignInViewController *D_SignIn=[[D_SignInViewController alloc] init];
    D_SignIn.ShopId=ShopId;
    [self.navigationController pushViewController:D_SignIn animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self request];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"留言墙";

    ListArray=[[NSMutableArray alloc] init];
    UIButton *SignInBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [SignInBtn setFrame:CGRectMake(0, 0, 50, 50)];
    [SignInBtn setTitle:@"签到" forState:UIControlStateNormal];
    [SignInBtn setTitle:@"签到" forState:UIControlStateHighlighted];
    [SignInBtn addTarget:self action:@selector(SignInAct) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:SignInBtn]];
    
    TableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE-64)];
    TableView.backgroundColor=[UIColor clearColor];
    TableView.delegate=self;
    TableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TableView.dataSource=self;
    [self.view addSubview:TableView];
    
    ShowView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE)];
    ShowView.hidden=YES;
    ShowView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:ShowView];
    
    ShowImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    ShowImage.center=ShowView.center;
    [ShowView addSubview:ShowImage];
    UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAct:)];
    tapGestureRecognizer.numberOfTapsRequired=1;
    tapGestureRecognizer.numberOfTouchesRequired=1;
    [ShowView addGestureRecognizer:tapGestureRecognizer];
    
}

-(void)request
{
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.zipn.cn/app/sign/shop/list.jhtml?shopId=%@&page=1",ShopId]]];
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
                          [ListArray removeAllObjects];
                          [ListArray addObjectsFromArray:[ReturnDict objectForKey:@"data"]];
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [TableView reloadData];
                          });
                      }
                      NetError:^(int error) {
                      }
     ];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    float height = [self heightForString:[[ListArray ObjectAtIndex:row] ObjectForKey:@"content"] fontSize:13.0 andWidth:SCREEN_WIDTH-20];
    NSArray *imageArray=[[[ListArray ObjectAtIndex:row] ObjectForKey:@"imageList"] copy];
    long line=([imageArray count]/3+([imageArray count]%3>0?1:0));
    return 65+HHW+height+line*103+10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ListArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifier%ld",(long)[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    for (id view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.backgroundColor=[UIColor clearColor];
    
    float height = [self heightForString:[[ListArray ObjectAtIndex:row] ObjectForKey:@"content"] fontSize:13.0 andWidth:SCREEN_WIDTH-20]+2;
    float iHeight=65+height+HHW;
    NSArray *imageArray=[[[ListArray ObjectAtIndex:row] ObjectForKey:@"imageList"] copy];
    NSLog(@"height======%f",height);
    long line=([imageArray count]/3+([imageArray count]%3>0?1:0));
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 55+HHW+height+line*103+10)];
    backView.backgroundColor=[UIColor whiteColor];
    [cell.contentView addSubview:backView];
    
    UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 35, 35)];
    [iconImage sd_setImageWithURL:[NSURL URLWithString:[[ListArray ObjectAtIndex:row] ObjectForKey:@"headImage" ]]];
    [cell.contentView addSubview:iconImage];
    [[iconImage layer] setMasksToBounds:YES];
    [[iconImage layer] setCornerRadius:17.5];
    
    
    UILabel* nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 20,160, 20)];
    nameLabel.text=[[ListArray ObjectAtIndex:row] ObjectForKey:@"username"];
    nameLabel.textColor=UIColorFromRGB(0x576b95);
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.font=[UIFont systemFontOfSize:14];
    nameLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:nameLabel];
    
    UILabel* timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 40,160,20)];
    timeLabel.text=[[ListArray ObjectAtIndex:row] ObjectForKey:@"createTime"];
    timeLabel.textColor=UIColorFromRGB(0x666666);
    timeLabel.backgroundColor=[UIColor clearColor];
    timeLabel.font=[UIFont systemFontOfSize:11];
    timeLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:timeLabel];
    
    UILabel* contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 60,SCREEN_WIDTH-20,height)];
    contentLabel.text=[[ListArray ObjectAtIndex:row] ObjectForKey:@"content"];
    contentLabel.textColor=UIColorFromRGB(0x000000);
    contentLabel.numberOfLines=100;
    contentLabel.backgroundColor=[UIColor clearColor];
    contentLabel.font=[UIFont systemFontOfSize:13];
    contentLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:contentLabel];
    

    for (int i=0; i<[imageArray count]; i++) {
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.frame = CGRectMake(7+103*(i%3),iHeight+(i/3)*103,100, 100);
        [imageBtn sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]] forState:UIControlStateNormal];
        [imageBtn sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]] forState:UIControlStateHighlighted];
        [imageBtn addTarget:self action:@selector(imageAct:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:imageBtn];
        [[imageBtn layer] setMasksToBounds:YES];
        [[imageBtn layer] setCornerRadius:2];
    }

    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(5,65+HHW+height+line*103+10,SCREEN_WIDTH-10, 0.5)];
    lineImage.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
    [cell.contentView addSubview:lineImage];
    
    return cell;
}
-(void)imageAct:(UIButton *)sender
{
    if (ShowView.isHidden==YES) {
        ShowView.hidden=NO;
        ShowImage.image=sender.currentImage;
    }else
    {
        ShowView.hidden=YES;
    }
}

- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
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
