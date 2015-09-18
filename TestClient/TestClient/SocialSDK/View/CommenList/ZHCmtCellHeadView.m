//
//  ZHCommenCellHeadView.m
//  TestClient
//
//  Created by albert on 15/9/15.
//  Copyright (c) 2015年 penghui.zh. All rights reserved.
//

#import "ZHCmtCellHeadView.h"

@interface ZHCmtCellHeadView()



@end

@implementation ZHCmtCellHeadView

- (instancetype)initWithFrame:(CGRect)frame nickName:(NSString *)nickName time:(NSString *)time{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView{
    self.backgroundColor = [UIColor whiteColor];
}

@end


@interface ZHCmtCellIconView()

@end

@implementation ZHCmtCellIconView

- (instancetype)initWithFrame:(CGRect)frame img:(UIImage *)img{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView{
    self.backgroundColor = [UIColor greenColor];
}

@end
