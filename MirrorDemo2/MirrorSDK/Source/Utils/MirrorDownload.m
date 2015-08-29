//
//  MirrorDownloader.m
//  downloadManager
//
//  Created by saturngod on 11/7/12.
//

#import "MirrorDownload.h"

@interface MirrorDownload()
@property (nonatomic,assign) float receiveBytes;
@property (nonatomic,assign) float exceptedBytes;
@property (nonatomic,assign) NSInteger timeout;
@property (nonatomic,strong) NSMutableURLRequest *request;
@property (nonatomic,strong) NSURLConnection *connection;
@property (nonatomic,assign) BOOL resumeProgress;

//for block
@property (nonatomic,strong) MirrorDownloadProgressBlock progressDownloadBlock;
@property (nonatomic,strong) SGDowloadFinished progressFinishBlock;
@property (nonatomic,strong) MirrorDownloadFailBlock progressFailBlock;

@end

@implementation MirrorDownload
@synthesize receiveData = _receiveData;
@synthesize request = _request;
@synthesize connection = _connection;
@synthesize downloadedPercentage = _downloadedPercentage;
@synthesize receiveBytes;
@synthesize exceptedBytes;
@synthesize progress = _progress;
@synthesize progressFailBlock = _progressFailBlock;
@synthesize progressDownloadBlock = _progressDownloadBlock;
@synthesize progressFinishBlock = _progressFinishBlock;
@synthesize delegate = _delegate;
@synthesize resumeProgress = _resumeProgress;
@synthesize allowResume = _allowResume;
@synthesize fileName = _fileName;

-(id)initWithURL:(NSURL *)fileUrl{
    
    
    self = [super init];
    
    if(self)
    {
        self.receiveBytes = 0;
        self.exceptedBytes = 0;
        _receiveData = [[NSMutableData alloc] initWithLength:0];
        _downloadedPercentage = 0.0f;
        self.timeout = 15;//过期时间
        self.request = [[NSMutableURLRequest alloc] initWithURL:fileUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:self.timeout];
        
        self.resumeProgress = NO;//for exceptedBytes trigger
        
        self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
        
        _allowResume = NO;//check server is allow resume
        
    }
    
    return self;
}

#pragma mark - NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receiveData appendData:data];
    
    NSInteger len = [data length];
    receiveBytes = receiveBytes + len;
    
    if(exceptedBytes != NSURLResponseUnknownLength) {
        _progress = ((receiveBytes/(float)exceptedBytes) * 100)/100;
        _downloadedPercentage = _progress * 100;
        
        if([_delegate respondsToSelector:@selector(MirrorDownloadProgress:Percentage:MirrorDownload:)])
        {
            [_delegate MirrorDownloadProgress:_progress Percentage:_downloadedPercentage MirrorDownload:self];
        }
        else {
            if(_progressDownloadBlock) {
                _progressDownloadBlock(_progress,_downloadedPercentage);
            }
        }
    }
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //return back error
    if([_delegate respondsToSelector:@selector(MirrorDownloadFail:MirrorDownload:)])
    {
        [_delegate MirrorDownloadFail:error MirrorDownload:self];
    }
    else {
        if(_progressFailBlock) {
            _progressFailBlock(error);
        }
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if(!self.resumeProgress) {
        exceptedBytes = [response expectedContentLength];
    }
    _fileName =[response suggestedFilename];

    NSDictionary* headers = [(NSHTTPURLResponse *)response allHeaderFields];
    if ([headers objectForKey:@"Accept-Ranges"]) {
        _allowResume = YES;
    }
    else
    {
        _allowResume = NO;
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.connection = nil;
    
    if([_delegate respondsToSelector:@selector(MirrorDownloadFinished:MirrorDownload:)])
    {
        [_delegate MirrorDownloadFinished:_receiveData MirrorDownload:self];
    }
    else {
        if(_progressFinishBlock) {
            _progressFinishBlock(_receiveData,_fileName);
        }
    }
}

#pragma mark - properties
-(void)startWithDelegate:(id<MirrorDownloaderDelegate>)delegate {
    _delegate = delegate;
    if(self.connection) {
        [self.connection start];
        _progressDownloadBlock= nil;
        _progressFinishBlock = nil;
        _progressFailBlock = nil;
    }
}

-(void)pause
{
    [self.connection cancel];
}

-(void)resume
{
    //add range for resume but some of the server didn't support resume
    NSString *range = @"bytes=";
    range = [range stringByAppendingString:[[NSNumber numberWithInt:self.receiveBytes] stringValue]];
    range = [range stringByAppendingString:@"-"];
    NSURL* fileURL = self.request.URL.absoluteURL;
    
    self.resumeProgress = YES;//add trigger for except exceptedBytes
    
    
    self.request = [[NSMutableURLRequest alloc] initWithURL:fileURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:self.timeout];
    
    [self.request setValue:range forHTTPHeaderField:@"Range"];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:YES];
}

-(void)startWithDownloading:(MirrorDownloadProgressBlock)progressBlock onFinished:(SGDowloadFinished)finishedBlock onFail:(MirrorDownloadFailBlock)failBlock {
    if(self.connection) {
        [self.connection start];
        _delegate = nil; //clear delegate
        _progressDownloadBlock = [progressBlock copy];
        _progressFinishBlock = [finishedBlock copy];
        _progressFailBlock = [failBlock copy];
    }
    
}
-(void)cancel {
    if(self.connection) {
        [self.connection cancel];
        self.receiveBytes = 0;
        self.exceptedBytes = 0;
        _receiveData = [[NSMutableData alloc] initWithLength:0];
        _downloadedPercentage = 0.0f;
    }
}

- (void)dealloc {
    NSLog(@"MirrorDownload dealloc");
}
@end
