//
//  BDRecognizerViewParamsObject.h
//  BDVoiceRecognitionClient
//
//  Created by Baidu on 13-9-25.
//  Copyright (c) 2013年 Baidu, Inc. All rights reserved.
//

// 头文件
#import <Foundation/Foundation.h>
#import "BDVoiceRecognitionClient.h"

// 枚举 - 弹窗中连续上屏效果开关
typedef enum
{
    BDRecognizerResultShowModeNotShow     = 0,      // 不显示结果
    BDRecognizerResultShowModeWholeShow,            // 仅显示最终结果
    BDRecognizerResultShowModeContinuousShow,       // 提供连续上屏效果（默认）
} TBDRecognizerResultShowMode;

// 枚举 - 播放提示音开关
typedef enum
{
    EBDRecognizerPlayTonesRecordForbidden = 0,                  // 不开启提示音
    EBDRecognizerPlayTonesRecordPlay = 1,                          //  提示音开启
} TBDRecognizerPlayTones;

// 枚举 - 设置识别语言
typedef enum
{
    BDVoiceRecognitionLanguageChinese = 0,
    BDVoiceRecognitionLanguageCantonese,
    BDVoiceRecognitionLanguageEnglish,
} TBDVoiceRecognitionLanguage;

// @class - BDRecognizerViewParamsObject
// @brief - 语音识别弹窗参数配置类
@interface BDRecognizerViewParamsObject : NSObject

@property (nonatomic, copy) NSString *productID;  // 向百度语音技术部申请
@property (nonatomic, copy) NSString *apiKey;  // 开发者apiKey，在百度开放平台申请
@property (nonatomic, copy) NSString *secretKey;  // 开发者secretKey，在百度开放平台申请
@property (nonatomic) BOOL isNeedNLU;  // 是否请求语义解析，只对搜索模式有影响
@property (nonatomic) TBDVoiceRecognitionLanguage language;   // 识别语言
@property (nonatomic) TBDVoiceRecognitionProperty recognitionProperty;  // 识别模式
@property (nonatomic) TBDVoiceRecognitionResourceType resourceType; // 资源类型
@property (nonatomic, copy) NSString *userAgent; // 用户标识（用于请求资源）
@property (nonatomic, copy) NSString *lightAppUID; // 轻应用UID
@property (nonatomic) BOOL disablePuncs;  // 是否禁止标点
@property (nonatomic) BOOL enableContacts; // 请求通讯录识别，需要通过BDSDataUploader上传通讯录数据，否则该项设置无效
@property (nonatomic) TBDRecognizerResultShowMode resultShowMode;   // 显示效果
@property (nonatomic) TBDRecognizerPlayTones recordPlayTones;   // 提示音开关
@property (nonatomic) BOOL isShowTipsOnStart; // 是否在对话框启动后展示引导提示，而不启动识别，默认关闭，若开启，请确认设置提示语列表
@property (nonatomic) BOOL isShowTipAfter3sSilence; // 引擎启动后3秒没检测到语音，是否在动效下方随机出现一条提示语。如果配置了提示语列表，则默认开启
@property (nonatomic) BOOL isShowHelpButtonWhenSilence; // 未检测到语音异常时，将“取消”按钮替换成帮助按钮。在配置了提示语列表后，默认开启
@property (nonatomic, copy) NSString *tipsTitle; // 提示语标题
@property (nonatomic, copy) NSArray *tipsList; // 提示语列表

@end // BDRecognizerViewParamsObject
