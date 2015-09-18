//
//  A_VoiceViewController.h
//  至品购物
//
//  Created by 夏科杰 on 14-9-6.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDRecognizerViewController.h"
#import "BDRecognizerViewDelegate.h"
#import "BDVRFileRecognizer.h"
#import "BDVRDataUploader.h"
#import "BDSSpeechSynthesizerDelegate.h"
#import "BDSSpeechSynthesizer.h"

#import "MessageFrame.h"
#import "MessageCell.h"
#import "Message.h"
#import "A_SearchViewController.h"
// 枚举
enum TDemoButtonType
{
	EDemoButtonTypeSetting = 0,
	EDemoButtonTypeVoiceRecognition,
    EDemoButtonTypeSDKUI
};

@class BDVRCustomRecognitonViewController;
@interface A_VoiceViewController : UIViewController<BDRecognizerViewDelegate, MVoiceRecognitionClientDelegate, BDVRDataUploaderDelegate,BDSSpeechSynthesizerDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    BDSSpeechSynthesizer    *synthesizer;
    UIButton                *voiceBtn;
    UITableView             *TableView;
    NSMutableArray          *MutableArray;
    UIView                  *BeginView;
    A_SearchViewController  *A_SearchView;
}
@property (nonatomic, retain) BDVRCustomRecognitonViewController *audioViewController;
@property (nonatomic, retain) BDRecognizerViewController *recognizerViewController;
@property (nonatomic, retain) BDVRRawDataRecognizer *rawDataRecognizer;
@property (nonatomic, retain) BDVRFileRecognizer *fileRecognizer;
@property (nonatomic, retain) BDVRDataUploader *contactsUploader;


// --UI中按钮动作
- (void)settingAction;
- (void)voiceRecognitionAction;
- (void)sdkUIRecognitionAction;
- (void)audioDataRecognitionAciton;
- (void)uploadContactsAction:(UIButton *)sender;

// --log & result
- (void)logOutToContinusManualResut:(NSString *)aResult;
- (void)logOutToManualResut:(NSString *)aResult;
- (void)logOutToLogView:(NSString *)aLog;


@end
