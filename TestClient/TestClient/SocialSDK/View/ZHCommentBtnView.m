//
//  ZHCommentBtnView.h
//  TestClient
//
//  Created by albert on 15/9/13.
//  Copyright (c) 2015年 penghui.zh. All rights reserved.
//

#import "ZHCommentBtnView.h"
#import "ZHSocialParam.h"
#import "ZHNetworkAdapter.h"
#import "ZHAdapterManager.h"
#import "ZHCommentListViewController.h"
#import "ZHUtil.h"

@interface ZHCommentBtnView()

@property (nonatomic,strong) UIImageView                *iconImgView;
@property (nonatomic,strong) UILabel                    *textLabel;
@property (nonatomic,strong) UIView                     *commentView;

@property (nonatomic,strong) UITapGestureRecognizer     *tap;

@property (nonatomic) NSInteger                         commentNum;

@end

@implementation ZHCommentBtnView

- (instancetype)initWithFrame:(CGRect)frame socialParam:(ZHSocialParam *)socialParam{
    self = [super initWithFrame:frame];
    if (self) {
        [self addClickFun];
        [self queryCommentsNum];
    }
    return self;
}


- (void)queryCommentsNum{
    
    //mock
    self.commentNum = 20;
    [self setUpView];
    
    ZHNetworkAdapter *netWorkManager = [ZHAdapterManager sharedInstance].network;
    if (netWorkManager == nil) {
        //error，ZHNetworkAdapter为空
        //        return;
    }
    
    //    netWorkManager request:<#(NSString *)#> withParam:<#(ZHNetworkParam *)#> onSuccess:<#^(NSDictionary *dic)successBlock#> onFailed:<#^(NSInteger errorCode, NSString *errorMsg)failedBlock#>
}


- (void)setUpView{
    self.backgroundColor = [UIColor greenColor];//test
    [self addSubview:self.commentView];
    //    [self addSubview:self.iconImgView];
    //    [self addSubview:self.textLabel];
}

- (void)addClickFun{
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick)];
    [self addGestureRecognizer:_tap];
}

- (void)onClick{
    ZHCommentListViewController *commentListVC = [[ZHCommentListViewController alloc] init];
    UIViewController *currentVC = [ZHUtil getCurrentVC];
    if (currentVC == nil) {
        return;
    }else{
        if ([currentVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navVC = (UINavigationController *)currentVC;
            [navVC pushViewController:commentListVC animated:YES];
        }else{
            [currentVC presentViewController:commentListVC animated:YES completion:^{
                
            }];
        }
    }
    
    
    
    
}


#pragma mark - setter
- (void)setCommentNum:(NSInteger)commentNum{
    
    if (commentNum > 0) {
        self.textLabel.text = [NSString stringWithFormat:@"%ld",commentNum];
    }else{
        self.textLabel.text = @"评论";
    }

    [self.textLabel sizeToFit];
    CGFloat textLabelCenterX = self.iconImgView.frame.origin.x+self.iconImgView.frame.size.width+self.textLabel.frame.size.width/2;
    self.textLabel.center = CGPointMake(textLabelCenterX, self.iconImgView.center.y);
    
    CGFloat iconImgViewHeight = self.iconImgView.frame.size.height;
    CGFloat textLabelHeight = self.textLabel.frame.size.height;
    CGFloat praiseViewWith = self.iconImgView.frame.size.width+self.textLabel.frame.size.width;
    CGFloat praiseViewHeight = iconImgViewHeight > textLabelHeight?iconImgViewHeight:textLabelHeight;
    self.commentView.frame = CGRectMake(0, 0, praiseViewWith, praiseViewHeight);
    self.commentView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}



#pragma mark - getter
- (UIImageView *)iconImgView{
    if (_iconImgView == nil) {
        _iconImgView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _iconImgView.image = [UIImage imageNamed:@"comment"];
        _iconImgView.backgroundColor = [UIColor redColor];
        [_iconImgView sizeToFit];
    }
    return _iconImgView;
}

- (UILabel *)textLabel{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _textLabel.backgroundColor = [UIColor yellowColor];
    }
    return _textLabel;
}

- (UIView *)commentView{
    if (_commentView == nil) {
        _commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _commentView.backgroundColor = [UIColor blueColor];
        [_commentView addSubview:self.iconImgView];
        [_commentView addSubview:self.textLabel];
    }
    return _commentView;
}




- (void)clear{
    [self removeGestureRecognizer:_tap];
}

- (void)dealloc{
    [self clear];
}

@end
