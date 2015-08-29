//
//  MirrorBeautyModel.h
//  Mirror
//
//  Created by albert on 15/5/20.
//  Copyright (c) 2015年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MirrorBeautyTypeBuffing = 0,
    MirrorBeautyTypeWhite,
    
}MirrorBeautyType;

@interface MirrorBeautyModel : NSObject

//@property(nonatomic) enum FaceBeautifyID beautyType;
@property (nonatomic) MirrorBeautyType beautyType;
@property (nonatomic) float               weight;


@end
