//
//  TBMirrorBeautyModel.h
//  TBMirror
//
//  Created by albert on 15/5/20.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TBMirrorBeautyTypeBuffing = 0,
    TBMirrorBeautyTypeWhite,
    
}TBMirrorBeautyType;

@interface TBMirrorBeautyModel : NSObject

//@property(nonatomic) enum FaceBeautifyID beautyType;
@property (nonatomic) TBMirrorBeautyType beautyType;
@property (nonatomic) float               weight;


@end
