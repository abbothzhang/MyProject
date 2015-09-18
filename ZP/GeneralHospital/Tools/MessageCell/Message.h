//
//  Message.h
//  chatView
//
//  Created by 夏科杰 on 14-3-12.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    PersonTypeMe = 0,   // 自己发的
    PersonTypeOther = 1 //别人发得
} PersonType;

typedef enum {
    MessageTypeText = 0,//文本
    MessageTypeImage,   //图片
    MessageTypeReport,  //化验单
    MessageTypeCheck=3,   //检查单
    MessageTypeDocument,//文件
    MessageTypeSound,   //声音
    MessageTypeWeb=6,     //网页
    MessageTypeScore,   //评分
    MessageTypeComment, //评语
    MessageTypeOther=9
} MessageType;



@interface Message : NSObject
@property (nonatomic, assign) PersonType   PType;
@property (nonatomic, assign) MessageType  MType;
@property (nonatomic, retain) NSString     *Id;
@property (nonatomic, retain) NSString     *Sender;
@property (nonatomic, retain) NSString     *Icon;
@property (nonatomic, retain) NSString     *Image;
@property (nonatomic, retain) NSString     *Time;
@property (nonatomic, retain) NSString     *Content;
@property (nonatomic, retain) NSString     *VLength;
@property (nonatomic, retain) NSDictionary *Dict;

@end
