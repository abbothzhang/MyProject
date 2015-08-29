//
//  MirrorMakeUpCenter.m
//  MirrorSDK
//
//  Created by 龙冥 on 7/6/15.
//  Copyright (c) 2015 Taobao. All rights reserved.
//

#import "MirrorMakeUpCenter.h"
#import "SynthesizeSingleton.h"
#import "Cosmetic3DTryonEngineAPI.h"
#import "MirrorOpenGLNode.h"
#import "MirrorMakeUpModel.h"
#import "MirrorBeautyModel.h"
#import "MirrorViewController.h"
#include "functions.h"
#import "MirrorDiskCache.h"

#define MIRROR_MAKEUP_BUFFER_DEFAULT_WIDTH             640.0f
#define MIRROR_MAKEUP_BUFFER_DEFAULT_HEIGHT            480.0f
#define MIRROR_COLOR_BGR(b,g,r)               (((b) << 16)+((g) << 8) + r)
#define MIRROR_COLOR_ABGR(a,b,g,r)            (((a) << 24)+((b) << 16)+((g) << 8) + r)


typedef struct {
    CosmeticTemplateData *p_data_list;
    float *p_weight_list;
    int count;
    int reset;
    
} cosmetic_param_t,*p_cosmetic_param_t;

typedef struct {
    BeautyParam *p_beauty;
    int count;
    int reset;
    
} cosmetic_beauty_param_t,*p_cosmetic_beauty_param_t;

typedef struct {
    
    unsigned char *p_data;
    unsigned char *p_image;
    int i_image_width;
    int i_image_height;
    int i_data;
    int reset;
    
} glass_param_t,*p_glass_param_t;

@interface MirrorMakeUpCenter () {
@private
    CCosmetic3DTryonEngine *p_cosmetic_glass_engine;
    p_cosmetic_param_t p_cosmetic_param;
    p_glass_param_t p_glass_param;
    p_cosmetic_beauty_param_t p_cosmetic_beauty_param;

}

@property (nonatomic,retain) NSData *fileData;
@property (nonatomic) BOOL isRotate90;

@end

@implementation MirrorMakeUpCenter

@synthesize initialized = _initialized,bufferSize = _bufferSize,fileData = _fileData;

SYNTHESIZE_SINGLETON_FOR_CLASS (MirrorMakeUpCenter)

- (id)init {
    if (self = [super init]) {
        _dataLock = [[NSRecursiveLock alloc] init];
        _bufferSize = CGSizeMake(MIRROR_MAKEUP_BUFFER_DEFAULT_WIDTH, MIRROR_MAKEUP_BUFFER_DEFAULT_HEIGHT);
    }
    return self;
}

- (void)initializer:(NSData *)fileData completed:(initialCompletedBlock)completedBlock {
    do {
        if (_initialized) {
            [self clear];
            _initialized = NO;
            _isRotate90 = NO;
        }
        __strong __typeof(&*fileData) strongData = fileData;
        if (strongData) {
            runSynchronousOnContextQueue(^{
                do {
                    p_cosmetic_glass_engine = CCosmetic3DTryonEngine::GetInstance();
                    if (p_cosmetic_glass_engine == NULL) {
                        runAsynchronousOnMainQueue (^ {
                            completedBlock(_initialized, [NSError errorWithDomain:@"out of memory" code:kMirrorMakeUpOutOfMemoryErrorType userInfo:nil]);
                        });
                        break;
                    }
                    int result = p_cosmetic_glass_engine->Initialize((unsigned char *)[strongData bytes], sizeof(strongData), _bufferSize.width, _bufferSize.height, 512, 1);
                    if (result == kMirrorMakeUpSuccess) {
                        _initialized = YES;
                        self.fileData = strongData;
                        
//                        if (!p_cosmetic_param) {
//                            p_cosmetic_param = (p_cosmetic_param_t)malloc(sizeof(cosmetic_param_t));
//                            memset(p_cosmetic_param, 0, sizeof(cosmetic_param_t));
//                        }
                        
                        runAsynchronousOnMainQueue (^ {
                            completedBlock(_initialized, nil);
                        });
                        break;
                    }
                    else {
                        runAsynchronousOnMainQueue (^ {
                            completedBlock(_initialized, [NSError errorWithDomain:@"initial failed" code:kMirrorMakeUpInitDataErrorType userInfo:nil]);
                        });
                        break;
                    }
                    
                } while (0);
            });
        }
        
    } while (0);
}



- (void)clearCosmetic {
    CosmeticTemplateData *p_data = p_cosmetic_param->p_data_list;
    for (int i = 0 ; i < p_cosmetic_param->count; i++) {
        free(p_data[i].pData);
    }
    delete [] p_data;
    delete [] p_cosmetic_param->p_weight_list;
    p_cosmetic_param->p_data_list = NULL;
    p_cosmetic_param->p_weight_list = NULL;
    p_cosmetic_param->count = 0;
    p_cosmetic_param->reset = YES;
}

- (void)clearGlass {
    if (p_glass_param) {
        if (p_glass_param->p_data) {
            delete [] p_glass_param->p_data;
            p_glass_param->p_data = NULL;
        }
        if (p_glass_param->p_image) {
            delete [] p_glass_param->p_image;
            p_glass_param->p_image = NULL;
        }
        p_glass_param->i_data = 0;
        p_glass_param->i_image_width = 0;
        p_glass_param->i_image_height = 0;
    }
    p_glass_param->reset = YES;
}

- (void)clear {
    [_dataLock lock];
    if (p_cosmetic_param) {
        [self clearCosmetic];
        free(p_cosmetic_param);
        p_cosmetic_param = NULL;
    }
    if (p_cosmetic_beauty_param) {
        if (p_cosmetic_beauty_param->p_beauty) {
            delete [] p_cosmetic_beauty_param->p_beauty;
        }
        free(p_cosmetic_beauty_param);
        p_cosmetic_beauty_param = NULL;
    }
    
    _initialized = NO;
    if (p_glass_param) {
        [self clearGlass];
        free(p_glass_param);
        p_glass_param = NULL;
    }

    if (p_cosmetic_glass_engine) {
        p_cosmetic_glass_engine->Uninitialize();
        CCosmetic3DTryonEngine::ReleaseInstance(p_cosmetic_glass_engine);
        p_cosmetic_glass_engine = NULL;
    }
    


    [_dataLock unlock];
    self.fileData = nil;
}

- (BOOL)inputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    BOOL success = NO;
    BOOL hasCosmetic = p_cosmetic_param == NULL?NO:YES;
    BOOL hasGlass = p_glass_param == NULL?NO:YES;
    
    [_dataLock lock];
    do {
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        int bufferWidth = (int)CVPixelBufferGetWidth(imageBuffer);
        int bufferHeight = (int)CVPixelBufferGetHeight(imageBuffer);
        CVPixelBufferLockBaseAddress(imageBuffer, 0);
        void *baseAddress = CVPixelBufferGetBaseAddressOfPlane(imageBuffer,0);
        unsigned char *p_buffer = (unsigned char *)baseAddress;
        int result = kMirrorMakeUpSuccess;
        if (_initialized && p_cosmetic_glass_engine) {
            
            //设置旋转90度，竖屏上妆
            if (!_isRotate90) {
                result = p_cosmetic_glass_engine->SetRotate(90);
                if (result != kMirrorMakeUpSuccess) {
                    _isRotate90 = NO;
                }else{
                    _isRotate90 = YES;
                }
            }
            
            
            
            //美颜
            if (p_cosmetic_beauty_param && p_cosmetic_beauty_param->reset) {
                int result = p_cosmetic_glass_engine->Cosmetic_SetBeautyParam(p_cosmetic_beauty_param->p_beauty, p_cosmetic_beauty_param->count);
                if (result != kMirrorMakeUpSuccess) {
                    //TODO:美颜失败时操作
                    p_cosmetic_beauty_param->reset = YES;
                }else{
                    p_cosmetic_beauty_param->reset = NO;
                }
            }
            
            
            
            //设置化妆参数
            if (p_cosmetic_param && p_cosmetic_param->reset) {
                int result = p_cosmetic_glass_engine->Cosmetic_SetCosmeticParam(p_cosmetic_param->p_data_list, p_cosmetic_param->count);
                if (result != kMirrorMakeUpSuccess) {
                    //设置化妆参数失败
                    p_cosmetic_param->reset = YES;
                }
                p_cosmetic_param->reset = NO;
            }
            
            
            
            //设置眼镜参数
            if (p_glass_param && p_glass_param->reset) {
                int result = p_cosmetic_glass_engine->GlassFitting_SetGlassModel(p_glass_param->p_data, p_glass_param->i_data);
                if (result != kMirrorMakeUpSuccess) {
                    
                }else{
                    //设置眼镜背景图
                    if (p_glass_param->p_image && p_glass_param->i_image_width > 0 && p_glass_param->i_image_height > 0){
                        result = p_cosmetic_glass_engine->GlassFitting_SetBkImage(p_glass_param->p_image, p_glass_param->i_image_width, p_glass_param->i_image_height);
                        if (result != kMirrorMakeUpSuccess) {
                            
                        }else{
                            p_glass_param->reset = NO;
                        }
                    }
                }
                
            }

            
            int result = p_cosmetic_glass_engine->CosmeticAndGlassFittingByVideo(p_buffer, bufferWidth, bufferHeight, hasCosmetic,p_cosmetic_param->p_weight_list , p_cosmetic_param->count, hasGlass, 0);
            if (result != kMirrorMakeUpSuccess) {
                
            }
            
        }
        

        
        
        //        if (_initializedGlass && p_glass_engine && p_glass_param && p_glass_param->p_data) {
        //            if (p_glass_param->reset) {
        //                if (p_glass_param->p_data) {
        //                    result = p_glass_engine->ResetGlassModel(p_glass_param->p_data,p_glass_param->i_data);
        //                    if (result != kMirrorMakeUpSuccess) {
        //                        break;
        //                    }
        //                    assert(result == kMirrorMakeUpSuccess);
        //                    result = p_glass_engine->SetRotate(90);
        //                    if (result != kMirrorMakeUpSuccess) {
        //                        break;
        //                    }
        //                    assert(result == kMirrorMakeUpSuccess);
        //                }
        //                if (p_glass_param->p_image && p_glass_param->i_image_width > 0 && p_glass_param->i_image_height > 0) {
        //                    //ResetBkImage不能放在主线程调用，会有线程问题，放在这个线程里比较安全
        //                    result = p_glass_engine->ResetBkImage(p_glass_param->p_image, p_glass_param->i_image_width, p_glass_param->i_image_height);
        //                    if (result != kMirrorMakeUpSuccess) {
        //                        break;
        //                    }
        //                }
        //                p_glass_param->reset = 0;
        //            }
        //            if (p_glass_param->p_data) {
        //                result = p_glass_engine->GlassFittingByVideo(p_buffer, bufferWidth, bufferHeight, 0);
        //                assert(result == kMirrorMakeUpSuccess);
        //            }
        //        }
        
        //        else if (p_cosmetic_engine && _initialized) {
        //            if (p_cosmetic_beauty_param && p_cosmetic_beauty_param->reset) {
        //                int result = p_cosmetic_engine->SetBeautyParam(p_cosmetic_beauty_param->p_beauty, p_cosmetic_beauty_param->count);
        ////                assert(result == kMirrorMakeUpSuccess);
        //                if (result != kMirrorMakeUpSuccess) {
        //                    break;
        //                }
        //                result = p_cosmetic_engine->SetRotate(90);
        ////                assert(result == kMirrorMakeUpSuccess);
        //                if (result != kMirrorMakeUpSuccess) {
        //                    break;
        //                }
        //                p_cosmetic_beauty_param->reset = 0;
        //            }
        //            if (p_cosmetic_param && p_cosmetic_param->reset) {
        //                int result = p_cosmetic_engine->SetCosmeticParam(p_cosmetic_param->p_data_list, p_cosmetic_param->count, 1);
        ////                assert(result == kMirrorMakeUpSuccess);
        //                if (p_cosmetic_param->count > 0) {
        //                    result = p_cosmetic_engine->SetRotate(90);
        //                    if (result != kMirrorMakeUpSuccess) {
        //                        break;
        //                    }
        //                }
        //                p_cosmetic_param->reset = 0;
        //            }
        //            result = p_cosmetic_engine->RealCosmeticByVideo(p_buffer, bufferWidth, bufferHeight, p_buffer, p_cosmetic_param->p_weight_list, p_cosmetic_param->count);//mark
        //            assert(result == kMirrorMakeUpSuccess);
        //        }
        
        
        CVPixelBufferUnlockBaseAddress(imageBuffer,0);
        success = result == kMirrorMakeUpSuccess ? YES : NO;
        
    } while (0);
    
    [_dataLock unlock];
    return success;
}

- (int)intFromColor:(NSString *)color {
    // 默认不设置颜色参数
    int bgr = MIRROR_COLOR_ABGR(255, 255, 255, 255);
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) {
        return bgr;
    }
    
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    if ([cString length] != 6) {
        return bgr;
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return MIRROR_COLOR_BGR(b, g, r);
}

// 设置试妆参数组合，传入MirrorMakeUpModel类数组数据
- (BOOL)setMakeUpArray:(NSArray *)makeUpArray {
    BOOL success = NO;
    [_dataLock lock];
    NSLog(@"*****setMakeUpArray>>>>>>>>>>>********");
    do {
        if (p_cosmetic_glass_engine == NULL || !_initialized) {
            //TODO:initialized
            break;
        }
        if (p_cosmetic_param) {
            [self clearCosmetic];
        }
        if (p_glass_param) {
            [self clearGlass];
        }
        if (!makeUpArray.count) {
            success = YES;
            break;
        }
        
        
        
        
        
        NSMutableArray *cosmeticArray = [[[NSMutableArray alloc] init] autorelease];
        //首先处理眼镜试妆
        for (MirrorMakeUpModel *current in makeUpArray) {
            if (current.makeUpType == MirrorMakeUpTypeCosmetic) {
                [cosmeticArray addObject:current];
                continue;
            }
            if (current.makeUpType == MirrorMakeUpTypeGlass) {
                if (current.fileData.length > 0) {
                    if (p_glass_param->p_data) {
                        [self clearGlass];
                    }
                    p_glass_param->p_data = (unsigned char *)malloc(current.fileData.length);
                    [current.fileData getBytes:p_glass_param->p_data length:current.fileData.length];
                    p_glass_param->i_data = (int)current.fileData.length;
                    UIImage *image = [current.feature objectForKey:@"glassBgImageData"];
                    if (image) {
                        //NSString *glassBgImageUrl = [current.feature objectForKey:@"glassBgImage"];
                        //NSString *path = [[MirrorDiskCache sharedCache] filePathForKey:glassBgImageUrl];
                        p_glass_param->p_image = [self mirrorYUVImageData:image];
                        p_glass_param->i_image_width = image.size.width;
                        p_glass_param->i_image_height = image.size.height;
                    }
                    p_glass_param->reset = YES;
                
                }
                continue;
            }
        }
        
        
        
        if (cosmeticArray.count > 0) {
            CosmeticTemplateData *p_data_list = new CosmeticTemplateData[cosmeticArray.count];
            float *p_weight_list = new float[cosmeticArray.count];
            int index = 0;
            for (int i = 0; i < cosmeticArray.count; i++) {
                MirrorMakeUpModel *makeUpModel = [cosmeticArray objectAtIndex:i];
                if (!makeUpModel.fileData || makeUpModel.fileData.length == 0) {
                    continue;
                }
                p_data_list[index].pData = (unsigned char *)malloc([makeUpModel.fileData length]);
                [makeUpModel.fileData getBytes:p_data_list[index].pData length:[makeUpModel.fileData length]];
                p_data_list[index].lenData = (int)[makeUpModel.fileData length];
                NSString *color = [makeUpModel.attribute objectForKey:@"color"];
                if (!color.length) {
                    color = [makeUpModel.feature objectForKey:@"color"];
                }
                p_data_list[index].bgr = [self intFromColor:color];
                p_weight_list[index] = makeUpModel.weight;
                index++;
            }
            if (index == 0) {
                delete [] p_data_list;
                delete [] p_weight_list;
                break;
            }
            if (!p_cosmetic_param) {
                p_cosmetic_param = (p_cosmetic_param_t)malloc(sizeof(cosmetic_param_t));
                memset(p_cosmetic_param, 0, sizeof(cosmetic_param_t));
            }
            p_cosmetic_param->p_data_list = p_data_list;
            p_cosmetic_param->p_weight_list = p_weight_list;
            p_cosmetic_param->count = index;
            p_cosmetic_param->reset = YES;
        }
        
        
        
        
        success = YES;
        
    } while (0);
    
    NSLog(@"*****setMakeUpArray<<<<<<<<<<<<<<********");
    [_dataLock unlock];
    return success;
}

//zhmark 添加成功和失败回调，将失败原因返回回来
// 设置美肤参数组合，传入MirrorBeautyModel类数组数据
- (BOOL)setBeautyArray:(NSArray *)beautyArray {
    BOOL success = NO;
    [_dataLock lock];
    do {
        if (p_cosmetic_glass_engine == NULL || !_initialized) {
            break;
        }
        if (p_cosmetic_beauty_param) {
            if (p_cosmetic_beauty_param->p_beauty) {
                delete [] p_cosmetic_beauty_param->p_beauty;
            }
            free(p_cosmetic_beauty_param);
            p_cosmetic_beauty_param = NULL;
        }
        if (!beautyArray.count) {
            break;
        }
        int count = (int)beautyArray.count;
        BeautyParam *p_beauty = new BeautyParam[count];
        for (int i = 0; i < count; i++) {
            MirrorBeautyModel *beauty = [beautyArray objectAtIndex:i];
            p_beauty[i].id = beauty.beautyType;
            p_beauty[i].fWeight = beauty.weight;
        }
        p_cosmetic_beauty_param = (p_cosmetic_beauty_param_t)malloc(sizeof(cosmetic_beauty_param_t));
        p_cosmetic_beauty_param->p_beauty = p_beauty;
        p_cosmetic_beauty_param->count = count;
        p_cosmetic_beauty_param->reset = YES;
        success = YES;
        
    } while (0);
    
    if (!success && p_cosmetic_beauty_param) {
        if (p_cosmetic_beauty_param->p_beauty) {
            delete [] p_cosmetic_beauty_param->p_beauty;
        }
        free(p_cosmetic_beauty_param);
        p_cosmetic_beauty_param = NULL;
    }
    [_dataLock unlock];
    return success;
}

+ (MirrorMakeUpCenter *)sharedCenter {
    return [MirrorMakeUpCenter sharedMirrorMakeUpCenter];
}


#define bytesPerPixel 4
#define bitsPerComponent 8
#define CLIP(X) ( (X) > 255 ? 255 : (X) < 0 ? 0 : X)
// RGB -> YUV
#define RGB2Y(R, G, B) CLIP(( (  66 * (R) + 129 * (G) +  25 * (B) + 128) >> 8) +  16)
#define RGB2U(R, G, B) CLIP(( ( -38 * (R) -  74 * (G) + 112 * (B) + 128) >> 8) + 128)
#define RGB2V(R, G, B) CLIP(( ( 112 * (R) -  94 * (G) -  18 * (B) + 128) >> 8) + 128)

unsigned char * RGBConvert2YUV(unsigned char *YUV,unsigned char *RGB,int width,int height)
{
    //变量声明
    if (YUV) {
        unsigned int i,x,y,j;
        unsigned char *Y = NULL;
        unsigned char *U = NULL;
        unsigned char *V = NULL;
        Y = YUV;
        U = YUV + width * height;
        V = U + ((width * height)>>2);
        for(y = 0; y < height; y++)
            for(x = 0; x < width; x++)
            {
                j = y * width + x;
                i = j * bytesPerPixel;
                Y[j] = (unsigned char)(RGB2Y(RGB[i], RGB[i+1], RGB[i+2]));
                if (x % 2 == 1 && y % 2 == 1)
                {
                    j = (width >> 1) * (y >> 1) + (x >> 1);
                    //上面i仍有效
                    U[j] = (unsigned char)RGB2U(RGB[i  ], RGB[i + 1], RGB[i + 2]);
                    V[j] = (unsigned char)RGB2V(RGB[i  ], RGB[i + 1], RGB[i + 2]);
//                    U[j] = (unsigned char)
//                    ((RGB2U(RGB[i  ], RGB[i + 1], RGB[i + 2]) +
//                      RGB2U(RGB[i - 4], RGB[i - 3], RGB[i - 2]) +
//                      RGB2U(RGB[i - width * 4], RGB[i + 1 - width * 4], RGB[i + 2 - width * 4]) +
//                      RGB2U(RGB[i - 4 - width * 4], RGB[i - 3 - width * 4], RGB[i - 2 - width * 4]))/4);
//                    V[j] = (unsigned char)
//                    ((RGB2V(RGB[i  ], RGB[i + 1], RGB[i + 2]) +
//                      RGB2V(RGB[i - 4], RGB[i - 3], RGB[i - 2]) +
//                      RGB2V(RGB[i - width * 4], RGB[i + 1 - width * 4], RGB[i + 2 - width * 4]) +
//                      RGB2V(RGB[i - 4 - width * 4], RGB[i - 3 - width * 4], RGB[i - 1 - width * 4]))/4);
                }
            }
    }
    return YUV;
}

struct RGBQUAD {
    unsigned char  rgbBlue;
    unsigned char  rgbGreen;
    unsigned char  rgbRed;
    unsigned char  rgbAlpha;
} ;

static void rgb2yuv420p_float(unsigned char *pYUV, unsigned char *pRGB, int w, int h)
{
    int frameSize = w * h;
    
    int yIndex = 0;
    int uvIndex = frameSize;
    
    int  R, G, B;
    int index = 0;
    int i,j;
    struct RGBQUAD *rbgBuf = (struct RGBQUAD*)pRGB;
    
    for (j = 0; j < h; j++) {
        for (i = 0; i < w; i++) {
            //alpha is not used
            R = rbgBuf[index].rgbRed;
            G = rbgBuf[index].rgbGreen;
            B = rbgBuf[index].rgbBlue;
            
            // printf("R:%d, G:%d, B:%d\n ", R,G,B);
            
            // well known RGB to YUV algorithm
//            Y =  0.299 * R + 0.587 * G + 0.114 * B;
//            U = -0.147 * R - 0.289 * G + 0.436 * B;
//            V = 0.615 * R - 0.515 * G - 0.100 * B;
            
            
            pYUV[yIndex++] = RGB2Y(R,G,B);
            if (j % 2 == 0 && index % 2 == 0) {
                pYUV[uvIndex++] = RGB2V(R,G,B);
                pYUV[uvIndex++] = RGB2U(R,G,B);
            }
            index ++;
        }
    }
}

- (unsigned char *)mirrorYUVImageData:(UIImage *)image path:(NSString *)path{
    int width = image.size.width;
    int height = image.size.height;

    unsigned char *imageYUVData = (unsigned char *)malloc(width * height * bytesPerPixel);
    const char *pathChar = [path UTF8String];
    imageYUVData = ReadBmpFile2(pathChar, &height, &width);
    
    return imageYUVData;
}


- (unsigned char *)mirrorYUVImageData:(UIImage *)image {
    
    CGImageRef imageref = image.CGImage;
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    int width = (int)CGImageGetWidth(imageref);
    int height = (int)CGImageGetHeight(imageref);
    int bytesPerRow = bytesPerPixel * width;
    unsigned char *imagedata = (unsigned char *)malloc(width * height * bytesPerPixel);
    unsigned char *imageYUVData = (unsigned char *)malloc(width * height * bytesPerPixel);
    if (imagedata) {
        CGContextRef contextRef = CGBitmapContextCreate(imagedata,
                                                        width,
                                                        height,
                                                        bitsPerComponent,
                                                        bytesPerRow,
                                                        colorspace,
                                                        kCGImageAlphaPremultipliedLast);
        //将图像写入一个矩形
        CGRect rect = CGRectMake(0, 0, width, height);
        CGContextDrawImage(contextRef, rect, imageref);
        CGContextRelease(contextRef);

//        Mirror_BGR24_to_YUV420SP(imagedata,width,height,imageYUVData,1);
        rgb2yuv420p_float(imageYUVData, imagedata, width, height);

        free(imagedata);
    }
    CGColorSpaceRelease(colorspace);
    return imageYUVData;
}

- (unsigned char *)mirrorYUVImageDataWithPath:(NSString *)path width:(int )width height:(int )height{
    unsigned char *imagedata = (unsigned char *)malloc(width * height * bytesPerPixel);
    unsigned char *imageYUVData = (unsigned char *)malloc(width * height * bytesPerPixel);

    const char *filname = [path UTF8String];
    imagedata = ReadBmpFile2(filname, &height, &width);
    Mirror_BGR24_to_YUV420SP(imagedata,width,height,imageYUVData,1);
    free(imagedata);
    return imageYUVData;
}

@end
