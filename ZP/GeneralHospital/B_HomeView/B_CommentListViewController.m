//
//  B_CommentListViewController.m
//  zhipin
//
//  Created by 夏科杰 on 15/2/13.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "B_CommentListViewController.h"

@interface B_CommentListViewController ()

@end

@implementation B_CommentListViewController
@synthesize ItemId;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"全部评论";
    ListArray=[[NSMutableArray alloc] init];
    TableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE-64-40)];
    TableView.backgroundColor=UIColorFromRGBA(0xf5f5f5,0.9);
    TableView.delegate=self;
    TableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TableView.dataSource=self;
    [self.view addSubview:TableView];
    
    
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.zipn.cn/app/review/item/list.jhtml?itemId=%@&page=1",ItemId]]];
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
    // Do any additional setup after loading the view.
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ListArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifier%ld",(long)row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    for (id view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    
    
    NSDictionary *dict=[[NSDictionary alloc] initWithDictionary:[ListArray objectAtIndex:row]];
    
    UIImageView *headImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10   , 30, 30)];
    [headImage sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"headImage"]]];
    [cell.contentView addSubview:headImage];
    [[headImage layer] setMasksToBounds:YES];
    [[headImage layer] setCornerRadius:15];
    
    UILabel* nLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 10   ,300, 20)];
    nLabel.text=[dict objectForKey:@"username"];
    nLabel.textColor=UIColorFromRGB(0x000000);
    nLabel.backgroundColor=[UIColor clearColor];
    nLabel.font=[UIFont systemFontOfSize:13];
    nLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:nLabel];
    
    UILabel* timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 28   ,300, 20)];
    timeLabel.text=[dict objectForKey:@"time"];
    timeLabel.textColor=UIColorFromRGB(0x999999);
    timeLabel.backgroundColor=[UIColor clearColor];
    timeLabel.font=[UIFont systemFontOfSize:11];
    timeLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:timeLabel];
    
    NSMutableString *starString=[NSMutableString new];
    for (int i=0; i<[[NSString stringWithFormat:@"%@",[dict objectForKey:@"score"]] intValue]; i++){
        [starString appendString:@"\ue61f"];
    }
    
    UILabel* sLabel=[[UILabel alloc] initWithFrame:CGRectMake(200, 0,150, 40)];
    sLabel.text=starString;
    sLabel.textColor=UIColorFromRGB(0xfed230);
    sLabel.backgroundColor=[UIColor clearColor];
    sLabel.font=[UIFont fontWithName:@"zipn" size:18];
    sLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:sLabel];
    
    UILabel* contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 45   ,300, 20)];
    contentLabel.text=[dict objectForKey:@"content"];
    contentLabel.textColor=UIColorFromRGB(0x000000);
    contentLabel.backgroundColor=[UIColor clearColor];
    contentLabel.font=[UIFont systemFontOfSize:12.5];
    contentLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:contentLabel];
    
    NSArray *imageArray=[[NSArray alloc] initWithArray:[dict objectForKey:@"images"]];
    for (int i=0; i<[imageArray count]; i++) {
        UIImageView *conmmentImage=[[UIImageView alloc] initWithFrame:CGRectMake(10+65*i, 65   , 60, 60)];
        [conmmentImage sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]]];
        [cell.contentView addSubview:conmmentImage];
    }
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(5,129.5, SCREEN_WIDTH-10, 0.5)];
    lineImage.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
    [cell.contentView addSubview:lineImage];
    
    return cell;
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
