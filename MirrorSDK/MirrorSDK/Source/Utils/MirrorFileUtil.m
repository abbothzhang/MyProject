//
//  MirrorFileUtil.m
//  MirrorSDK
//
//  Created by albert on 15/8/9.
//  Copyright (c) 2015年 Taobao. All rights reserved.
//

#import "MirrorFileUtil.h"
#import "MirrorDiskCache.h"
#import "ZipArchive.h"

#define Mirror_CACHE_DIRECTORY @"Mirror_CACHE_DIRECTORY"

@interface MirrorFileUtil(){
    NSMutableArray *filePathArray;
    NSFileManager *localFileManager;

}

@end

@implementation MirrorFileUtil

+(NSData *)unZipDataWithzipData:(NSData *)zipData{
    NSData *unZipData;
    
    NSString *cacheDirPath = [[MirrorDiskCache sharedCache] mirrorCachePath];
    NSString *zipPath = [cacheDirPath stringByAppendingPathComponent:@"material_zipfile.zip"];
    NSString *unZipDir = [cacheDirPath stringByAppendingPathComponent:@"unZipDir"];
    
    NSError *error = nil;
    [zipData writeToFile:zipPath options:0 error:&error];
    
    if (error) {
        return nil;
    }
    
    ZipArchive *za = [[ZipArchive alloc] init];
    if ([za UnzipOpenFile: zipPath]) {
        BOOL ret = [za UnzipFileTo:unZipDir overWrite: YES];
        if (NO == ret){} [za UnzipCloseFile];
    }
    
    NSString *unZipPath = [MirrorFileUtil getDatFilePathUnderPath:unZipDir];
    if (unZipPath == nil) {
        return nil;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    unZipData = [fileManager contentsAtPath:unZipPath];
    [fileManager removeItemAtPath:unZipPath error:nil];
    [fileManager removeItemAtPath:zipPath error:nil];
    
    return unZipData;
}




+(NSString *)getDatFilePathUnderPath:(NSString *)path{

    NSFileManager *myFileManager=[NSFileManager defaultManager];
    NSDirectoryEnumerator *myDirectoryEnumerator = [myFileManager enumeratorAtPath:path];
    NSString *filePath;
    
    while((filePath=[myDirectoryEnumerator nextObject]))     //遍历当前目录
    {
        if([[filePath pathExtension] isEqualToString:@"dat"])   //取得后缀名这.dat的文件名
        {
            return [path stringByAppendingPathComponent:filePath];
        }
        
    }
    
    return nil;
}

@end
