//
//  D_MyHomeViewController.m
//  zhipin
//
//  Created by kjx on 15/3/31.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//
#import "D_MyHomeViewController.h"
#import "UIImageView+WebCache.h"
#define BH 256
@interface D_MyHomeViewController ()
@end

@implementation D_MyHomeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden=NO;
}

-(void)LeftAct
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    HeadImage.frame=CGRectMake(0, 0, SCREEN_WIDTH, -scrollView.contentOffset.y-103);
    NSLog(@"------++++%f",scrollView.contentOffset.y);
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        HeadImage.hidden=scrollView.contentOffset.y>0;
    } completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HeadImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 256)];
    HeadImage.image=[UIImage imageNamed:@"d_my_home.png"];
    [self.view addSubview:HeadImage];
    
    TableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE)];
    TableView.backgroundColor=UIColorFromRGBA(0xf5f5f5,0.9);
    TableView.delegate=self;
    TableView.contentInset=UIEdgeInsetsMake(359, 0, 0, 0);
    TableView.allowsSelection=NO;
    TableView.backgroundColor=[UIColor clearColor];
    TableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    TableView.dataSource=self;
    [self.view addSubview:TableView];
 
    
    UIButton *leftBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(15, 20, 33, 33)];
    [leftBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [leftBtn setTitle:@"\ue626" forState:UIControlStateNormal];
    [leftBtn setTitle:@"\ue626" forState:UIControlStateHighlighted];
    [leftBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    leftBtn.backgroundColor=[UIColor colorWithWhite:1 alpha:0.55];
    [leftBtn addTarget:self action:@selector(LeftAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    [[leftBtn layer] setMasksToBounds:YES];
    [[leftBtn layer] setCornerRadius:16.5];
    [[leftBtn layer]setBorderWidth:1];
    [[leftBtn layer]setBorderColor:[UIColorFromRGB(0xcccccc) CGColor]];
    
     [self performSelector:@selector(LoadData) withObject:nil afterDelay:0.5];
    
    }

-(void)LoadData
{
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        ASINetRequest* NetRequest=[ASINetRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.zipn.cn/app/sign/user/list.jhtml"]]];
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
                              NSLog(@"ReturnDict=%@",ReturnDict);
                              if (![[ReturnDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]||[ReturnDict objectForKey:@"data"]==nil||[[ReturnDict allKeys] count]<1) {
                                  return ;
                              }
                              NSLog(@"ReturnDict=%@",ReturnDict);
                              DetailDict=[[NSDictionary alloc] initWithDictionary:[ReturnDict ObjectForKey:@"data"]];
                              
                              if ([DetailDict ObjectForKey:@"backgroundImage"]!=nil&&[[DetailDict ObjectForKey:@"backgroundImage"] length]>5) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [HeadImage sd_setImageWithURL:[NSURL URLWithString:[DetailDict ObjectForKey:@"backgroundImage"]] placeholderImage:[UIImage imageNamed:@"d_my_home.png"]];
                                  });
                                  
                              }
                              
                              UIImageView *logoImage=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, -153, 75, 75)];
                              [logoImage sd_setImageWithURL:[NSURL URLWithString:[DetailDict ObjectForKey:@"headImage"]] placeholderImage:[UIImage imageNamed:@"d_head_image.png"]];
                              [TableView addSubview:logoImage];
                              [[logoImage layer] setMasksToBounds:YES];
                              [[logoImage layer] setCornerRadius:37.5];
                              [[logoImage layer] setBorderWidth:1];
                              [[logoImage layer] setBorderColor:[STYLECLOLR CGColor]];
                              
                              
                              UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,  -58,SCREEN_WIDTH-60, 20)];
                              titleLabel.text=[DetailDict ObjectForKey:@"signature"];
                              titleLabel.textColor=UIColorFromRGB(0x999999);
                              titleLabel.numberOfLines=5;
                              titleLabel.backgroundColor=[UIColor clearColor];
                              titleLabel.font=[UIFont systemFontOfSize:12];
                              titleLabel.textAlignment=NSTextAlignmentRight;
                              [TableView addSubview:titleLabel];
                              
                              UIButton *dynamicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                              dynamicBtn.frame = CGRectMake(3, -33, SCREEN_WIDTH-6, 33);
                              [dynamicBtn setTitle:@"动态" forState:UIControlStateNormal];
                              [dynamicBtn setTitle:@"动态" forState:UIControlStateHighlighted];
                              dynamicBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
                              dynamicBtn.userInteractionEnabled=NO;
                              [dynamicBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR] forState:UIControlStateNormal];
                              [dynamicBtn setBackgroundImage:[GeneralClass CreateImageWithColor:STYLECLOLR] forState:UIControlStateSelected];
                              //[dynamicBtn addTarget:self action:@selector(loginAct) forControlEvents:UIControlEventTouchUpInside];
                              [TableView addSubview:dynamicBtn];
                              [[dynamicBtn layer] setMasksToBounds:YES];
                              [[dynamicBtn layer] setCornerRadius:5];
                              
                              if ([[[ReturnDict objectForKey:@"data"] objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                                  ListArray = [[NSMutableArray alloc] initWithArray:[[ReturnDict objectForKey:@"data"] objectForKey:@"list"]];
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [TableView reloadData];
                                  });
                              }
                              
                          }
                          NetError:^(int error) {
                          }
         ];
    });

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSUInteger row = [indexPath row];
    UIFont *font = [UIFont systemFontOfSize:12];//跟label的字体大小一样
    CGSize size = CGSizeMake(SCREEN_WIDTH-20, 29999);//跟label的宽设置一样
    NSString *contentString=[[ListArray ObjectAtIndex:row] ObjectForKey:@"content"];
    if (IS_IOS7_LATER)
    {
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
        
        size =[contentString boundingRectWithSize:size
                                          options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                       attributes:dic
                                          context:nil].size;
    }else{
        size = [contentString sizeWithFont:font
                         constrainedToSize:size
                             lineBreakMode:NSLineBreakByCharWrapping];//ios7以上已经摒弃的这个方法
    }
    
    
    NSArray *imageArray=[[NSArray alloc] initWithArray:[[ListArray ObjectAtIndex:row] ObjectForKey:@"imageList"]];
    
    
    return size.height+110+((int)[imageArray count]/3+([imageArray count]%3>0?1:0))*110;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ListArray count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifier%ld",(long)row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        NSArray *imageArray=[[NSArray alloc] initWithArray:[[ListArray ObjectAtIndex:row] ObjectForKey:@"imageList"]];
        UIFont *font = [UIFont systemFontOfSize:12];//跟label的字体大小一样
        CGSize size = CGSizeMake(SCREEN_WIDTH-20, 29999);//跟label的宽设置一样
        NSString *contentString=[[ListArray ObjectAtIndex:row] ObjectForKey:@"content"];
        if (IS_IOS7_LATER)
        {
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
            
            size =[contentString boundingRectWithSize:size
                                              options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                           attributes:dic
                                              context:nil].size;
        }else{
            size = [contentString sizeWithFont:font
                             constrainedToSize:size
                                 lineBreakMode:NSLineBreakByCharWrapping];//ios7以上已经摒弃的这个方法
        }
        
        UIView *cellView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,size.height+110+((int)[imageArray count]/3+([imageArray count]%3>0?1:0))*110)];
        cellView.tag=row;
        cellView.backgroundColor=UIColorFromRGB(0xeeeeee);
        [cell.contentView addSubview:cellView];
        
        UIImageView *iconImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 15.5, 35, 35)];
        [iconImage sd_setImageWithURL:[NSURL URLWithString:[[ListArray ObjectAtIndex:row] ObjectForKey:@"headImage"]]];
        [cellView addSubview:iconImage];
        [[iconImage layer] setMasksToBounds:YES];
        [[iconImage layer] setCornerRadius:17.5];
        [[iconImage layer] setBorderWidth:1];
        [[iconImage layer] setBorderColor:[STYLECLOLR CGColor]];
        
        UILabel* titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(52.5,  12.5,180, 20)];
        titleLabel.text=[[ListArray ObjectAtIndex:row] ObjectForKey:@"username"];
        titleLabel.textColor=UIColorFromRGB(0x000000);
        titleLabel.numberOfLines=5;
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.font=[UIFont systemFontOfSize:12];
        titleLabel.textAlignment=NSTextAlignmentLeft;
        [cellView addSubview:titleLabel];
        
        
        UILabel* timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(52.5,  35,180, 20)];
        timeLabel.text=[[ListArray ObjectAtIndex:row] ObjectForKey:@"createTime"];
        timeLabel.textColor=UIColorFromRGB(0x999999);
        timeLabel.numberOfLines=5;
        timeLabel.backgroundColor=[UIColor clearColor];
        timeLabel.font=[UIFont systemFontOfSize:12];
        timeLabel.textAlignment=NSTextAlignmentLeft;
        [cellView addSubview:timeLabel];
        
        

        
        UILabel *contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 60,SCREEN_WIDTH-20, size.height+10)];
        contentLabel.text=contentString;
        contentLabel.textColor=UIColorFromRGB(0x999999);
        contentLabel.numberOfLines=5;
        contentLabel.backgroundColor=[UIColor clearColor];
        contentLabel.font=font;
        contentLabel.textAlignment=NSTextAlignmentLeft;
        [cellView addSubview:contentLabel];
        

        for (int i=0; i<[imageArray count]; i++) {
            float x=(SCREEN_WIDTH-300)/4+(100+(SCREEN_WIDTH-300)/4)*(i%3);
            float y=contentLabel.frame.origin.y+contentLabel.frame.size.height+((int)i/3)*110;
            
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, 100, 100)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]]];
            [cellView addSubview:imageView];
        }
        
        UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, contentLabel.frame.origin.y+contentLabel.frame.size.height+((int)[imageArray count]/3+([imageArray count]%3>0?1:0))*110, SCREEN_WIDTH-10, 0.5)];
        lineImage.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
        [cell.contentView addSubview:lineImage];
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(7, lineImage.frame.origin.y+5, SCREEN_WIDTH-14, 30)];
        imageView.backgroundColor=[UIColor whiteColor];
        [cellView addSubview:imageView];
        
        
        UILabel* sLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,0,60, 30)];
        sLabel.text=@"\ue60e";
        sLabel.textColor=STYLECLOLR;
        sLabel.backgroundColor=[UIColor clearColor];
        sLabel.font=[UIFont fontWithName:@"zipn" size:18];
        sLabel.textAlignment=NSTextAlignmentLeft;
        [imageView addSubview:sLabel];
        
        UILabel *shopName=[[UILabel alloc] initWithFrame:CGRectMake(30, 0,SCREEN_WIDTH-80, 30)];
        shopName.text=[[ListArray ObjectAtIndex:row] ObjectForKey:@"shopName"];
        shopName.textColor=UIColorFromRGB(0x999999);
        shopName.numberOfLines=5;
        shopName.backgroundColor=[UIColor clearColor];
        shopName.font=[UIFont systemFontOfSize:12];
        shopName.textAlignment=NSTextAlignmentLeft;
        [imageView addSubview:shopName];
        
        
        UIImageView *lineImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, imageView.frame.origin.y+imageView.frame.size.height+5, SCREEN_WIDTH-10, 0.5)];
        lineImage1.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.4];
        [cell.contentView addSubview:lineImage1];
        

    }
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

//from https://github.com/cyndibaby905/TwitterCover

