//
//  A_VoiceViewController.m
//  至品购物
//
//  Created by 夏科杰 on 14-9-6.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//
#define RISI @""
#import "A_VoiceViewController.h"
#import "BDVoiceRecognitionClient.h"
#import "BDVRSettingViewController.h"
#import "BDVRSConfig.h"
#import "BDVRCustomRecognitonViewController.h"
#import "BDVRUIPromptTextCustom.h"
#import "B_ShopDetailViewController.h"
#import "GlobalHead.h"
//#define API_KEY @"8MAxI5o7VjKSZOKeBzS4XtxO"
//#define SECRET_KEY @"Ge5GXVdGQpaxOmLzc8fOM8309ATCz9Ha"

//#warning 请修改为您在百度开发者平台申请的API_KEY和SECRET_KEY
#define API_KEY @"GM7ryBPN4LjNKRq5xNGTxBXC" // 请修改为您在百度开发者平台申请的API_KEY
#define SECRET_KEY @"EhTB6TUjLEGiRvGVtzNEqCmKbu6ksUXN" // 请修改您在百度开发者平台申请的SECRET_KEY


@interface A_VoiceViewController ()

@end

@implementation A_VoiceViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        MutableArray=[[NSMutableArray alloc] init];
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
    // 顶部字体白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];


}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 顶部字体黑色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    

    self.navigationController.navigationBarHidden=YES;
}
-(void)getList:(NSString *)keyword
{

    TableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE-64-70-200);

    if (A_SearchView==nil) {
        A_SearchView=[[A_SearchViewController alloc] init];
        A_SearchView.view.frame=CGRectMake(0, SCREEN_HIGHE-64-70-200, SCREEN_WIDTH, 200);
        
        [self.view addSubview:A_SearchView.view];
        __weak UIViewController* selfWeek=self;
        [A_SearchView setBlock:^(NSDictionary *Dict) {
                B_ShopDetailViewController *B_ShopDetailView=[[B_ShopDetailViewController alloc] init];
                B_ShopDetailView.Dict=Dict;
                B_ShopDetailView.hidesBottomBarWhenPushed=YES;
                [selfWeek.navigationController pushViewController:B_ShopDetailView animated:YES];
            
        }];
    }
    [A_SearchView SearchOrder:keyword];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
   
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=UIColorFromRGB(0xeeeeee);
        
    
    TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE-64-70) style:UITableViewStylePlain];
    TableView.dataSource = self;
    TableView.delegate = self;
    TableView.hidden=YES;
    TableView.showsHorizontalScrollIndicator=NO;
    TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    TableView.backgroundColor = [UIColor clearColor];
   // TableView.allowsSelection=NO;
    [self.view addSubview:TableView];
    
    synthesizer = [[BDSSpeechSynthesizer alloc] initSynthesizer:@"holder" delegate:self];
    [self setParams];
//    int ret = [synthesizer speak:@"你好,欢迎使用至品购物,我是risi。"];
//    if (ret != 0) {
//
//        NSLog(@"+++++%d",ret);
//    }
    [self addCell:RISI Content:@"你好,欢迎使用至品购物。" Icon:@"120.png" IsMe:PersonTypeOther];
    

    
    BeginView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE)];
    [self.view addSubview:BeginView];
    
    UILabel *upLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 110,SCREEN_WIDTH,25)];
    upLabel.text=@"您可以试试问我";
    upLabel.textColor=UIColorFromRGB(0x636363);
    upLabel.backgroundColor=[UIColor clearColor];
    upLabel.font=[UIFont systemFontOfSize:19];
    upLabel.textAlignment=NSTextAlignmentCenter;
//    upLabel.backgroundColor = [UIColor greenColor];
//    BeginView.backgroundColor = [UIColor yellowColor];
    [BeginView addSubview:upLabel];
    
   
//    UILabel *downLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 170,300,200)];
//    downLabel.text=@"杭州去哪里购物?\n\n上海美食\n\n预定餐厅\n\n去哪儿玩";
//    downLabel.textColor=UIColorFromRGB(0x636363);
//    downLabel.numberOfLines=10;
//    downLabel.backgroundColor=[UIColor clearColor];
//    downLabel.font=[UIFont systemFontOfSize:14];
//    downLabel.textAlignment=NSTextAlignmentCenter;
//    [BeginView addSubview:downLabel];
    
    
    voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    voiceBtn.frame = CGRectMake((SCREEN_WIDTH-40)/2, SCREEN_HIGHE-64-70, 40, 40);
    [voiceBtn setImage:[UIImage imageNamed:@"voice.png"] forState:UIControlStateNormal];
    [voiceBtn setImage:[UIImage imageNamed:@"voice.png"] forState:UIControlStateSelected];
    [voiceBtn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:voiceBtn];

    // Do any additional setup after loading the view.
}


-(void)addCell:(NSString *)sender
       Content:(NSString *)content
          Icon:(NSString *)icon
          IsMe:(PersonType)type

{
    // 消息种类1:文字（默认）2:图片 3：语音
    MessageFrame *messageFrame = [[MessageFrame alloc] init];
    Message *message = [[Message alloc] init];
    switch (type) {
        case PersonTypeOther:
            message.PType= PersonTypeOther;
            message.Icon   = icon;
            break;
        case PersonTypeMe:
            message.PType= PersonTypeMe;
            message.Icon   = [G_UseDict ObjectForKey:@"headImage"];
            break;
        default:
            break;
    }
    switch (1) {
        case 1:
            message.MType = MessageTypeText;
            break;
        case 2:
            message.MType  = MessageTypeImage;
            break;
        case 3:
            message.MType  = MessageTypeSound;
            break;
        default:
            break;
    }

    message.Sender  = sender;
    message.Time    =[self updateTime];;
    message.Content =content;
    messageFrame.Message = message;
    [MutableArray addObject:messageFrame];
    
    [TableView reloadData];
    if (TableView.contentSize.height>TableView.frame.size.height) {
        TableView.contentOffset=CGPointMake(0, TableView.contentSize.height-TableView.frame.size.height);
    }
}

-(NSString *)updateTime {
    NSDate* now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:now];
    //long y = [dd year];
    NSInteger m = [dd month];
    NSInteger d = [dd day];
    
    NSInteger hour = [dd hour];
    NSInteger min  = [dd minute];
    NSInteger sec  = [dd second];
 
    
    return [NSString stringWithFormat:@"%02d月%02d日 %02d:%02d:%02d",m,d,hour,min,sec];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [MutableArray[indexPath.row] CellHeight];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [MutableArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
    for (id view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.contentView.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    // 设置数据
    cell.MessFrame = [MutableArray objectAtIndex:[indexPath row]];
    
    return cell;
}


- (void)setParams
{
    // 此处需要将setApiKey:withSecretKey:方法的两个参数替换为你在百度开发者中心注册应用所得到的apiKey和secretKey
    [synthesizer setApiKey:API_KEY withSecretKey:SECRET_KEY];
    [synthesizer setParamForKey:BDS_PARAM_TEXT_ENCODE value:BDS_TEXT_ENCODE_UTF8];
    [synthesizer setParamForKey:BDS_PARAM_SPEAKER value:BDS_SPEAKER_FEMALE];
    [synthesizer setParamForKey:BDS_PARAM_VOLUME value:@"5"];
    [synthesizer setParamForKey:BDS_PARAM_SPEED value:@"5"];
    [synthesizer setParamForKey:BDS_PARAM_PITCH value:@"5"];
    [synthesizer setParamForKey:BDS_PARAM_AUDIO_ENCODE value:BDS_AUDIO_ENCODE_AMR];
    [synthesizer setParamForKey:BDS_PARAM_AUDIO_RATE value:BDS_AUDIO_BITRATE_AMR_15K85];
}

-(void)start:(UIButton* )sender
{

    TableView.hidden=NO;
    BeginView.hidden=YES;
    [self voiceRecognitionAction];

}

- (void)voiceRecognitionAction
{
    
    // 设置开发者信息
    [[BDVoiceRecognitionClient sharedInstance] setApiKey:API_KEY withSecretKey:SECRET_KEY];
    
    // 设置语音识别模式，默认是输入模式
    [[BDVoiceRecognitionClient sharedInstance] setProperty:[[BDVRSConfig sharedInstance].recognitionProperty intValue]];
    
    // 设置是否需要语义理解，只在搜索模式有效
    [[BDVoiceRecognitionClient sharedInstance] setConfig:@"nlu" withFlag:[BDVRSConfig sharedInstance].isNeedNLU];
    
    // 设置识别语言
    [[BDVoiceRecognitionClient sharedInstance] setLanguage:[BDVRSConfig sharedInstance].recognitionLanguage];
    
    // 是否打开语音音量监听功能，可选
    if ([BDVRSConfig sharedInstance].voiceLevelMeter)
    {
        BOOL res = [[BDVoiceRecognitionClient sharedInstance] listenCurrentDBLevelMeter];
        
        if (res == NO)  // 如果监听失败，则恢复开关值
        {
            [BDVRSConfig sharedInstance].voiceLevelMeter = NO;
        }
    }
    else
    {
        [[BDVoiceRecognitionClient sharedInstance] cancelListenCurrentDBLevelMeter];
    }
    
    // 设置播放开始说话提示音开关，可选
    [[BDVoiceRecognitionClient sharedInstance] setPlayTone:EVoiceRecognitionPlayTonesRecStart isPlay:[BDVRSConfig sharedInstance].playStartMusicSwitch];
    // 设置播放结束说话提示音开关，可选
    [[BDVoiceRecognitionClient sharedInstance] setPlayTone:EVoiceRecognitionPlayTonesRecEnd isPlay:[BDVRSConfig sharedInstance].playEndMusicSwitch];
    
    // 创建语音识别界面，在其viewdidload方法中启动语音识别
    BDVRCustomRecognitonViewController *tmpAudioViewController = [[BDVRCustomRecognitonViewController alloc] initWithNibName:nil bundle:nil];
    tmpAudioViewController.clientSampleViewController = self;
    self.audioViewController = tmpAudioViewController;
    tmpAudioViewController.view.center=[UIApplication sharedApplication].keyWindow.center;
    
    [[UIApplication sharedApplication].keyWindow addSubview:_audioViewController.view];
    
}


- (IBAction)settingAction
{
    // 进入设置界面，配置相应的功能开关
	BDVRSettingViewController *tmpVRSettingViewController = [[BDVRSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *tmpNavController = [[UINavigationController alloc] initWithRootViewController:tmpVRSettingViewController];
	[self presentViewController:tmpNavController animated:YES completion:nil];

}

- (IBAction)sdkUIRecognitionAction
{
    
    // 创建识别控件
    BDRecognizerViewController *tmpRecognizerViewController = [[BDRecognizerViewController alloc] initWithOrigin:CGPointMake(9, 128) withTheme:[BDVRSConfig sharedInstance].theme];
    tmpRecognizerViewController.delegate = self;
    self.recognizerViewController = tmpRecognizerViewController;
    tmpRecognizerViewController.view.backgroundColor=[UIColor yellowColor];;
    
    // 设置识别参数
    BDRecognizerViewParamsObject *paramsObject = [[BDRecognizerViewParamsObject alloc] init];
    
    // 开发者信息，必须修改API_KEY和SECRET_KEY为在百度开发者平台申请得到的值，否则示例不能工作
    paramsObject.apiKey = API_KEY;
    paramsObject.secretKey = SECRET_KEY;
    
    // 设置是否需要语义理解，只在搜索模式有效
    paramsObject.isNeedNLU = [BDVRSConfig sharedInstance].isNeedNLU;
    
    // 设置识别语言
    paramsObject.language = [BDVRSConfig sharedInstance].recognitionLanguage;
    
    // 设置识别模式，分为搜索和输入
    paramsObject.recognitionProperty = [[BDVRSConfig sharedInstance].recognitionProperty intValue];
    
    // 开启联系人识别
    //paramsObject.enableContacts = YES;
    
    // 设置显示效果，是否开启连续上屏
    if ([BDVRSConfig sharedInstance].resultContinuousShow)
    {
        paramsObject.resultShowMode = BDRecognizerResultShowModeContinuousShow;
    }
    else
    {
        paramsObject.resultShowMode = BDRecognizerResultShowModeWholeShow;
    }
    
    // 设置提示音开关，是否打开，默认打开
    if ([BDVRSConfig sharedInstance].uiHintMusicSwitch)
    {
        paramsObject.recordPlayTones = EBDRecognizerPlayTonesRecordPlay;
    }
    else
    {
        paramsObject.recordPlayTones = EBDRecognizerPlayTonesRecordForbidden;
    }
    
    paramsObject.isShowTipAfter3sSilence = NO;
    paramsObject.isShowHelpButtonWhenSilence = NO;
    paramsObject.tipsTitle = @"可以使用如下指令记账";
    paramsObject.tipsList = [NSArray arrayWithObjects:@"我要记账", @"买苹果花了十块钱", @"买牛奶五块钱", @"第四行滚动后可见", @"第五行是最后一行", nil];
    
    [_recognizerViewController startWithParams:paramsObject];

}

- (IBAction)audioDataRecognitionAciton
{
    // 设置开发者信息，必须修改API_KEY和SECRET_KEY为在百度开发者平台申请得到的值，否则示例不能工作
    [[BDVoiceRecognitionClient sharedInstance] setApiKey:API_KEY withSecretKey:SECRET_KEY];
    // 设置是否需要语义理解，只在搜索模式有效
    [[BDVoiceRecognitionClient sharedInstance] setConfig:@"nlu" withFlag:[BDVRSConfig sharedInstance].isNeedNLU];
    
    /* 文件识别
     NSBundle *bundle = [NSBundle mainBundle];
     NSString* recordFile = [bundle pathForResource:@"example_localRecord" ofType:@"pcm" inDirectory:nil];
     self.fileRecognizer = [[BDVRFileRecognizer alloc] initFileRecognizerWithFilePath:recordFile sampleRate:16000 mode:[BDVRSConfig sharedInstance].voiceRecognitionMode delegate:self];
     
     int status = [self.fileRecognizer startFileRecognition];
     if (status != EVoiceRecognitionStartWorking) {
     [self logOutToManualResut:[NSString stringWithFormat:@"错误码：%d\r\n", status]];
     return;
     }*/
    
    // 数据识别
    self.rawDataRecognizer = [[BDVRRawDataRecognizer alloc] initRecognizerWithSampleRate:16000 property:[[BDVRSConfig sharedInstance].recognitionProperty intValue] delegate:self];
    int status = [self.rawDataRecognizer startDataRecognition];
    
    if (status != EVoiceRecognitionStartWorking) {
        [self logOutToManualResut:[NSString stringWithFormat:@"错误码：%d\r\n", status]];
        return;
    }
    NSThread* fileReadThread = [[NSThread alloc] initWithTarget:self
                                                       selector:@selector(fileReadThreadFunc)
                                                         object:nil];
    [fileReadThread start];
    // 数据识别
    
}

- (void)fileReadThreadFunc
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString* recordFile = [bundle pathForResource:@"example_localRecord" ofType:@"pcm" inDirectory:nil];
    
    int hasReadFileSize = 0;
    
    // 每次向识别器发送的数据大小，建议不要超过4k，这里通过计算获得：采样率 * 时长 * 采样大小 / 压缩比
    // 其中采样率支持16000和8000，采样大小为16bit，压缩比为8，时长建议不要超过1s
    int sizeToRead = 16000 * 0.080 * 16 / 8;
    while (YES) {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:recordFile];
        [fileHandle seekToFileOffset:hasReadFileSize];
        NSData* data = [fileHandle readDataOfLength:sizeToRead];
        [fileHandle closeFile];
        hasReadFileSize += [data length];
        if ([data length]>0)
        {
            [self.rawDataRecognizer sendDataToRecognizer:data];
            
        }
        else
        {
            [self.rawDataRecognizer allDataHasSent];
            break;
        }
    }
}

- (IBAction)uploadContactsAction:(UIButton *)sender {
    BDVRDataUploader *contactsUploader = [[BDVRDataUploader alloc] initDataUploader:self];
    self.contactsUploader = contactsUploader;
    [self.contactsUploader setApiKey:API_KEY withSecretKey:SECRET_KEY];
    NSString *jsonString = @"[{\"name\": \"test\",\"frequency\": 1},{\"name\": \"release\",\"frequency\": 2}]";
    [self.contactsUploader uploadContactsData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
}

#pragma mark - BDVRDataUploader delegate method
-(void)onComplete:(BDVRDataUploader *)dataUploader error:(NSError *)error
{
    if (error.code == 0) {
       
        
    } else {
      
    }
}

- (void)VoiceRecognitionClientWorkStatus:(int) aStatus obj:(id)aObj
{
    switch (aStatus)
    {
        case EVoiceRecognitionClientWorkStatusFinish:
        {
            if ([[BDVoiceRecognitionClient sharedInstance] getRecognitionProperty] != EVoiceRecognitionPropertyInput)
            {
                NSMutableArray *audioResultData = (NSMutableArray *)aObj;
                NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
                
                for (int i=0; i<[audioResultData count]; i++)
                {
                    [tmpString appendFormat:@"%@\r\n",[audioResultData objectAtIndex:i]];
                }
 
                [self logOutToManualResut:tmpString];
                
            }
            else
            {
              
                NSString *tmpString = [[BDVRSConfig sharedInstance] composeInputModeResult:aObj];
                [self logOutToManualResut:tmpString];
            }

            break;
        }
        case EVoiceRecognitionClientWorkStatusFlushData:
        {
            NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
            
            [tmpString appendFormat:@"%@",[aObj objectAtIndex:0]];
       
            [self logOutToManualResut:tmpString];
            
            
            break;
        }
        case EVoiceRecognitionClientWorkStatusReceiveData:
        {
            if ([[BDVoiceRecognitionClient sharedInstance] getRecognitionProperty] == EVoiceRecognitionPropertyInput)
            {
             
                NSString *tmpString = [[BDVRSConfig sharedInstance] composeInputModeResult:aObj];
                [self logOutToManualResut:tmpString];
            }
            
            break;
        }
        case EVoiceRecognitionClientWorkStatusEnd:
        {
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)VoiceRecognitionClientErrorStatus:(int) aStatus subStatus:(int)aSubStatus
{
    
}

- (void)VoiceRecognitionClientNetWorkStatus:(int) aStatus
{
    
}

#pragma mark - BDRecognizerViewDelegate

- (void)onEndWithViews:(BDRecognizerViewController *)aBDRecognizerView withResults:(NSArray *)aResults
{
    NSLog(@"%@",aResults);

    
    if ([[BDVoiceRecognitionClient sharedInstance] getRecognitionProperty] != EVoiceRecognitionPropertyInput)
    {
        // 搜索模式下的结果为数组，示例为
        // ["公园", "公元"]
        NSMutableArray *audioResultData = (NSMutableArray *)aResults;
        NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
        
        for (int i=0; i < [audioResultData count]; i++)
        {
            [tmpString appendFormat:@"%@\r\n",[audioResultData objectAtIndex:i]];
        }
 
    }
    else
    {
        // 输入模式下的结果为带置信度的结果，示例如下：
        //  [
        //      [
        //         {
        //             "百度" = "0.6055192947387695";
        //         },
        //         {
        //             "摆渡" = "0.3625582158565521";
        //         },
        //      ]
        //      [
        //         {
        //             "一下" = "0.7665404081344604";
        //         }
        //      ],
        //   ]
        NSString *tmpString = [[BDVRSConfig sharedInstance] composeInputModeResult:aResults];
        NSLog(@"00000000=%@＝＝%@",aResults,tmpString);
    
    }
}


- (void)logOutToManualResut:(NSString *)aResult
{
    NSLog(@"aResult=%@",aResult);
    [self addCell:@" " Content:(aResult==nil||[aResult length]==0)?@"👽":aResult Icon:@"head_default.png" IsMe:PersonTypeMe];

    
    NSRange range1 = [aResult rangeOfString:@"你好"];
    NSRange range11 = [aResult rangeOfString:@"您好"];
    NSRange range2 = [aResult rangeOfString:@"谁开发"];
    NSRange range3 = [aResult rangeOfString:@"叫什么"];
    NSRange range31 = [aResult rangeOfString:@"名字"];
    NSRange range32 = [aResult rangeOfString:@"你是"];
    NSRange range4 = [aResult rangeOfString:@"帮我找"];
    NSRange range41 = [aResult rangeOfString:@"找一下"];
    NSRange range5 = [aResult rangeOfString:@"你妹"];
    NSRange range6 = [aResult rangeOfString:@"傻逼"];
    NSRange range7 = [aResult rangeOfString:@"饿"];
    NSRange range71 = [aResult rangeOfString:@"酒店"];
    NSRange range72 = [aResult rangeOfString:@"餐厅"];
    NSRange range8 = [aResult rangeOfString:@"超市"];
    NSRange range9 = [aResult rangeOfString:@"旅游"];
    NSRange rangea0 = [aResult rangeOfString:@"多大"];
    NSRange rangea1 = [aResult rangeOfString:@"你是猪"];
    NSRange rangea2 = [aResult rangeOfString:@"我喜欢你"];
    NSRange rangea3 = [aResult rangeOfString:@"你爱我吗"];
    NSRange rangea4 = [aResult rangeOfString:@"干嘛"];
    NSRange rangea41 = [aResult rangeOfString:@"干什么"];
    NSRange rangea5 = [aResult rangeOfString:@"心情不好"];
    NSRange rangea6 = [aResult rangeOfString:@"是男是女"];
    NSRange rangea7 = [aResult rangeOfString:@"成为土豪"];
    NSRange rangea8 = [aResult rangeOfString:@"怎么"];
    NSRange rangea9 = [aResult rangeOfString:@"天理何在"];
    NSRange rangeb0 = [aResult rangeOfString:@"你猜"];
    NSRange rangeb1 = [aResult rangeOfString:@"还能不能愉快的玩耍了"];
    NSRange rangeb2 = [aResult rangeOfString:@"学声狗叫"];
    NSRange rangeb3 = [aResult rangeOfString:@"学猫叫"];
    NSRange rangeb4 = [aResult rangeOfString:@"天王盖地虎"];
    NSRange rangeb5 = [aResult rangeOfString:@"白日依山尽"];
    NSRange rangeb6 = [aResult rangeOfString:@"考试怎么办"];
    NSRange rangeb7 = [aResult rangeOfString:@"吃什么最补脑"];
    NSRange rangeb8 = [aResult rangeOfString:@"温柔"];
    NSRange rangeb9 = [aResult rangeOfString:@"最遥远的距离"];
    
    NSString *content=@"";
    if (aResult==nil) {
        content=@"亲，我耳朵不太好，能再说一遍吗？";
    }else if(range1.location!=NSNotFound||range11.location!=NSNotFound)
    {
        content=@"您好！";
    }else if(range2.location!=NSNotFound)
    {
        content=@"我是至平三人组团队开发的";
    }else  if(range3.location!=NSNotFound||range31.location!=NSNotFound||range32.location!=NSNotFound)
    {
        content=[NSString stringWithFormat:@"我叫%@",RISI];
    }else  if(range4.location!=NSNotFound||range41.location!=NSNotFound)
    {
        
        NSArray *array=[aResult componentsSeparatedByString:@"找"];
        if ([array count]==2) {
            content=@"好的你等等";
            [self getList:[array ObjectAtIndex:1]];
        }else
        {
            content=@"找什么";
        }
        
    }
    else  if(range5.location!=NSNotFound)
    {
        content=@"hello syster";
    }
    else  if(range6.location!=NSNotFound)
    {
        content=@"傻逼能吃吗？";

    }
    else  if(range7.location!=NSNotFound)
    {
        content=@"好的，请稍等";
        
        [self getList:@"餐厅"];
    }
    else  if(range71.location!=NSNotFound)
    {
        content=@"好的，请稍等";
        
        [self getList:@"酒店"];
    }
    else  if(range72.location!=NSNotFound)
    {
        content=@"好的，请稍等";
        
        [self getList:@"餐厅"];
    }
    else  if(range8.location!=NSNotFound)
    {
        content=@"好的，请稍等";
        
        [self getList:@"超市"];
    }else  if(range9.location!=NSNotFound)
    {
        content=@"好的，请稍等";
        
        [self getList:@"旅游"];
    }
    else  if(rangea0.location!=NSNotFound)
    {
        content=@"你猜";
    }
    else  if(rangea1.location!=NSNotFound)
    {
        content=@"那你是猪的朋友";
    }
    else  if(rangea2.location!=NSNotFound)
    {
        content=@"谢谢你";
    }
    else  if(rangea3.location!=NSNotFound)
    {
        content=@"嗯";
    }else  if(rangea4.location!=NSNotFound||rangea41.location!=NSNotFound)
    {
        content=@"我在思考";
    }else  if(rangea5.location!=NSNotFound)
    {
        content=@"笑话";
    }else  if(rangea6.location!=NSNotFound)
    {
        content=@"你猜";
    }else  if(rangea7.location!=NSNotFound)
    {
        content=@"去买彩票";
    }else  if(rangea8.location!=NSNotFound)
    {
        content=@"你猜";
    }else  if(rangea9.location!=NSNotFound)
    {
        content=@"那个叫天理的，粗来！";
    }else  if(rangeb0.location!=NSNotFound)
    {
        content=@"你猜我猜不猜";
    }else  if(rangeb1.location!=NSNotFound)
    {
        content=@"看样子是不能了";
    }else  if(rangeb2.location!=NSNotFound)
    {
        content=@"学声狗叫来听听";
    }else  if(rangeb3.location!=NSNotFound)
    {
        content=@"我不是猫";
    }else  if(rangeb4.location!=NSNotFound)
    {
        content=@"你是二百五";
    }else  if(rangeb5.location!=NSNotFound)
    {
        content=@"黄河入海流";
    }else  if(rangeb6.location!=NSNotFound)
    {
        content=@"先玩两天";
    }else  if(rangeb7.location!=NSNotFound)
    {
        content=@"亏";
    }else  if(rangeb8.location!=NSNotFound)
    {
        content=@"温柔就是你用筷子夹豆腐时的那种感觉";
    }else  if(rangeb9.location!=NSNotFound)
    {
        content=@"你转身，我们之间的距离就是整个赤道";
    }else
    {
        content=@"亲，我不太清楚您的意思？";
    }
    int ret = [synthesizer speak:content];
    
    if (ret != 0) {
        
        NSLog(@"+++++%d",ret);
    }
    [self addCell:RISI Content:content Icon:@"120.png" IsMe:PersonTypeOther];
    

}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
