//
//  ZHSocialResult.h
//  TestClient
//
//  Created by albert on 15/9/13.
//  Copyright (c) 2015年 penghui.zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHSocialResult : NSObject

// 试妆错误代码
typedef enum {
    //common
    kMirrorMakeUpSuccess = 1,
    kMirrorMakeUpIsSupportError,
    
    //makeup
    kMirrorMakeUpOutOfMemoryErrorType,
    kMirrorMakeUpInitDataErrorType,
    kMirrorMakeUpRequestTimedOutErrorType,
    kMirrorMakeUpConnectionFailureErrorType,
    kMirrorMakeUpDownloadFailedErrorType,
    kMirrorMakeUpSetParamErrorType,
    kMirrorMakeUpUnKnowErrorType,
    
    //network
    kMirrorErrorTypeNetWork,//网络错误
    kMirrorErrorTypeNetWorkApinil,//网络访问的api为空
    kMirrorErrorTypeNetWorkMtopError,
    kMirrorErrorTypeNetWorkDataNull,//从网络获取到的数据为空
    
} kMirrorErrorType;

@end
