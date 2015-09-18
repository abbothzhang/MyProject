//
//  MessageFrame.m
//  chatView
//
//  Created by 夏科杰 on 14-3-12.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//
#define IMAGEWIDTH  100
#define IMAGEHEIGHT 90
#define CHECKWIDTH  200
#define CHECKHEIGHT 75
#define REPORTWIDTH  200
#define REPORTHEIGHT 75
#define VOICEWIDTH  120
#define VOICEHEIGHT 41
#import "MessageFrame.h"
#import "Message.h"
@implementation MessageFrame
-(void)setMessage:(Message *)message
{
 
   // NSLog(@"====%@",message);
    _Message=message;
    float timeSize=[message.Time sizeWithFont:kTimeFont
                   constrainedToSize:CGSizeMake(kTimeWidth, kTimeHeight)
                                lineBreakMode:NSLineBreakByWordWrapping].width+10;
    CGSize contentSize = [message.Content sizeWithFont:kContentFont constrainedToSize:CGSizeMake(kContentW, 100000)];
    _TimeF=CGRectMake((SCR_WIDTH-timeSize)/2, kContentTop, timeSize, kTimeHeight);
    
    float ybegin=_Message.Sender==nil||[_Message.Sender length]==0?kContentTop*3+kTimeHeight:kContentTop*2+kTimeHeight+kAllTop;
    
    switch (message.PType) {
        case PersonTypeMe:
        {

            float xbegin=SCR_WIDTH-(message.MType!=MessageTypeText?IMAGEWIDTH:(contentSize.width+kContentLeft+kContentRight))-kIconWH-kContentLeft;
            _IconF=CGRectMake(SCR_WIDTH-kContentRight-kIconWH, kContentTop+kContentTop+kTimeHeight, kIconWH, kIconWH);
            _SenderF=CGRectMake(SCR_WIDTH-kContentRight*3-kIconWH-kSenderW, kContentTop+kContentTop+kTimeHeight, kSenderW, kSenderH);
            switch (message.MType) {
                case MessageTypeText:
                {
                    _ContentF=CGRectMake(xbegin,ybegin, contentSize.width+kContentLeft+kContentRight, contentSize.height+kContentTop+kContentBottom) ;
                    _CellHeight =ybegin+_ContentF.size.height+kContentBottom;
                }
                    break;
                case MessageTypeImage:
                {
                    _ContentF=CGRectMake(xbegin,ybegin,IMAGEWIDTH,IMAGEHEIGHT);
                    _CellHeight =ybegin+IMAGEHEIGHT+kContentBottom;
                }
                    break;
                case MessageTypeReport:
                {
                    _ContentF=CGRectMake(xbegin,ybegin,REPORTWIDTH,REPORTHEIGHT);
                    _CellHeight =ybegin+REPORTHEIGHT+kContentBottom;
                }
                    break;
                case MessageTypeCheck:
                {
                    _ContentF=CGRectMake(xbegin,ybegin,CHECKWIDTH,CHECKHEIGHT);
                    _CellHeight =ybegin+CHECKHEIGHT+kContentBottom;
                }
                    break;
                case MessageTypeDocument:
                {
                    _ContentF=CGRectMake(xbegin,ybegin,IMAGEWIDTH,IMAGEHEIGHT);
                    _CellHeight =ybegin+IMAGEHEIGHT+kContentBottom;
                }
                    break;
                case MessageTypeSound:
                {
                    xbegin=SCR_WIDTH-VOICEWIDTH-kIconWH-kContentLeft;
                    _ContentF=CGRectMake(xbegin,ybegin,VOICEWIDTH,VOICEHEIGHT);
                    _CellHeight =ybegin+VOICEHEIGHT+kContentBottom;
                }
                    break;
                case MessageTypeWeb:
                {
                    _ContentF=CGRectMake(xbegin,ybegin,IMAGEWIDTH,IMAGEHEIGHT);
                    _CellHeight =ybegin+IMAGEHEIGHT+kContentBottom;
                }
                    break;
                case MessageTypeOther:
                {
                    _ContentF=CGRectMake(xbegin,ybegin,IMAGEWIDTH,IMAGEHEIGHT);
                    _CellHeight =ybegin+IMAGEHEIGHT+kContentBottom;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case PersonTypeOther:
        {
            float xbegin=kContentRight*2+kIconWH;

            _IconF=CGRectMake(kContentRight, kContentTop+kContentTop+kTimeHeight, kIconWH, kIconWH);
            _SenderF=CGRectMake(kContentRight*3+kIconWH, kContentTop+kContentTop+kTimeHeight, kSenderW, kSenderH);
            switch (message.MType) {
                case MessageTypeText:
                {
                    _ContentF = CGRectMake(xbegin, ybegin, contentSize.width+kContentLeft+kContentRight, contentSize.height+kContentTop+kContentBottom) ;
                    _CellHeight =ybegin+_ContentF.size.height+kContentBottom;
                }
                    break;
                case MessageTypeImage:
                {
                    _ContentF   = CGRectMake(xbegin, ybegin,IMAGEWIDTH,IMAGEHEIGHT);
                    _CellHeight =ybegin+IMAGEHEIGHT+kContentBottom;
                }
                    break;
                case MessageTypeReport:
                {
                    _ContentF=CGRectMake(xbegin,ybegin,REPORTWIDTH,REPORTHEIGHT);
                    _CellHeight =ybegin+REPORTHEIGHT+kContentBottom;
                }
                    break;
                case MessageTypeCheck:
                {
                    _ContentF=CGRectMake(xbegin,ybegin,CHECKWIDTH,CHECKHEIGHT);
                    _CellHeight =ybegin+CHECKHEIGHT+kContentBottom;
                }
                    break;
                case MessageTypeDocument:
                {
                    _ContentF   = CGRectMake(xbegin, ybegin,IMAGEWIDTH,IMAGEHEIGHT);
                    _CellHeight =ybegin+IMAGEHEIGHT+kContentBottom;
                }
                    break;
                case MessageTypeSound:
                {
                    _ContentF   = CGRectMake(xbegin, ybegin,VOICEWIDTH,VOICEHEIGHT);
                    _CellHeight =ybegin+IMAGEHEIGHT+kContentBottom;
                }
                    break;
                case MessageTypeWeb:
                {
                    _ContentF   = CGRectMake(xbegin, ybegin,IMAGEWIDTH,IMAGEHEIGHT);
                    _CellHeight =ybegin+VOICEHEIGHT+kContentBottom;
                }
                    break;
                case MessageTypeScore:
                {
                    _ContentF = CGRectMake(xbegin, ybegin, 130+kContentLeft+kContentRight,  contentSize.height+kContentTop+kContentBottom) ;
                    _CellHeight =ybegin+_ContentF.size.height+kContentBottom;
                }
                    break;
                case MessageTypeComment:
                {
                    _ContentF = CGRectMake(xbegin, ybegin, contentSize.width+kContentLeft+kContentRight, contentSize.height+kContentTop+kContentBottom) ;
                    _CellHeight =ybegin+_ContentF.size.height+kContentBottom;
                }
                    break;
                case MessageTypeOther:
                {
                    _ContentF   = CGRectMake(xbegin, ybegin,IMAGEWIDTH,IMAGEHEIGHT);
                    _CellHeight =ybegin+IMAGEHEIGHT+kContentBottom;
                }
                    break;

                default:
                    break;
            }
        }
            break;
        default:
        {
            NSLog(@"is default");
            _IconF=CGRectMake(kContentLeft, kContentTop+kContentTop+kTimeHeight, kIconWH, kIconWH);
        }
            break;
    }
    _ShowTime=YES;
}
-(int)getRandomNumber:(int)from to:(int)to
{
    
    return (int)(from + (arc4random() % (to - from + 1))); //+1,result is [from to]; else is [from, to)!!!!!!!
    
}
@end
