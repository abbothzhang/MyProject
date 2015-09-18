//
//  JCTopic.m
//  PSCollectionViewDemo
//
//  Created by jc on 14-1-7.
//
//

#import "JCTopic.h"
#define SPACE 5
#define HEI 26
#define WID 156
#define HX 200
#define HY 124
#define FSIZE 16

@implementation JCTopic
@synthesize JCdelegate;
@synthesize rect;
@synthesize totalNum;
@synthesize scrollView;
@synthesize type;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        NSLog(@"------%@",[NSValue valueWithCGRect:frame]);
        [self setSelf];
       
    }
    return self;
}
-(void)setSelf{
    self.pagingEnabled = YES;
    self.scrollEnabled = YES;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
    switch (type) {
        case JCTopicLeft:
        {
            title = [[UILabel alloc]initWithFrame:CGRectMake(0,HY, self.frame.size.width, HEI)];
            [title setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
            [title setTextColor:[UIColor whiteColor]];
            if ([self.pics count]>0) {
                [title setText:[NSString stringWithFormat:@"   %@",[[self.pics firstObject] objectForKey:@"title"]]];}
            [title setFont:[UIFont boldSystemFontOfSize:FSIZE]];
            [scrollView addSubview:title];
            NSLog(@"%@--=-===----",self.pics);
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(HX, HY, WID, HEI)];
            pageControl.numberOfPages = totalNum;
            pageControl.currentPage = 0;
            [pageControl setBounds:CGRectMake(0, 0, 16 * (3 - 1) + 16, 16)];
            [scrollView==nil?self.window:scrollView addSubview:pageControl];
        }
            break;
            
        case JCTopicMiddle:
        {
            NSLog(@"%@--=-===----",self.pics);
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(HX, HY, WID, HEI)];
            pageControl.numberOfPages = totalNum;
            pageControl.currentPage = 0;
            pageControl.center=CGPointMake(self.center.x, pageControl.center.y);
            [pageControl setBounds:CGRectMake(0, 0, 16 * (3 - 1) + 16, 16)];
            [scrollView==nil?self.window:scrollView addSubview:pageControl];
        }
            break;
        case JCTopicRight:
        {
            title = [[UILabel alloc]initWithFrame:CGRectMake(0,HY, self.frame.size.width, HEI)];
            [title setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
            [title setTextColor:[UIColor whiteColor]];
            if ([self.pics count]>0) {
                [title setText:[NSString stringWithFormat:@"   %@",[[self.pics firstObject] objectForKey:@"title"]]];}
            [title setFont:[UIFont boldSystemFontOfSize:FSIZE]];
            [scrollView addSubview:title];
            NSLog(@"%@--=-===----",self.pics);
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(HX, HY, WID, HEI)];
            pageControl.numberOfPages = totalNum;
            pageControl.currentPage = 0;
            [pageControl setBounds:CGRectMake(0, 0, 16 * (3 - 1) + 16, 16)];
            [scrollView==nil?self.window:scrollView addSubview:pageControl];
        }
            break;
        default:
            break;
    }

}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self setSelf];
    
    // Drawing code
}
-(void)upDate{
    NSMutableArray * tempImageArray = [[NSMutableArray alloc]init];
    [tempImageArray addObject:[self.pics lastObject]];
    for (id obj in self.pics) {
        [tempImageArray addObject:obj];
    }
    [tempImageArray addObject:[self.pics objectAtIndex:0]];
    self.pics = Nil;
    self.pics = tempImageArray;
    
    int i = 0;
    for (id obj in self.pics) {
 
        UIImageView * tempImage = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.frame.size.width+rect.origin.x,rect.origin.y, rect.size.width, rect.size.height)];
        //tempImage.contentMode = UIViewContentModeScaleAspectFill;
        [tempImage setClipsToBounds:YES];
        if ([[obj objectForKey:@"isLoc"]boolValue]) {
            [tempImage setImage:[obj objectForKey:@"pic"]];
        }else{
            if ([obj objectForKey:@"placeholderImage"]) {
                [tempImage setImage:[obj objectForKey:@"placeholderImage"]];
            }
            [NSURLConnection sendAsynchronousRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[obj objectForKey:@"pic"]]]
                                               queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                                   if (!error && responseCode == 200) {
                                                       tempImage.image = Nil;
                                                       UIImage *_img = [[UIImage alloc] initWithData:data];
                                                       [tempImage setImage:_img];
                                                   }else{
                                                       if ([obj objectForKey:@"placeholderImage"]) {
                                                           [tempImage setImage:[obj objectForKey:@"placeholderImage"]];
                                                       }
                                                   }
                                               }];
        }
 
        [self addSubview:tempImage];

        i ++;
    }
    [self setContentSize:CGSizeMake(self.frame.size.width*[self.pics count], 0)];
    [self setContentOffset:CGPointMake(self.frame.size.width, self.contentOffset.y) animated:NO];
    
    if (scrollTimer) {
        [scrollTimer invalidate];
        scrollTimer = nil;
        
    }
    if ([self.pics count]>3) {
        scrollTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(scrollTopic) userInfo:nil repeats:YES];
    }
    [pageControl bringSubviewToFront:self];
}
-(void)click:(id)sender{
    [JCdelegate didClick:[self.pics objectAtIndex:[sender tag]]];
}
- (void)scrollViewDidScroll:(UIScrollView *)ScrollView{
    
    CGFloat Width=self.frame.size.width;
    if (ScrollView.contentOffset.x == self.frame.size.width) {
        flag = YES;
    }
    if (flag) {
        if (ScrollView.contentOffset.x <= 0) {
            [self setContentOffset:CGPointMake(Width*([self.pics count]-2), self.contentOffset.y) animated:NO];
        }else if (ScrollView.contentOffset.x >= Width*([self.pics count]-1)) {
            [self setContentOffset:CGPointMake(self.frame.size.width, self.contentOffset.y) animated:NO];
        }
    }
    currentPage = ScrollView.contentOffset.x/self.frame.size.width-1;
    [JCdelegate currentPage:currentPage total:[self.pics count]-2];
    scrollTopicFlag = currentPage+2==2?2:currentPage+2;
    [title setText:[NSString stringWithFormat:@"   %@",[[self.pics objectAtIndex:scrollTopicFlag] objectForKey:@"title"]]];
    pageControl.currentPage = scrollTopicFlag-2;
}
-(void)scrollTopic{
    [self setContentOffset:CGPointMake(self.frame.size.width*scrollTopicFlag, self.contentOffset.y) animated:YES];
    [title setText:[NSString stringWithFormat:@"   %@",[[self.pics objectAtIndex:scrollTopicFlag] objectForKey:@"title"]]];
    pageControl.currentPage = scrollTopicFlag-2;
    if (scrollTopicFlag > [self.pics count]) {
        scrollTopicFlag = 1;
    }else {
        scrollTopicFlag++;
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    scrollTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(scrollTopic) userInfo:nil repeats:YES];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollTimer) {
        [scrollTimer invalidate];
        scrollTimer = nil;
    }
    
}
-(void)releaseTimer{
    if (scrollTimer) {
        [scrollTimer invalidate];
        scrollTimer = nil;
        
    }
}

@end
