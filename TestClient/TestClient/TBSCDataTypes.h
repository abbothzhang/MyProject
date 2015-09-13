//
//  TBSCDataType.h
//  SocializeSDK
//
//  Created by albert on 14-11-26.
//  Copyright (c) 2014年 rocky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBSCDataTypes : NSObject
// id类型>10位
typedef unsigned long long LongIdType;
typedef unsigned long long LongTimeType;
typedef unsigned long long BigNumberType;
// 技术数据类型
typedef NS_ENUM(NSInteger, TBSCDataType) {
    TBSCDataTypeItem, // TBItem及其子类
    TBSCDataTypeArray,// NSArray及其子类
    TBSCDataTypePagedList,// 可翻页的list
    TBSCDataTypeNumber,// 数值类型
    TBSCDataTypeOperation // TBSCBatOperationResult(操作类型)及其子类
};
/**w网络状态类型***/
typedef enum {
    TBSCNetWorkNormal = 0,                //0---网络正常
    TBSCNetWorkUnNormal,                  //1---无网络
    TBSCNetWorkLoadFail,
    TBSCNetWorkLoginFail,
    TBSCNetWorkError,
    TBSCNetWorkNone
}TBSCNetWorkStatus;

//typedef enum {
//    TBSCFeedServiceTypeDefault = 0,         //0---默认为feed流类型
//    TBSCFeedServiceTypeNative           //1---宝贝插件类型
//}TBSCFeedServiceType;

typedef enum {
    TBSCCommentContentTextWithEmotion = 0,   //0---富文本，包括表情
    TBSCCommentContentPicture,               //1---图片展示
    TBSCCommentContentCommodityDetail        //2---宝贝展示
}TBSCCommentContentType;

typedef enum {
    TBSCfemale = 0,                 //0---女性
    TBSCmale                        //1---男性
}TBSCAccountSex;
// 业务数据类型
typedef NS_ENUM(NSInteger, TBSCBizDataType) {
    TBSCBizDataTypeNULL, // 无效业务类型
    
};



//评论操作者类型
typedef enum{
    
    TBSCCommentCreater, // 评论作者
    
    TBSCFeedCreater,    // Feed作者
    
    TBSCAdminster   // 评论管理员（小二）
    
} TBSCCommenterType;

//场景类型
typedef enum{
    
    TBSCCommentWeitao, // 微淘场景
    
    TBSCCommentHaohuo,    // 有好货场景
    
    TBSCCommentOnly      //只有Inputbar输入框
    
} TBSCCommentSceneType;




@end
