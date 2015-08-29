//
//  MirrorMakeUpManager.m
//  MirrorSDK
//
//  Created by albert on 15/7/2.
//  Copyright (c) 2015年 Taobao. All rights reserved.
//

#import "MirrorMakeUpManager.h"
#import "MirrorNetworkParam.h"
#import "MirrorNetWorkDefaultAdapter.h"
#import "MirrorMulticastDelegate.h"
#import "MirrorDiskCache.h"
#import "MirrorDownload.h"
#import "MirrorMakeUpCenter.h"
#import "MirrorMaterialManager.h"
#import "MirrorMaterialUseCacheManager.h"
#import "MirrorMaterialUnUseCacheManager.h"
#import "MirrorFileUtil.h"


#define MIRROR_USERDEFAULT_SUPPORTMAKEUP @"Mirror_PLUGIN_USERDEFAULT_SUPPORTMAKEUP"
#define MIRROR_USERDEFAULT_SUPPORTMAKEUP_UPDATE_TIME @"MIRROR_USERDEFAULT_SUPPORTMAKEUP_UPDATE_TIME"
#define MIRROR_ALGORITHMS_MAKEUP_VERSION @"2.0"//上妆的算法so版本

//TODO:SDWebDataManager需要

@interface MirrorMakeUpManager()<MirrorDownloaderDelegate,MirrorGetMaterialDelegate>

@property (nonatomic,strong) MirrorNetWorkDefaultAdapter            *netWorkManager;
@property (nonatomic,strong) NSString                               *deviceSupportMakeUp;

//6M的人脸定位模型
@property (nonatomic,strong) NSString                               *cacheKeyFaceModel;
@property (nonatomic,strong) MirrorNetWorkDefaultAdapter            *getDownLadUrlNetWorkManager;
@property (nonatomic,strong) MirrorDownload                         *downloadManager;
@property (nonatomic,strong) MirrorCallback                         makeUpCallBack;

@property (nonatomic,strong) MirrorMaterialManager                  *materialManager;



@end

@implementation MirrorMakeUpManager

- (void)clear {
    _netWorkManager = nil;
    _deviceSupportMakeUp = nil;
    
    _cacheKeyFaceModel = nil;
    _getDownLadUrlNetWorkManager = nil;
    _downloadManager = nil;
    _makeUpCallBack = nil;
    
    [_materialManager clear];
    _materialManager = nil;
    
}

- (id)init {
    if (self = [super init]) {
        _multicastDelegate = (MirrorMulticastDelegate<MirrorMakeUpManagerDelegate> *)[[MirrorMulticastDelegate alloc] init];
        
    }
    return self;
}

+(NSString *)getOSVersion{
    return MIRROR_ALGORITHMS_MAKEUP_VERSION;
}

+(void)isSupportMakeUpWithMakeUpType:(MirrorMakeUpType)makeUpType successCallBack:(MirrorNetworkSucessBlock)successCallBack failCallBack:(MirrorNetworkFailedBlock)failCallBack{
    
    //如果设备在黑名单里，那么提示设备不支持
    NSString *blackDeviceListPath = [[NSBundle mainBundle] pathForResource:@"tbmirror_black_device_list" ofType:@"plist"];
    NSDictionary *plistDic = [[NSDictionary alloc] initWithContentsOfFile:blackDeviceListPath];
    NSArray *blackDeviceList = [plistDic objectForKey:@"black_device_list"];
    NSString *platform = [MirrorUtils getCurrentPlatForm];
    if ([blackDeviceList containsObject:platform]) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"设备在黑名单里",@"result", nil];
        successCallBack(dic);
        return;
    }
    //ios系统版本低于7.0不支持
    if ([MirrorUtils getIOSVersion] < 7.0f) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios系统版本低于7.0",@"result", nil];
        successCallBack(dic);
        return;
    }
    //加时间戳，在12小时后才去拉网络访问
    NSTimeInterval lastTime = [[[NSUserDefaults standardUserDefaults] valueForKey:MIRROR_USERDEFAULT_SUPPORTMAKEUP_UPDATE_TIME] doubleValue];
    NSTimeInterval nowTime = [NSDate timeIntervalSinceReferenceDate];
    if (lastTime == 0) {
        [MirrorMakeUpManager updateIsSupportFormServerWithMakeUpType:makeUpType successCallBack:successCallBack failCallBack:failCallBack];
    }else{
        BOOL isOver12Hour = nowTime - lastTime > 12*60*60;
        if (isOver12Hour) {
            [MirrorMakeUpManager updateIsSupportFormServerWithMakeUpType:makeUpType successCallBack:successCallBack failCallBack:failCallBack];
        }
    }
    
    
    
    
    
}

+(void)updateIsSupportFormServerWithMakeUpType:(MirrorMakeUpType )makeUpType successCallBack:(MirrorNetworkSucessBlock)successCallBack failCallBack:(MirrorNetworkFailedBlock)failCallBack{
    //先读缓存，缓存有的话马上回调返回，再去服务器端拉值
    //如果读缓存返回值了，那么拉服务器端后只设置值，不再重复返回
    //如果缓存没有，即没有回调返回，则拉服务器端值后再回调返回
    NSString __block *deviceSupportMakeUp = [[NSUserDefaults standardUserDefaults] valueForKey:MIRROR_USERDEFAULT_SUPPORTMAKEUP];
    if (!deviceSupportMakeUp || [deviceSupportMakeUp isEqualToString:@""]) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:deviceSupportMakeUp,@"result", nil];
        successCallBack(dic);
    }
    
    //从服务器端查询
    NSMutableDictionary *businessParam = [[NSMutableDictionary alloc] initWithCapacity:3];
    //入参：化妆和试眼镜区分、手机型号、操作系统型号、算法版本
    [businessParam setValue:@(makeUpType) forKey:@"type"];
    [businessParam setValue:[MirrorUtils getCurrentPlatForm] forKey:@"phoneType"];
    [businessParam setValue:[NSString stringWithFormat:@"%f",[MirrorUtils getIOSVersion]] forKey:@"osVersion"];
    [businessParam setValue:MIRROR_ALGORITHMS_MAKEUP_VERSION forKey:@"soVersion"];
    
    MirrorNetworkParam *param = [[MirrorNetworkParam alloc] init];
    param.businessParam = businessParam;
    param.apiVersion = @"1.0";
    MirrorNetWorkDefaultAdapter *netWorkManager = [[MirrorNetWorkDefaultAdapter alloc] init];
    [netWorkManager request:Mirror_API_ISSUPPORT_MAKEUP withParam:param onSuccess:^(NSDictionary *dic) {
        if (dic == nil) {
            return;
        }
        NSDictionary *data = [dic objectForKey:@"data"];
        if (data) {
            if (deviceSupportMakeUp == nil || [deviceSupportMakeUp isEqualToString:@""]) {
                deviceSupportMakeUp = [NSString stringWithFormat:@"%@",[data objectForKey:@"result"]];
                [[NSUserDefaults standardUserDefaults] setValue:deviceSupportMakeUp forKey:MIRROR_USERDEFAULT_SUPPORTMAKEUP];
                
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:deviceSupportMakeUp,@"result", nil];
                successCallBack(dic);
            }else{
                deviceSupportMakeUp = [NSString stringWithFormat:@"%@",[data objectForKey:@"result"]];
                [[NSUserDefaults standardUserDefaults] setValue:deviceSupportMakeUp forKey:MIRROR_USERDEFAULT_SUPPORTMAKEUP];
            }
            
        }
    } onFailed:^(NSInteger errorCode,NSString *errorMsg) {
        failCallBack(errorCode,errorMsg);
    }];
}

//外部在试妆前都要先调用这个方法
/**
 init后返回成功或者失败回调
 1.下载6M的算法库
 2.调用engine->init方法判断是否初始化成功
 
 
 **/

#pragma mark - init
-(void)initialize{
    if ([self isFaceModelDownLoad]) {
        NSString *faceModelPath = [self getFaceModelPath];
        NSData *faceModelData = [NSData dataWithContentsOfFile:faceModelPath];
         MirrorMakeUpManager __weak *weakSelf = self;
        [[MirrorMakeUpCenter sharedCenter] initializer:faceModelData completed:^(BOOL finished, NSError *error) {
            MirrorMakeUpManager __strong *strongSelf = weakSelf;
            if (finished) {
                [strongSelf.multicastDelegate initSuccess];
            }else{
                [strongSelf.multicastDelegate initFailedErrorCode:error.code errMsg:error.domain];
            }
        }];
    }else{
        MirrorMakeUpManager __weak *weakSelf = self;
        [self.multicastDelegate initWillDownLoadFaceModelWithCallBack:^(BOOL shouldDo) {
            MirrorMakeUpManager __strong *strongSelf = weakSelf;
            if (shouldDo) {
                [strongSelf downLoadFaceModel];
            }
        }];
        
    }
}



-(BOOL)isFaceModelDownLoad{
    return [[MirrorDiskCache sharedCache] hasObjectForKey:self.cacheKeyFaceModel];
}

//
-(NSString *)getFaceModelPath{
    return [[MirrorDiskCache sharedCache] filePathForKey:self.cacheKeyFaceModel];
}

//
-(void)downLoadFaceModel{
    NSMutableDictionary *businessParam = [[NSMutableDictionary alloc] initWithCapacity:1];
    [businessParam setValue:MIRROR_ALGORITHMS_MAKEUP_VERSION  forKey:@"version"];
    
    MirrorNetworkParam *param = [[MirrorNetworkParam alloc] init];
    param.businessParam = businessParam;
    param.apiVersion = @"1.0";
    __weak __typeof(self) weakSelf = self;
    [self.getDownLadUrlNetWorkManager request:Mirror_API_GET_FACEMODEL withParam:param onSuccess:^(NSDictionary *dic) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        //下载faceModel
        NSDictionary *data = [dic objectForKey:@"data"];
        NSString *fileUrl = [data objectForKey:@"fileUrl"];
        //                NSString *fileUrl = @"http://albertfile.sinaapp.com/face_all_data.dat";
        strongSelf.downloadManager = [[MirrorDownload alloc] initWithURL:[NSURL URLWithString:fileUrl]];
        strongSelf.downloadManager.key = @"downLoad1";
        [strongSelf.downloadManager startWithDelegate:strongSelf];
        
        
    } onFailed:^(NSInteger errorCode, NSString *errorMsg) {
       __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.multicastDelegate downLoadFaceModelFailErrorCode:errorCode errorMsg:errorMsg];
    }];
    
}


- (void)makeUpWithArrayData:(NSDictionary *)data materialType:(MirrorMaterialType)materialType resultCallBack:(MirrorCallback)resultCallBack{
    self.makeUpCallBack = resultCallBack;
    self.materialManager = [[MirrorMaterialManager alloc] initWithType:materialType];
    self.materialManager.delegate = self;
    [self.materialManager getMaterialWithMakeUpArrayData:data osVersion:MIRROR_ALGORITHMS_MAKEUP_VERSION];
    
}

//
- (BOOL)beautyWithArrayData:(NSArray *)arrayData {
    return [[MirrorMakeUpCenter sharedCenter] setBeautyArray:arrayData];
}




- (void)addDelegate:(id)delegate
{
    [_multicastDelegate addDelegate:delegate];
}

- (void)removeDelegate:(id)delegate
{
    [_multicastDelegate removeDelegate:delegate];
}

- (void)removeAllDelegate
{
    [_multicastDelegate removeAllDelegates];
}

#pragma mark - 
-(void)cancelDownload{
    if (self.downloadManager) {
        [self.downloadManager cancel];
    }
}

- (void)pauseDownload {
    if (self.downloadManager) {
        [self.downloadManager pause];
    }
}

- (void)resumeDownload {
    if (self.downloadManager) {
        [self.downloadManager resume];        
    }
}

#pragma mark - MirrorDownloaderDelegate
-(void)MirrorDownloadProgress:(float)progress Percentage:(NSInteger)percentage MirrorDownload:(MirrorDownload *)MirrorDownload{
    [self.multicastDelegate downLoadFaceModelProgress:progress Percentage:percentage];
}

- (void)MirrorDownloadFinished:(NSData *)fileData MirrorDownload:(MirrorDownload *)mirrorDownload{
    self.downloadManager = nil;
    //---解压缩---
    if ([mirrorDownload.fileName hasSuffix:@"zip"]) {
        NSData *tempData = [MirrorFileUtil unZipDataWithzipData:fileData];
        if (tempData == nil) {
            [self.multicastDelegate initFailedErrorCode:kMirrorMakeUpInitDataErrorType errMsg:@"解压缩失败"];
            return;
        }else{
            fileData = tempData;
        }
    }
    //---解压缩结束---
    
    
    [[MirrorDiskCache sharedCache] cacheObject:fileData forKey:self.cacheKeyFaceModel];
    [self.multicastDelegate downLoadFaceModelSuccess];
    __weak __typeof(&*self)weakSelf = self;
    [[MirrorMakeUpCenter sharedCenter] initializer:fileData completed:^(BOOL finished, NSError *error) {
        MirrorMakeUpManager __strong *strongSelf = weakSelf;
        if (finished) {
            [strongSelf.multicastDelegate initSuccess];
        }
        else {
            [strongSelf.multicastDelegate initFailedErrorCode:error.code errMsg:error.domain];
        }
    }];

}

-(void)MirrorDownloadFail:(NSError*)error MirrorDownload:(MirrorDownload *)MirrorDownload{
    [self.multicastDelegate initFailedErrorCode:kMirrorMakeUpDownloadFailedErrorType errMsg:@"下载失败"];
}

#pragma mark - MirrorGetMaterialDelegate
-(void)startGetMaterialFromServer{
    
}
//素材准备好，可以上妆了 result为makeupModel的array
-(void)getMaterialSuccess:(NSArray*)result{
    
    BOOL isMakeUpSuccess = [[MirrorMakeUpCenter sharedCenter] setMakeUpArray:result];
    if (self.makeUpCallBack) {
        if (isMakeUpSuccess) {
            self.makeUpCallBack(YES,kMirrorMakeUpSuccess,nil);
        }else{
            self.makeUpCallBack(NO,kMirrorMakeUpUnKnowErrorType,@"设置上妆参数失败");
        }
    }

    
}
-(void)getMaterialFailWithMsg:(NSString *)msg{
    if (self.makeUpCallBack) {
        self.makeUpCallBack(NO,kMirrorMakeUpDownloadFailedErrorType,@"下载素材失败");
    }
}

#pragma mark - getter
-(NSString *)cacheKeyFaceModel{
    if (!_cacheKeyFaceModel) {
        _cacheKeyFaceModel = [NSString stringWithFormat:@"MIRROR_CACHE_DIRECTORY_FACEMODEL_%@",MIRROR_ALGORITHMS_MAKEUP_VERSION];
    }
    return _cacheKeyFaceModel;
}

-(MirrorNetWorkDefaultAdapter *)getDownLadUrlNetWorkManager{
    if (!_getDownLadUrlNetWorkManager) {
        _getDownLadUrlNetWorkManager = [[MirrorNetWorkDefaultAdapter alloc] init];
    }
    return _getDownLadUrlNetWorkManager;
}


//


-(void)dealloc{
    [self clear];
}






@end
