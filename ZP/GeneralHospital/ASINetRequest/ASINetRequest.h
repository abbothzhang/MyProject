//
//  ASINetRequest.h
//  GeneralHospital
//
//  Created by 夏科杰 on 14-4-4.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import "sqlite3.h"
#import "NZAlertView.h"
#import "MBProgressHUD.h"
#import "UIColor+StyleColor.h"
#import "RTSpinKitView.h"
typedef enum NetWorkType {
    NetWorkTypeS = 0,
    NetWorkTypeSS,
    NetWorkTypeAS,
    NetWorkTypeASS
} NetWorkType;

typedef enum EncryptType {
    UnEncryption = 0,
    Encryption
} EncryptType;

typedef enum ASICacheType {
    UnCache = 0,
    Cache
} ASICacheType;

typedef enum NoticeType {
    NoticeType0 = 0,
    NoticeType1,
    NoticeType2,
    NoticeType3,
    NoticeType4
} NoticeType;


typedef enum ProcessType {
    ProcessType1 = 0,
    ProcessType2,
    ProcessType3,
    ProcessType4,
    ProcessType5,
    ProcessType6,
    ProcessType7,
    ProcessType8,
    ProcessType9,
    ProcessType10,
    ProcessType11,
    ProcessUnType
} ProcessType;

typedef enum HttpType{
    HttpPost=0,
    HttpGet
}HttpType;

typedef enum ClientType {
    AndriodGeneralType = 1,//android大众版
    AndriodDoctorType,     //android医护版
    IphoneGeneralType,     //ios大众版
    IphoneDoctorType,      //ios医护版
    Win8GeneralType,       //win8大众版
    Win8DoctorType         //win8医护版
} ClientType;

typedef void (^ASINetBlock)(NSDictionary*);
typedef void (^ASINetError)(int);
@interface ASINetRequest : ASIFormDataRequest
{
    __block id SelfMess;
    BOOL       CanReturn;
    BOOL       CanCancel;
}
-(void)setASIPostDict:(NSDictionary* )postDict
              NameKey:(NSString*     )nameKey
            FilesData:(id            )filesData
            CanCancel:(BOOL          )canCancel
          SetHttpType:(HttpType      )httpType
            SetNotice:(NoticeType    )noticeType
           SetNetWork:(NetWorkType   )netWorkType
           SetProcess:(ProcessType   )processType
           SetEncrypt:(EncryptType   )encryptType
             SetCache:(ASICacheType  )cacheType
             NetBlock:(ASINetBlock   )netBlock
             NetError:(ASINetError   )netError;

-(void)setASIPostDict:(NSDictionary* )postDict
              ApiName:(NSString*     )apiName
              KeyName:(NSString*     )keyName
            FilesData:(id            )filesData
            CanCancel:(BOOL          )canCancel
          SetHttpType:(HttpType      )httpType
            SetNotice:(NoticeType    )noticeType
           SetNetWork:(NetWorkType   )netWorkType
           SetProcess:(ProcessType   )processType
           SetEncrypt:(EncryptType   )encryptType
             SetCache:(ASICacheType  )cacheType
             NetBlock:(ASINetBlock   )netBlock
             NetError:(ASINetError   )netError;

-(void)setASIPostDict:(NSDictionary* )postDict
              ApiName:(NSString*     )apiName
            CanCancel:(BOOL          )canCancel
          SetHttpType:(HttpType      )httpType
            SetNotice:(NoticeType    )noticeType
           SetNetWork:(NetWorkType   )netWorkType
           SetProcess:(ProcessType   )processType
           SetEncrypt:(EncryptType   )encryptType
             SetCache:(ASICacheType  )cacheType
             NetBlock:(ASINetBlock   )netBlock
             NetError:(ASINetError   )netError;
@end
