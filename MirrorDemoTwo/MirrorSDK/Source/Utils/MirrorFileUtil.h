//
//  MirrorFileUtil.h
//  MirrorSDK
//
//  Created by albert on 15/8/9.
//  Copyright (c) 2015年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MirrorFileUtil : NSObject

+(NSData *)unZipDataWithzipData:(NSData *)zipData;

+(NSString *)getDatFilePathUnderPath:(NSString *)path;

@end
