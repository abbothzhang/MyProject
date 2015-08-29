//
//  DemoViewController.m
//  CameraDemo
//
//  Created by albert on 15/8/29.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "DemoViewController.h"
#import "TBMirrorViewController.h"
#import "TBMirrorViewControllerFactory.h"
#import "TBMirrorDiskCache.h"
#import "TBMirrorMakeUpModel.h"

@interface DemoViewController ()<TBMirrorViewControllerDelegate>

@property (nonatomic,strong) NSString                   *cacheKeyFaceModel;
@property (nonatomic,strong) TBMirrorViewController     *mirrorVC;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpMirrorVC];
}

-(BOOL)setUpMirrorVC{
    //addChildVC
    _mirrorVC = [TBMirrorViewControllerFactory viewControllerWithType:TBMirrorMakeUpTypeVideo delegate:self];
    if (_mirrorVC == nil) {
        return NO;
    }
    [self addChildViewController:_mirrorVC];
    _mirrorVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-20);
    [self.view addSubview:_mirrorVC.view];
    [_mirrorVC didMoveToParentViewController:self];
    [self initFaceModel];
    return YES;
}

-(void)initFaceModel{
    NSString *faceModelPath = [[NSBundle mainBundle] pathForResource:@"face_all_data_100" ofType:@"dat"];
    NSData *faceModelData = [[NSData alloc] initWithContentsOfFile:faceModelPath];
    [[TBMirrorDiskCache sharedCache] cacheObject:faceModelData forKey:self.cacheKeyFaceModel];
    NSString *cachedFacePath = [[TBMirrorDiskCache sharedCache] filePathForKey:self.cacheKeyFaceModel];
    [self.mirrorVC setFaceModelFilePath:cachedFacePath];
}

-(NSString *)cacheKeyFaceModel{
    if (_cacheKeyFaceModel == nil) {
        _cacheKeyFaceModel = [NSString stringWithFormat:@"CACHE_DIRECTORY_FACEMODEL_%@",[_mirrorVC getVersion]];
    }
    
    return _cacheKeyFaceModel;
}

-(void)makeUp{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"saihong" ofType:@"dat"];
    NSData *fileDta = [[NSData alloc] initWithContentsOfFile:filePath];
    
    TBMirrorMakeUpModel *model = [[TBMirrorMakeUpModel alloc] init];
    model.fileData = fileDta;
    model.weight = 0.5f;
    
    NSMutableArray  *makeUpArray = [[NSMutableArray alloc] initWithCapacity:3];
    [makeUpArray addObject:model];
    [self.mirrorVC makeUpWithModels:makeUpArray];
}


#pragma mark - TBMirrorViewControllerDelegate
-(void)initFinished{
    [self makeUp];
}

-(void)initFailed:(NSString *)errorCode{
    
}

-(void)makeUpSuccess{
    
}

-(void)makeUpFailed:(NSString *)errorCode errMsg:(NSString *)errorMsg{
    
}

//美颜回调
-(void)beautySuccess{
    
}
-(void)beautyFailed:(NSString *)errorCode errMsg:(NSString *)errorMsg{
    
}



@end
