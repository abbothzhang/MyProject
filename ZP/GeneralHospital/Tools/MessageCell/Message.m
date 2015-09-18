//
//  Message.m
//  chatView
//
//  Created by 夏科杰 on 14-3-12.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import "Message.h"

@implementation Message


-(void)setId:(NSString *)pid
{
    _Id=pid;
}
-(void)setSender:(NSString *)sender
{
    _Sender=sender;
}
-(void)setPType:(PersonType)pType
{
    _PType=pType;
}
-(void)setMType:(MessageType)mType
{
    _MType=mType;
}
-(void)setIcon:(NSString *)icon
{
    _Icon=icon;
}
-(void)setImage:(NSString *)image
{
    _Image=image;
}
-(void)setTime:(NSString *)time
{
    _Time=time;
}

-(void)setVLength:(NSString *)vLength
{
    _VLength=vLength;
}
-(void)setContent:(NSString *)content
{
    _Content=content;
}
-(void)setDict:(NSDictionary *)Dict
{
    self.Dict=Dict;
}

@end
