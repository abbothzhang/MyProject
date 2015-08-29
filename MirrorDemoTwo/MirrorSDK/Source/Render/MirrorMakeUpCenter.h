//
//  MirrorMakeUpCenter.h
//  MirrorSDK
//
//  Created by 龙冥 on 7/6/15.
//  Copyright (c) 2015 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

typedef void(^initialCompletedBlock)(BOOL finished,NSError *error);

@interface MirrorMakeUpCenter : NSObject {
@private
    BOOL _initialized;
    NSRecursiveLock *_dataLock;
    CGSize _bufferSize;
}

// 引擎是否已经初始化就绪
@property (nonatomic,readonly) BOOL initialized;
// 传入Sample Buffer 大小，默认值 640 * 480
@property (nonatomic,assign) CGSize bufferSize;

// 获取MirrorMakeUpCenter实例
+ (MirrorMakeUpCenter *)sharedCenter;
// 初始化算法引擎，传入算法包文件内存数据，异步初始化加载算法引擎，通过主线程回调block返回结果或错误
- (void)initializer:(NSData *)fileData completed:(initialCompletedBlock)completedBlock;
// 初始化成功后，提供引擎绘制接口，传入Sample Buffer，异步线程调用此方法
- (BOOL)inputSampleBuffer:(CMSampleBufferRef)sampleBuffer;// 渲染 sampleBuffer
// 释放资源
- (void)clear;
// 设置试妆参数组合，传入MirrorMakeUpModel类数组数据
- (BOOL)setMakeUpArray:(NSArray *)array;
// 设置美肤参数组合，传入MirrorBeautyModel类数组数据
- (BOOL)setBeautyArray:(NSArray *)array;

@end
