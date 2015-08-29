//
//  MirrorMakeUpController.m
//  Mirror
//
//  Created by albert on 15/4/21.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import "MirrorMaterialUseCacheManager.h"
//#import "MirrorNetWorkDefaultAdapter.h"
//#import "MirrorNetworkParam.h"
#import "MirrorDownload.h"
#import "MirrorMakeUpModel.h"
#import "MirrorDiskCache.h"
#import "MirrorUtils.h"
//#import "SDWebImageManager.h"
#import "MirrorFileUtil.h"


@interface MirrorMaterialUseCacheManager()<MirrorDownloaderDelegate>

//@property (nonatomic,strong) MirrorNetWorkDefaultAdapter            *netWorkManager;
@property (nonatomic,strong) MirrorDownload                         *downloadManager;
@property (nonatomic,strong) NSMutableArray                         *makeupModelArray;
@property (nonatomic) NSUInteger                                    makeUpArrayCount;

@property (nonatomic,weak) NSString                                 *osVersion;
//@property (nonatomic,strong) SDWebImageManager                      *imageManager;



@end

@implementation MirrorMaterialUseCacheManager

-(instancetype)init{
    self = [super init];
    if (self) {

    }
    
    return self;
}

-(void)getMaterialWithMakeUpArrayData:(NSDictionary*)data osVersion:(NSString *)version{
    //参数解析
    NSArray *makeUpArray = [data objectForKey:@"makeuplist"];//makeuplist
    
    if ([makeUpArray isKindOfClass:[NSArray class]] && makeUpArray.count > 0) {
        //数据准备
        self.osVersion = version;
        _makeUpArrayCount = 0;
        
        NSMutableArray *requstArray = [[NSMutableArray alloc] initWithCapacity:makeUpArray.count];
        for (int i = 0; i < makeUpArray.count; i++) {
            NSDictionary *makeupDic = [makeUpArray objectAtIndex:i];
            MirrorMakeUpModel *model = [[MirrorMakeUpModel alloc] init];
            model.cspuId = [NSString stringWithFormat:@"%@",[makeupDic objectForKey:@"cspuid"]];
            //model.cspuId = @"124-20150713-54896539";
            model.weight = [[makeupDic objectForKey:@"weight"] doubleValue];
            //判断model是否有缓存,如果有缓存，先用缓存，再去请求看是否有更新，如果有更新，再下载更新的素材 key为soVersion+cspuId
            NSString *modelCacheKey = [self modelCacheKeyWithCspuId:model.cspuId];
            BOOL hasModel = [[MirrorDiskCache sharedCache] hasObjectForKey:modelCacheKey];
            if (hasModel) {
                model.isCache = YES;
                NSData *modelData = [[MirrorDiskCache sharedCache] objectForKey:modelCacheKey];
                MirrorMakeUpModel *makeUpModel = [NSKeyedUnarchiver unarchiveObjectWithData:modelData];
                // 透传前段attr属性，避免cache覆盖重写 Fixed by 龙冥
                makeUpModel.attribute = [makeupDic objectForKey:@"attrs"];
                [self.makeupModelArray addObject:makeUpModel];
            }
            else {
                _makeUpArrayCount++;
                model.isCache = NO;
                model.attribute = [makeupDic objectForKey:@"attrs"];
            }
            [requstArray addObject:model];
        }
        
        if (_makeUpArrayCount == 0) {
            MirrorMakeUpModel *model = [self isNeedDownLoadGlassBgImgWithModelArray:self.makeupModelArray];
            if (model) {
                [self downLoadGlassBgImgWithMakeUpModel:model];
            }else{
                if (self.delegate&&[self.delegate respondsToSelector:@selector(getMaterialSuccess:)]) {
                    [self.delegate getMaterialSuccess:self.makeupModelArray];
                }
            }
        }
        [self getMaterialWithMakeUpModelArray:requstArray osVersion:version];
    }
    else if ([self.delegate respondsToSelector:@selector(getMaterialSuccess:)]) {
        [self.delegate getMaterialSuccess:makeUpArray];
    }
}


-(void)getMaterialWithMakeUpModelArray:(NSArray*)makeupModelArray osVersion:(NSString *)version {
    //参数检查
    for (id object in makeupModelArray) {
        if (![object isKindOfClass:[MirrorMakeUpModel class]]) {
            return;
        }
    }
    //发送mtop请求，获取cspuid对应的版本号
    [self requestBatFilePathWithRequstModelArray:makeupModelArray];
    
}

-(void)requestBatFilePathWithRequstModelArray:(NSArray*)requstModelArray{
    //发送mtop请求小data文件下载地址
    NSMutableDictionary *businessParam = [[NSMutableDictionary alloc] initWithCapacity:1];
    //设置请求参数
    NSString *cspuIds = @"";
    for (MirrorMakeUpModel *model in requstModelArray) {
        cspuIds = [NSString stringWithFormat:@"%@,%@",model.cspuId,cspuIds];
    }
    
    [businessParam setValue:cspuIds forKey:@"materialIds"];
    [businessParam setValue:self.osVersion forKey:@"alorVersion"];
    
    MirrorNetworkParam *param = [[MirrorNetworkParam alloc] init];
    param.businessParam = businessParam;
    param.needLogin = NO;
    param.apiVersion = @"1.0";
    
    if (!_netWorkManager) {
        _netWorkManager = [[MirrorNetWorkDefaultAdapter alloc] init];
    }
    

    if (self.delegate && [self.delegate respondsToSelector:@selector(startGetMaterialFromServer)]) {
        [self.delegate startGetMaterialFromServer];
    }
    
    __weak __typeof(self) weakSelf = self;
    [_netWorkManager request:Mirror_API_GET_DAT withParam:param onSuccess:^(NSDictionary *dic) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf processBatFileRequestSuccessData:dic RequstModelArray:requstModelArray];
        
    } onFailed:^(NSInteger errorCode,NSString *errorMsg) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSString *failMsg;
        if (errorMsg) {
            failMsg = [NSString stringWithFormat:@"请求素材地址失败,%@",errorMsg];
        }else{
            failMsg = @"请求素材地址失败";
        }
        
        if (strongSelf.delegate&&[strongSelf.delegate respondsToSelector:@selector(getMaterialFailWithMsg:)]) {
            [strongSelf.delegate getMaterialFailWithMsg:failMsg];
        }
    }];
}

-(void)processBatFileRequestSuccessData:(NSDictionary *)dic RequstModelArray:(NSArray*)requstModelArray{
    //数据解析，获取下载地址
    @try {
        NSDictionary *data = [dic objectForKey:@"data"];
        NSArray *result = [data objectForKey:@"result"];
        if (!result || result.count == 0) {
            NSString *failMsg = @"加载失败，服务器端返回素材内容为空";
            if (self.delegate&&[self.delegate respondsToSelector:@selector(getMaterialFailWithMsg:)]) {
                [self.delegate getMaterialFailWithMsg:failMsg];
            }
            return;
        }
        
//        NSInteger makeUpArrayCount = result.count<requstModelArray.count?result.count:requstModelArray.count;//上妆个数以返回信息为准
        for (int i = 0; i < result.count; i++) {
            NSDictionary *resultItem = [result objectAtIndex:i];
            NSString *cspuid = [resultItem objectForKey:@"cspuid"];
            
            for (int j = 0; j < requstModelArray.count; j++){
                MirrorMakeUpModel *model = [requstModelArray objectAtIndex:j];
                if ([model.cspuId isEqualToString:cspuid]) {
                    MirrorUtils *util = [[MirrorUtils alloc] init];
                    id feature = [resultItem objectForKey:@"feature"];
                    model.feature = [util parseJsonToDic:feature];
                    model.datUrl = [resultItem objectForKey:@"datUrl"];
                    model.cspuVersion = [resultItem objectForKey:@"cspuVersion"];
                    NSString *makeUpType = [resultItem objectForKey:@"type"];
                    model.makeUpType = [makeUpType intValue];
                    
                    if (model.feature) {
                        model.color = [model.feature objectForKey:@"color"];
                    }
                    
                    
                    NSString *modelCacheKey = [self modelCacheKeyWithCspuId:model.cspuId cspuVersion:model.cspuVersion];
                    BOOL hasModel = [[MirrorDiskCache sharedCache] hasObjectForKey:modelCacheKey];
                    if (hasModel) {

                    }else{
                        [self downloadFileWithModel:model];
                    }
                    
                    
                }
            }
            
        }
        
        
        
    }
    @catch (NSException *exception) {
        //windwane回调
        NSString *failMsg = @"加载失败，出现异常";
        if (self.delegate&&[self.delegate respondsToSelector:@selector(getMaterialFailWithMsg:)]) {
            [self.delegate getMaterialFailWithMsg:failMsg];
        }

    }
    @finally {
        
    }
    
}

-(MirrorMakeUpModel *)isNeedDownLoadGlassBgImgWithModelArray:(NSArray*)modelArray{
    NSString *glassBgImgUrl = nil;
    MirrorMakeUpModel *glassModel;
    for (MirrorMakeUpModel *model in modelArray) {
        if (model.feature == nil) {
            continue;
        }
        glassBgImgUrl = [model.feature objectForKey:@"glassBgImage"];
        if (glassBgImgUrl == nil) {
            continue;
        }
        
        UIImage *glasssBgImg= [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:glassBgImgUrl];
        
        if (glasssBgImg) {
            MirrorMakeUpModel *tempModel = [[MirrorMakeUpModel alloc] init];
            tempModel = model;
            [self.makeupModelArray removeObject:model];
            if (tempModel.feature == nil) {
                tempModel.feature = [[NSMutableDictionary alloc] initWithCapacity:3];
            }
            [tempModel.feature setObject:glasssBgImg forKey:@"glassBgImageData"];
            [self.makeupModelArray addObject:tempModel];
        }else{
            glassModel = model;
        }
        

        
        
        
    }
    
    return glassModel;
}

-(void)downLoadGlassBgImgWithMakeUpModel:(MirrorMakeUpModel*)model{
    _imageManager = [SDWebImageManager sharedManager];
    MirrorMakeUpModel *tempModel = [[MirrorMakeUpModel alloc] init];
    tempModel = model;
    [self.makeupModelArray removeObject:model];
    if (tempModel.feature == nil) {
        return;
    }
    NSString *glassBgUrl = [tempModel.feature objectForKey:@"glassBgImage"];
    if (glassBgUrl == nil) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:glassBgUrl];
    MirrorMaterialUseCacheManager __weak *weakSelf = self;
    [_imageManager downloadWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        
        if (finished) {
            //cache
            [tempModel.feature setObject:image forKey:@"glassBgImageData"];
            [weakSelf.makeupModelArray addObject:tempModel];

        }else{
           //下载失败后使用默认的眼镜图片
            UIImage *imageDefault = [UIImage imageNamed:@"MirrorSDK.bundle/Mirror_glass_bg_default.png"];
            if (imageDefault == nil) {
                
            }
            if (imageDefault) {
                [tempModel.feature setObject:imageDefault forKey:@"glassBgImageData"];
                [weakSelf.makeupModelArray addObject:tempModel];
 
            }
            
            
            
        }
        
        NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:tempModel];
        NSString *modelCacheKey = [self modelCacheKeyWithCspuId:tempModel.cspuId cspuVersion:tempModel.cspuVersion];
        [[MirrorDiskCache sharedCache] cacheObject:modelData forKey:modelCacheKey];
        
        
        
        
        if (_makeUpArrayCount != 0) {
            return;
        }
        if (weakSelf.delegate&&[weakSelf.delegate respondsToSelector:@selector(getMaterialSuccess:)]) {
            [weakSelf.delegate getMaterialSuccess:weakSelf.makeupModelArray];
        }
    } ];

    
    

}


-(void)downloadFileWithModel:(MirrorMakeUpModel *)model{
    self.downloadManager = [[MirrorDownload alloc] initWithURL:[NSURL URLWithString:model.datUrl]];
    self.downloadManager.key = model;
    [self.downloadManager startWithDelegate:self];
}

-(void)downloadFileWithModels:(NSArray*)models{
    for (int i = 0; i < models.count; i++) {
        MirrorMakeUpModel *model = [models objectAtIndex:i];
        self.downloadManager = [[MirrorDownload alloc] initWithURL:[NSURL URLWithString:model.datUrl]];
        self.downloadManager.key = model;
        [self.downloadManager startWithDelegate:self];
    }
    
}

-(NSString *)modelCacheKeyWithCspuId:(NSString *)cspuId{
    return [self modelCacheKeyWithCspuId:cspuId cspuVersion:@""];
}

-(NSString *)modelCacheKeyWithCspuId:(NSString *)cspuId cspuVersion:(NSString *)cspuVersion{
    NSString *modelCacheKey = [NSString stringWithFormat:@"%@_%@_%@_%@",CACHE_MODEL_PREFIX,_osVersion,cspuId,cspuVersion];
    return modelCacheKey;
}

-(void)cancelDownload{
    [self.downloadManager cancel];
}

-(void)pauseDownload{
    [self.downloadManager pause];
}
-(void)resumeDownload{
    [self.downloadManager resume];
}

-(NSMutableArray *)makeupModelArray{
    if (!_makeupModelArray) {
        _makeupModelArray = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _makeupModelArray;
}



#pragma mark - MirrorDownloaderDelegate
-(void)MirrorDownloadProgress:(float)progress Percentage:(NSInteger)percentage MirrorDownload:(MirrorDownload *)MirrorDownload{
    
}

-(void)MirrorDownloadFinished:(NSData*)fileData MirrorDownload:(MirrorDownload *)mirrorDownload{
    self.downloadManager = nil;
    
    //---解压缩开始---
    if ([mirrorDownload.fileName hasSuffix:@"zip"]) {
        NSData *tempData = [MirrorFileUtil unZipDataWithzipData:fileData];
        if (tempData == nil) {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(getMaterialFailWithMsg:)]) {
                [self.delegate getMaterialFailWithMsg:@"解压缩失败"];
                return;
            }
        }else{
            fileData = tempData;
        }
    }
    //---解压缩结束---
    
    
    MirrorMakeUpModel *model = mirrorDownload.key;
    model.fileData = fileData;
    if (!model.isCache) {
       _makeUpArrayCount--;
       [self.makeupModelArray addObject:model];
    }
    
    
    NSString *modelCacheKey = [self modelCacheKeyWithCspuId:model.cspuId cspuVersion:model.cspuVersion];
    NSString *modelCacheKeyNoCspuVersion = [self modelCacheKeyWithCspuId:model.cspuId];
    NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:model];
    [[MirrorDiskCache sharedCache] cacheObject:modelData forKey:modelCacheKey];
    [[MirrorDiskCache sharedCache] cacheObject:modelData forKey:modelCacheKeyNoCspuVersion];
    
    if (_makeUpArrayCount == 0) {
        MirrorMakeUpModel *model = [self isNeedDownLoadGlassBgImgWithModelArray:self.makeupModelArray];
        if (model) {
            [self downLoadGlassBgImgWithMakeUpModel:model];
        }else{
            if (self.delegate&&[self.delegate respondsToSelector:@selector(getMaterialSuccess:)]) {
                [self.delegate getMaterialSuccess:self.makeupModelArray];
            }
        }
        
    }
    
}

-(void)MirrorDownloadFail:(NSError*)error MirrorDownload:(MirrorDownload *)MirrorDownload{
    _makeUpArrayCount--;
    if (_makeUpArrayCount == 0) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(getMaterialSuccess:)]) {
            [self.delegate getMaterialSuccess:self.makeupModelArray];
        }
    }
    //添加下载错误回调
    NSString *failMsg = [NSString stringWithFormat:@"%@",error];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(getMaterialFailWithMsg:)]) {
        [self.delegate getMaterialFailWithMsg:failMsg];
    }
    
}


-(void)dealloc{
    [self clear];
}

-(void)clear{
    if (_makeupModelArray) {
        _makeupModelArray = nil;
    }
    if (_netWorkManager) {
        _netWorkManager = nil;
    }
}

@end