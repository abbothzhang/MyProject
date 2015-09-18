//
//  A_SearchViewController.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14-9-30.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "A_SearchViewController.h"

@interface A_SearchViewController ()

@end

@implementation A_SearchViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        ListArray = [[NSMutableArray alloc]init];
        // Custom initialization
    }
    return self;
}

-(void)setBlock:(SearchBlock)sBlock;
{
    SBlock=sBlock;
}
-(void)SearchOrder:(NSString *)keyWord
{
    NSLog(@"%@",[NSString stringWithFormat:@"http://app.zipn.cn/app/search.jhtml?city=C0007&keyword=%@&order=4&page=1&size=10&x=120.17948490192&y=30.331132261917",keyWord]);
    ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://app.zipn.cn/app/search.jhtml?city=杭州&keyword=%@&order=4&page=1&size=10&x=120.17948490192&y=30.331132261917",keyWord] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [NetRequest setASIPostDict:nil
                       ApiName:@""
                     CanCancel:YES
                   SetHttpType:HttpGet
                     SetNotice:NoticeType1
                    SetNetWork:NetWorkTypeAS
                    SetProcess:ProcessUnType
                    SetEncrypt:Encryption
                      SetCache:Cache
                      NetBlock:^(NSDictionary *ReturnDict){
                          NSLog(@"%@",ReturnDict);
                          [ListArray removeAllObjects];
                          [ListArray addObjectsFromArray:[[ReturnDict objectForKey:@"data"] ObjectForKey:@"itemList"]];
                          [self.tableView reloadData];
                      }
                      NetError:^(int error) {
                      }
     ];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
       self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
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
    
    UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 75, 75)];
    [iconImage sd_setImageWithURL:[NSURL URLWithString:[[ListArray ObjectAtIndex:row] ObjectForKey:@"imageurl" ]]];
    [cell.contentView addSubview:iconImage];
    
    
    UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(105, 10,160, [[[ListArray ObjectAtIndex:row] ObjectForKey:@"title" ] length]>12?40:30)];
    titleLabel.text=[[ListArray ObjectAtIndex:row] ObjectForKey:@"title"];
    titleLabel.textColor=UIColorFromRGB(0x000000);
    titleLabel.numberOfLines=2;
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:titleLabel];
    
    NSMutableString *starString=[[NSMutableString alloc] init];
    for (int i=0; i<[[[ListArray ObjectAtIndex:row] ObjectForKey:@"score"] intValue]; i++) {
        [starString appendString:@"\ue630"];
    }
    
    UILabel* starLabel=[[UILabel alloc] initWithFrame:CGRectMake(105, 48,200, 16)];
    starLabel.text=starString;
    [starLabel setFont:[UIFont fontWithName:@"icomoon" size:13]];
    starLabel.textColor=UIColorFromRGB(0xfad72e);
    starLabel.backgroundColor=[UIColor clearColor];
    starLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:starLabel];
    
    UILabel* moneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(205, 48,100, 16)];
    moneyLabel.text=[NSString stringWithFormat:@"¥%@/人",[[ListArray ObjectAtIndex:row] ObjectForKey:@"price"]];
    moneyLabel.textColor=UIColorFromRGB(0x000000);
    moneyLabel.backgroundColor=[UIColor clearColor];
    moneyLabel.font=[UIFont systemFontOfSize:12];
    moneyLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:moneyLabel];
    ;
    
    UILabel* addressLabel=[[UILabel alloc] initWithFrame:CGRectMake(105, 73,200, 16)];
    addressLabel.text=[NSString stringWithFormat:@"%@         %@",[[ListArray ObjectAtIndex:row] ObjectForKey:@"area"],[[ListArray ObjectAtIndex:row] ObjectForKey:@"category"]];
    addressLabel.textColor=UIColorFromRGB(0x000000);
    addressLabel.backgroundColor=[UIColor clearColor];
    addressLabel.font=[UIFont systemFontOfSize:12];
    addressLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:addressLabel];
    
    UILabel* distanceLabel=[[UILabel alloc] initWithFrame:CGRectMake(265, 23,50, 16)];
    distanceLabel.text=[[ListArray ObjectAtIndex:row] ObjectForKey:@"distance"];
    distanceLabel.textColor=UIColorFromRGB(0x000000);
    distanceLabel.backgroundColor=[UIColor clearColor];
    distanceLabel.font=[UIFont systemFontOfSize:10];
    distanceLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:distanceLabel];
    
    
    UILabel* arrowLabel=[[UILabel alloc] initWithFrame:CGRectMake(290, 40,40, 40)];
    arrowLabel.text=@"\ue629";
    [arrowLabel setFont:[UIFont fontWithName:@"icomoon" size:20]];
    arrowLabel.textColor=UIColorFromRGB(0x888888);
    arrowLabel.backgroundColor=[UIColor clearColor];
    arrowLabel.textAlignment=NSTextAlignmentLeft;
    [cell.contentView addSubview:arrowLabel];
    
    
    
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 104.5, SCREEN_WIDTH-10, 0.5)];
    lineImage.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
    [cell.contentView addSubview:lineImage];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SBlock([ListArray objectAtIndex:[indexPath row]]);
   
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
