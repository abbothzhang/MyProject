//
//  MirrorDownloader.h
//  downloadManager
//
//  Created by Htain Lin Shwe on 11/7/12.
//  Copyright (c) 2012. All rights reserved.
//


/**
 Version 0.2 at 4 Jan 2013
 
 - Allow Pause and Resume
 
 Version 0.1 at 11 July 2012
 
 - Allow Download with Progress
 */


#import <Foundation/Foundation.h>

#define Mirror_DOWNLOAD_FACEMODEL     @""

//for block
typedef void (^MirrorDownloadProgressBlock)(float progressValue,NSInteger percentage);
typedef void (^SGDowloadFinished)(NSData* fileData,NSString* fileName);
typedef void (^MirrorDownloadFailBlock)(NSError*error);

@class MirrorDownload;
@protocol MirrorDownloaderDelegate <NSObject>

@required
-(void)MirrorDownloadProgress:(float)progress Percentage:(NSInteger)percentage MirrorDownload:(MirrorDownload *)MirrorDownload;
-(void)MirrorDownloadFinished:(NSData*)fileData MirrorDownload:(MirrorDownload *)MirrorDownload;
-(void)MirrorDownloadFail:(NSError*)error MirrorDownload:(MirrorDownload *)MirrorDownload;
@end

@interface MirrorDownload : NSObject <NSURLConnectionDataDelegate>

/**
 Get Receive NSData.
 */
@property (nonatomic,readonly) NSMutableData* receiveData;

/**
 Current Download Percentage
*/
@property (nonatomic,readonly) NSInteger downloadedPercentage;

/**
 `float` value for progress bar
 */
@property (nonatomic,readonly) float progress;

/**
 Server is allow resume or not
 */
@property (nonatomic,readonly) BOOL allowResume;

/**
 Suggest Download File Name
 */
@property (nonatomic,readonly) NSString* fileName;

/**
 Delegate Method
 */
@property (nonatomic,weak) id<MirrorDownloaderDelegate>delegate;


//可选，区分不同下载用
@property (nonatomic,strong) id   key;




//initwith file URL and timeout
-(id)initWithURL:(NSURL *)fileUrl;

-(void)startWithDownloading:(MirrorDownloadProgressBlock)progressBlock onFinished:(SGDowloadFinished)finishedBlock onFail:(MirrorDownloadFailBlock)failBlock;

-(void)startWithDelegate:(id<MirrorDownloaderDelegate>)delegate;
-(void)cancel;
-(void)pause;
-(void)resume;
@end
