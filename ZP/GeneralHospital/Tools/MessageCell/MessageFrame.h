//
//  MessageFrame.h
//  chatView
//
//  Created by 夏科杰 on 14-3-12.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//
#define kMargin        10 //间隔
#define kIconWH        50 //头像宽高
#define kContentW      180 //内容宽度

#define kSenderW       100 //头像宽高
#define kSenderH       18 //内容宽度

#define kTimeMarginW   15 //时间文本与边框间隔宽度方向
#define kTimeMarginH   10 //时间文本与边框间隔高度方向

#define kAllTop        20
#define kContentTop    10 //文本内容与按钮上边缘间隔
#define kContentLeft   16 //文本内容与按钮左边缘间隔
#define kContentBottom 10 //文本内容与按钮下边缘间隔
#define kContentRight  10 //文本内容与按钮右边缘间隔

#define kImageTop    4  //图片与按钮上边缘间隔
#define kImageLeft   11 //图片与按钮左边缘间隔
#define kImageBottom 6  //图片与按钮下边缘间隔
#define kImageRight  5  //图片与按钮右边缘间隔

#define kCRTop    4  //报告检查与按钮上边缘间隔
#define kCRLeft   11 //报告检查与按钮左边缘间隔
#define kCRBottom 6  //报告检查与按钮下边缘间隔
#define kCRRight  130  //报告检查与按钮右边缘间隔

#define kVoiceTop    4    //声音上边缘间隔
#define kVoiceLeft   11   //声音左边缘间隔
#define kVoiceBottom 4    //声音下边缘间隔
#define kVoiceRight  50  //声音右边缘间隔

#define kTimeFont    [UIFont systemFontOfSize:12] //时间字体
#define kContentFont [UIFont systemFontOfSize:18] //内容字体
#define kTimeWidth     120.0
#define kTimeHeight    15.0
#define SCR_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCR_HEIGHT [UIScreen mainScreen].bounds.size.height
#import <Foundation/Foundation.h>
@class Message;
@interface MessageFrame : NSObject
@property (nonatomic, assign, readonly) CGRect  IconF;
@property (nonatomic, assign, readonly) CGRect  SenderF;
@property (nonatomic, assign, readonly) CGRect  ImageF;
@property (nonatomic, assign, readonly) CGRect  TimeF;
@property (nonatomic, assign, readonly) CGRect  ContentF;
@property (nonatomic, assign, readonly) CGFloat CellHeight; //cell高度
@property (nonatomic, strong)           Message *Message;
@property (nonatomic, assign)           BOOL    ShowTime;
@end
