//
//  SocialParam.h
//  SocializeSDK
//
//  Created by Wan Wentao on 14/11/25.
//  Copyright (c) 2014年 rocky. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    
    TBSCActionComment, // 评论
    
    TBSCActionBarPraise,    // 赞
    
    TBSCActionBarCountStatus,   // 获取统计数据
    
    TBSCActionBarNotLike, // 踩
    
    TBSCActionBarFollow //关注
    
} TBSCActionType;
/**
 *
 *  @param  errorMessage    错误信息，返回一个字符串，nil表示成功
 *  @param  object          返回数据的基础类型
 *
 **/
typedef void(^TBSCFinish)(NSString* errorMessage, NSObject* object);
/**
 *
 *  @param  actionType      操作类型
 *  @param  errorMessage    错误信息，返回一个字符串，nil表示成功
 *  @param  object          返回数据的基础类型
 *
 **/
typedef void(^TBSCActionBarFinish)(TBSCActionType actionType, NSString* errorMessage, NSObject* object);

/**
 *  @param succeed    操作结果
 *  @param resultStr  自定义操作返回自定义字串
 **/
typedef void(^TBSCOnResult)(BOOL succeed, NSString* resultStr);

//评论列表页样式
typedef enum{
    TBSCCommentListTypeWithParentCommentOne = 0,
    TBSCCommentListTypeDefault,
    TBSCCommentListTypeWithParentCommentList
}TBSCCommentListType;




@interface ZHSocialParam : NSObject

@property (nonatomic,assign) int                targetType; //业务方targetType，用于业务之间轻社交数据隔离
@property (nonatomic,assign) int                subType;    //业务方子业务类型,如无子业务默认为0
@property (nonatomic,assign) NSString           *targetId;   //业务方数据对象id,也就是原微淘feedId


/**
 *  初始化
 *
 *  @param  targetId        业务方数据对象id,也就是原微淘feedId
 *  @param  targetType      业务方targetType，用于业务之间轻社交数据隔离
 *  @param  subType         业务方子业务类型,如无子业务默认为0
 *
 **/
- (ZHSocialParam*)initWithTargetId:(NSString *)targetId targetType:(int)targetType subType:(int)subType;

@end
