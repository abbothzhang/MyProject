//
//  ZHCmtList.m
//  TestClient
//
//  Created by albert on 15/9/15.
//  Copyright (c) 2015年 penghui.zh. All rights reserved.
//

#import "ZHCmtList.h"

@interface ZHCmtList()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView    *tableView;

@end

@implementation ZHCmtList

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;//TODO:
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}


@end
