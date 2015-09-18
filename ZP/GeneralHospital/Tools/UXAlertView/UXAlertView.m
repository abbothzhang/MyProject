//
//  UXAlertView.m
//  浙一医护版
//
//  Created by 夏科杰 on 14-8-5.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "UXAlertView.h"

@implementation UXAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (AlertBlock) {
        AlertBlock(buttonIndex);
    }
}

-(void)ShowBlock:(UXAlertBlock)alertBlock
{
    self.delegate=self;
    AlertBlock=alertBlock;
    [self show];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
