//
//  LeftTableView.m
//  至品购物
//
//  Created by 夏科杰 on 14-9-7.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "B_LeftTableView.h"

@implementation B_LeftTableView
@synthesize ListArray;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _IsHid=YES;
        self.hidden=YES;
        // Initialization code
    }
    return self;
}

-(void)SetClickBlock:(ClickBlock)clickBlock
{
    CBlock=clickBlock;
}

-(void)setListArray:(NSArray *)listArray
{
    
    ListArray=listArray;
//    NSLog(@"----++++++%@",listArray);
    self.dataSource=self;
    self.delegate=self;
    self.separatorColor=UIColorFromRGB(0xd3d3d3);
    self.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ListArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifier%ld",(long)[indexPath row]];
    NSUInteger row = [indexPath row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleDefault;

    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    for (id view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.textLabel.frame=CGRectMake(15, 0, 150, 45);
    cell.textLabel.text=[[ListArray objectAtIndex:row] ObjectForKey:@"name"];
//    cell.textLabel.textColor=UIColorFromRGB(0x666666);
    cell.textLabel.textColor = [UIColor whiteColor];
    NSLog(@"%@",[[ListArray objectAtIndex:row] ObjectForKey:@"name"]);
    cell.backgroundColor=[UIColor clearColor];
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBlock([NSString stringWithFormat:@"%@",[[ListArray objectAtIndex:indexPath.row] ObjectForKey:@"id"]]);
    
}

@end
