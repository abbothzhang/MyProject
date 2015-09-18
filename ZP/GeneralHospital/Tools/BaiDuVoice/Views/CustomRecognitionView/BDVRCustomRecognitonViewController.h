//
//  BDVRCustomRecognitonViewController.h
//  BDVRClientSample
//
//  Created by Baidu on 13-9-25
//  Copyright 2013 Baidu Inc. All rights reserved.
//

// 头文件
#import <UIKit/UIKit.h>
#import "BDVoiceRecognitionClient.h"
#import "A_VoiceViewController.h"
// 前向声明
@class BDVRViewController;

// @class - BDVRCustomRecognitonViewController
// @brief - 语音搜索界面的实现类
@interface BDVRCustomRecognitonViewController : UIViewController<MVoiceRecognitionClientDelegate>
{
	UIImageView *_dialog;
    A_VoiceViewController *clientSampleViewController;
    
    NSTimer *_voiceLevelMeterTimer; // 获取语音音量界别定时器
}

// 属性
@property (nonatomic, retain) UIImageView *dialog;
@property (nonatomic, assign) A_VoiceViewController *clientSampleViewController;
@property (nonatomic, retain) NSTimer *voiceLevelMeterTimer;
- (void)startVoiceLevelMeterTimer;
- (void)freeVoiceLevelMeterTimerTimer;
// 方法
- (void)cancel:(id)sender;

@end // BDVRCustomRecognitonViewController
