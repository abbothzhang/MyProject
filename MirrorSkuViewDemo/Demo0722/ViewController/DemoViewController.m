//
//  DemoViewController.m
//  Demo0722
//
//  Created by albert on 15/7/22.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "DemoViewController.h"
#import "TBMirrorSkuView.h"
#import "TBMirrorSkuModel.h"
#import "ZHHint.h"
#import "TBMirrorItemModel.h"


@interface DemoViewController ()<TBMirrorSkuViewDelegate>

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
    TBMirrorSkuModel *skuModel = [[TBMirrorSkuModel alloc] init];
    //test
    skuModel.price = @"尺寸";//先暂时用作propName使用
    skuModel.cspuId = @"太阳镜";//先暂时用作sku
    
    NSArray *array1 = [[NSArray alloc] initWithObjects:skuModel,nil];
    NSArray *array2 = [[NSArray alloc] initWithObjects:skuModel,skuModel,nil];
    NSArray *array3 = [[NSArray alloc] initWithObjects:skuModel,skuModel,skuModel,skuModel,nil];
    [dic setObject:array1 forKey:@"oneasdfasfasf"];
    [dic setObject:array2 forKey:@"twoasdfasfasgasdgasdg"];
    [dic setObject:array3 forKey:@"threethreethreethreethreethree"];
//    [dic setObject:array1 forKey:@""];
//    [dic setObject:array2 forKey:@"two2"];
//    [dic setObject:array3 forKey:@"three2"];
//    [dic setObject:array1 forKey:@"one3"];
//    [dic setObject:array2 forKey:@"two3"];
//    [dic setObject:array3 forKey:@"three3"];
//    [dic setObject:array1 forKey:@"one4"];
//    [dic setObject:array2 forKey:@"two4"];
//    [dic setObject:array3 forKey:@"three4"];
    
    //mock data
    //tableview cell数据
        NSMutableArray<TBDetailSkuPropsValuesModel> *propValues1 = (NSMutableArray<TBDetailSkuPropsValuesModel>*)[[NSMutableArray alloc] initWithCapacity:3];
    for (int i = 0; i < 4; i++) {
        TBDetailSkuPropsValuesModel *propValueModel = [[TBDetailSkuPropsValuesModel alloc] init];
        propValueModel.valueId = [NSString stringWithFormat:@"11%d",i];
        propValueModel.name = [NSString stringWithFormat:@"11%d",i];//cell数据
        [propValues1 addObject:propValueModel];
    }
    
    NSMutableArray<TBDetailSkuPropsValuesModel> *propValues2 = (NSMutableArray<TBDetailSkuPropsValuesModel>*)[[NSMutableArray alloc] initWithCapacity:3];
    for (int i = 0; i < 5; i++) {
        TBDetailSkuPropsValuesModel *propValueModel = [[TBDetailSkuPropsValuesModel alloc] init];
        propValueModel.valueId = [NSString stringWithFormat:@"21%d",i];
        propValueModel.name = [NSString stringWithFormat:@"21%d",i];//cell数据
        [propValues2 addObject:propValueModel];
    }

    
    
    NSMutableArray<TBMirrorSkuPropsModel> *skuProps = (NSMutableArray<TBMirrorSkuPropsModel> *)[[NSMutableArray alloc] initWithCapacity:3];
    
    for (int i = 0; i < 2; i++) {
        //宝贝SKU对应的宝贝属性列表
    }
    
    TBMirrorSkuPropsModel *propModel1 = [[TBMirrorSkuPropsModel alloc] init];
    propModel1.propId = [NSString stringWithFormat:@"prop1"];
    propModel1.values = (NSMutableArray<TBDetailSkuPropsValuesModel> *)[[NSMutableArray alloc] initWithArray:propValues1];
    propModel1.propName = @"大尺寸";
    
    TBMirrorSkuPropsModel *propModel2 = [[TBMirrorSkuPropsModel alloc] init];
    propModel2.propId = [NSString stringWithFormat:@"prop2"];
    propModel2.values = propValues2;
    propModel2.propName = @"小尺寸";

    [skuProps addObject:propModel1];
    [skuProps addObject:propModel2];

    
    
    //ppath
    NSMutableDictionary *ppathIdMap = [[NSMutableDictionary alloc] initWithCapacity:20];
    NSMutableDictionary<TBMirrorSkuModel> *skuModelDic = (NSMutableDictionary<TBMirrorSkuModel> *)[[NSMutableDictionary alloc] initWithCapacity:20];
    for (int i = 0; i < 4; i++) {
        NSString *prop1valueKey = [NSString stringWithFormat:@"prop1:11%d",i];
        for (int j = 0; j < 5; j++) {
            NSString *prop2valueKey = [NSString stringWithFormat:@"prop2:21%d",j];
            NSString *skuKey = [NSString stringWithFormat:@"%@;%@",prop1valueKey,prop2valueKey];
            NSString *skuId = [NSString stringWithFormat:@"skuId_%d%d",i,j];
            [ppathIdMap setValue:skuId forKey:skuKey];
            
            TBMirrorSkuModel *skuModel = [[TBMirrorSkuModel alloc] init];
            skuModel.itemId = @"itemId111";
            skuModel.skuId = skuId;
            skuModel.quantity = i;
            skuModel.price = [NSString stringWithFormat:@"%d",i*j];
            skuModel.cspuId = @"cspuId111";//mock
            if (i*j/2) {
                skuModel.isSupportMakeUp = YES;
//                [skuModelDic setValue:skuModel forKey:skuId];
            }else{
                skuModel.isSupportMakeUp = NO;
            }
            //![skuId isEqualToString:@"skuId_00"]
            //skuId_00skuId_01skuId_02skuId_03skuId_04
            if (![@"skuId_00skuId_10skuId_20skuId_31skuId_41" containsString:skuId]) {
                [skuModelDic setValue:skuModel forKey:skuId];
            }
            
            
        }
        
        
        
    }

    //skuModel
    
    
    //生成itemId
    TBMirrorItemModel *itemModel = [[TBMirrorItemModel alloc] init];
    itemModel.skuProps = skuProps;//zhmark
    itemModel.ppathIdmap = ppathIdMap;
    itemModel.mirrorSkuModelDic = skuModelDic;
    
    
    
    
    CGRect horiViewFrame = CGRectMake(0, self.view.frame.size.height - 189, self.view.frame.size.width, 189);
    TBMirrorSkuView *horiView = [[TBMirrorSkuView alloc] initWithFrame:horiViewFrame];
    horiView.delegate = self;
    horiView.backgroundColor = [UIColor whiteColor];
//    [horiView setData:dic];
    [horiView setItemModel:itemModel];
    
    [self.view addSubview:horiView];
}

-(void)arrowBtnClicked:(BOOL)isFold{
    NSString *str = [NSString stringWithFormat:@"ifFold->%d",isFold];
    [ZHHint showToast:str];
}

-(void)buyBtnClicked{
    [ZHHint showToast:@"buyClicked"];
}



@end
