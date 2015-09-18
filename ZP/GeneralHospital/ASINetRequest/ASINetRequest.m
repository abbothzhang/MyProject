//
//  ASINetRequest.m
//  GeneralHospital
//
//  Created by 夏科杰 on 14-4-4.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

/*
 
 
 TX	String	是	api接口代码
 T	String	是	客户端类型：客户端类型代码对照表
 V	String	是	客户端版本
 S	String	否	用户会话标示（session_id）
 D	String	否	设备号
 K	String	是	验证代码（该参数放在http请求的header中）
 
 
T:
 
 客户端类型代码	描述
 1	android大众版
 2	android医护版
 3	ios大众版
 4	ios医护版
 5	win8 store患者版
 6	windows phone
 */
#define DEBUGTYPE YES  //YES:关闭DEBUG  NO:开启DEBUG
#define DEBUGINFO YES  //YES:关闭DEBUG  NO:开启DEBUG
#import "ASINetRequest.h"
#import "GlobalHead.h"
@implementation ASINetRequest

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
             NetError:(ASINetError   )netError
{
    [self setTimeOutSeconds:100];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    [self setShouldContinueWhenAppEntersBackground:YES];
#endif
    
    if ([filesData isKindOfClass:[NSData class]]) {
        
        [self addData:filesData withFileName:@"image.png" andContentType:@"" forKey:nameKey];
    }else{
        
        [self addData:[UIImagePNGRepresentation(filesData) length]>102400?UIImageJPEGRepresentation(filesData,0.7):UIImagePNGRepresentation(filesData) withFileName:@"image.png" andContentType:@"" forKey:nameKey];
    }
    [self setASIPostDict:postDict
                 ApiName:nameKey
               CanCancel:canCancel
             SetHttpType:httpType
               SetNotice:noticeType
              SetNetWork:netWorkType
              SetProcess:processType
              SetEncrypt:encryptType
                SetCache:cacheType
                NetBlock:netBlock
                NetError:netError];
}

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
             NetError:(ASINetError   )netError
{
    [self setTimeOutSeconds:100];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    [self setShouldContinueWhenAppEntersBackground:YES];
#endif
    NSLog(@"%@",filesData);
    if ([filesData isKindOfClass:[NSData class]]) {
       
        [self addData:filesData withFileName:@"image.png" andContentType:@"File" forKey:keyName];
    }else{
        
        [self addData:[UIImagePNGRepresentation(filesData) length]>102400?UIImageJPEGRepresentation(filesData,0.7):UIImagePNGRepresentation(filesData) withFileName:@"image.png" andContentType:@"" forKey:keyName];
    }
    [self setASIPostDict:postDict
                 ApiName:apiName
               CanCancel:canCancel
             SetHttpType:httpType
               SetNotice:noticeType
              SetNetWork:netWorkType
              SetProcess:processType
              SetEncrypt:encryptType
                SetCache:cacheType
                NetBlock:netBlock
                NetError:netError];
}

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
             NetError:(ASINetError   )netError
{
    
    CanReturn=YES;
    CanCancel=canCancel;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"process_begin" object:[NSString stringWithFormat:@"%d",5]];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(notificationSelector:)
                                                 name: @"process_cancel"
                                               object: nil];
    
    switch (httpType) {
        case HttpPost:
        {
            if (postDict!=nil) {
//                NSLog(@"postDict=%@",postDict);
                if (apiName!=nil&&[apiName isEqualToString:@"submit"]) {
                    [self addPostValue:[self ChangeIntoJSON:postDict] forKey:@"data"];
                }else
                {
                    for (NSString *string in [postDict allKeys]) {
                        [self addPostValue:[postDict objectForKey:string] forKey:string];
                        
                    }
                }
            }else{
                NSLog(@"postDict 为空！！！！");
            }
        }
            break;
        case HttpGet:
        {
            [self setRequestMethod:@"GET"];
        }
            break;
            
        default:
            break;
    }
//     NSLog(@"G_UseDict=%@",G_UseDict);
    [self addRequestHeader:@"principal" value:[NSString stringWithFormat:@"%@",[G_UseDict objectForKey:@"principal"]]];
//    NSLog(@"G_UseDict=%@",[G_UseDict objectForKey:@"principal"]);
    switch (cacheType) {
        case Cache:
            
            break;
        case UnCache:
            
            break;
            
        default:
            break;
    }

        //选择网络环境
    switch (netWorkType) {
        case NetWorkTypeS:
            [self startSynchronous];
            break;
        case NetWorkTypeSS:
        {
            [self setValidatesSecureCertificate:NO];
            [self startSynchronous];
        }
            break;
        case NetWorkTypeAS:
            [self startAsynchronous];
            break;
        case NetWorkTypeASS:
        {
            [self setValidatesSecureCertificate:NO];
            [self startAsynchronous];
        }
            break;
        default:
            break;
    }
    
    [self setStartedBlock:^{
    
    }];
    [self setCompletionBlock:^{
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self processStop];
            });
        });
        
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            NSDictionary *dict = [[self GetData:noticeType] copy];
            NSLog(@"返回DIC   %@", dict);
            if (CanReturn&&netBlock&&dict!=nil) {
                netBlock(dict);
            }else
            {
                if (netError) {
                    netError(1);
                }
            }
        });
    }];
    [self setFailedBlock:^{
        
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            // 主线程执行：
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self processStop];
            });
            if (!CanReturn) {
                return;
            }
            if (netError) {
                netError(1);
            }
            Reachability * reachWeb = [Reachability reachabilityWithHostname:@"www.baidu.com"];
            Reachability * reachHost = [Reachability reachabilityWithHostname:@"121.40.146.235"];
            if(![reachWeb isReachable]&&![reachHost isReachable])
            {
                [self ShowNotice:@"网络断开"
                      setContent:@"请检查您的网络连接！"
                       setResult:NZAlertStyleError
                         setType:noticeType];
            }else if ([reachWeb isReachable]&&![reachHost isReachable]) {
                [self ShowNotice:@"系统提示"
                      setContent:@"系统正在维护中。。。"
                       setResult:NZAlertStyleError
                         setType:noticeType];
            }else{
                [self ShowNotice:@"失败提示"
                      setContent:@"请求超时！"
                       setResult:NZAlertStyleError
                         setType:noticeType];
            }

            
        });
        
//        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
//            
//        });
    }];
    
}

/**
 *  关闭菊花
 */
-(void)processStop
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"process_begin" object:@201];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"process_cancel" object:nil];
}
/**
 *  请求取消
 *
 */
-(void)notificationSelector:(NSNotification *)notification
{
    switch ([[notification object] intValue]) {
        case 1:
        {
            [self cancel];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"process_begin" object:@202];
        }
            break;
        default:
            break;
    }
    NSLog(@"-----------------------------%@",[notification object]);
}

-(NSDictionary* )GetData:(NoticeType)noticeType
{
    NSDictionary* returnDict=[self responseDictionary];
    NSLog(@"%@",returnDict);
    NSLog(@"\n\n%@\n\n",[UcmedViewStyle replaceUnicode:[NSString stringWithFormat:@"%@",returnDict]]);
    NSAssert([[returnDict objectForKey:@"flag"] intValue]==1||DEBUGINFO,
             @"\n----------------------------------------------------------------------\n\n\n\ncode:%@\n\ninfo:%@\n\n报错了！！！！！！！！\n\ncustominfo:%@\n\n----------------------------------------------------------------------\n",[returnDict ObjectForKey:@"flag"],[returnDict ObjectForKey:@"message"],[returnDict ObjectForKey:@"message"]);
    if ([[returnDict objectForKey:@"flag"] intValue]!=1) {
        
#ifdef DEBUG
        [self ShowNotice:@"失败提示"
              setContent:[returnDict objectForKey:@"message"]
               setResult:NZAlertStyleError
                 setType:noticeType];
#else
        [self ShowNotice:@"失败提示"
              setContent:[returnDict objectForKey:@"message"]
               setResult:NZAlertStyleError
                 setType:noticeType];
#endif
        return nil;
    }
    
    return [self responseDictionary];
}



//现实提示
-(void)ShowNotice:(NSString *)title
       setContent:(NSString *)content
        setResult:(NZAlertStyle)result
          setType:(NoticeType)type
{
    switch (type) {
        case NoticeType0:
        {
            NZAlertView *alert = [[NZAlertView alloc] initWithStyle:result
                                                     //statusBarColor:[UIColor purpleColor]
                                                              title:title
                                                            message:content
                                                           delegate:self];
            [alert show];
        }
            break;
        case NoticeType1:
        {
            [self ShowMBP:title message:content setType:result];
        }
            break;
        case NoticeType2:
        {
            
        }
            break;
        case NoticeType3:
        {
            
        }
            break;
        case NoticeType4:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)ShowMBP:(NSString *)title message:(NSString *)content setType:(NZAlertStyle)type
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.labelText = title;
    hud.detailsLabelText=content;
    NSString *path = @"NZAlertView-Icons.bundle/";
    
    switch (type) {
        case NZAlertStyleError:
        {
            path = [path stringByAppendingString:@"AlertViewErrorIcon"];
            
           // hud.labelColor=[UIColor errorColor];
           // hud.detailsLabelColor=[UIColor errorColor];
        }
            break;
            
        case NZAlertStyleInfo:
        {
            path = [path stringByAppendingString:@"AlertViewInfoIcon"];
            
           // hud.labelColor=[UIColor infoColor];
           // hud.detailsLabelColor=[UIColor infoColor];
        }
            break;
            
        case NZAlertStyleSuccess:
        {
            path = [path stringByAppendingString:@"AlertViewSucessIcon"];
            
           // hud.labelColor=[UIColor successColor];
           // hud.detailsLabelColor=[UIColor successColor];
        }
            break;
        default:
            break;
    }
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:path]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hide:YES afterDelay:2.0];
}

-(NSString* )ChangeIntoJSON:(NSDictionary* )PostDict
{
    

    if ([NSJSONSerialization isValidJSONObject:PostDict])
    {
        NSError *jError;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:PostDict options:NSJSONWritingPrettyPrinted error:&jError];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"json转换结果=%@\n\n",jsonString);
        return jsonString;
    }else{
        [GeneralClass Assert:@"post 数据是不是json数据请检查入参！！！"];
    }
    return nil;
}

@end
