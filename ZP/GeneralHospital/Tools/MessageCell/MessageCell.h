//
//  MessageCell.h
//  chatView
//
//  Created by 夏科杰 on 14-3-12.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
#import "MessageFrame.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
typedef enum {
    TestType = 0,  //检查单
    CheckType = 1, //化验单
    SoundType = 2  //声音
} SelectType;

@protocol CellDelegate <NSObject>
-(void)selectType:(SelectType)type Id:(NSString* )SId;
@end
@interface MessageCell : UITableViewCell<AVAudioPlayerDelegate>
{
    UIImage         *CellImage;
    NSString        *Id;
    UIButton        *TouchBtn;
    UIImageView     *AnimatingImage;
    UIActivityIndicatorView *IndicatorView;
}
@property (nonatomic, strong) NSArray      *UseArray;
@property (nonatomic, strong) MessageFrame *MessFrame;
@property (nonatomic, assign) id<CellDelegate>delegate;
@end
