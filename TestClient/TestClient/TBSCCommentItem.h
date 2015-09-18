//
//  SocializeSDK
//
//  Created by albert on 14-12-11.
//  Copyright (c) 2014年 rocky. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TBSCCommentItem.h"

@class TBSCCommentCommodityItem;

#define lableSpace 6.0

@interface TBSCCommentItem : NSObject
//feed相关
@property (nonatomic, assign) NSString    *targetOwnerUserId;//feed作者的userId
@property (nonatomic, assign) NSString    *targetId;//评论关联的feedId，发表评论时必选
//评论者
@property (nonatomic, assign) NSString      *createrId;//评论者id
@property (nonatomic, strong) NSString      *createrNick;//评论者昵称
@property (nonatomic, strong) NSString      *createrPic;//评论者头像
//评论内容相关
@property (nonatomic, assign) NSString    *commentId;//评论内容的id
@property (nonatomic, strong) NSString      *content;//评论的内容
@property (nonatomic, assign) TBSCCommentContentType createrContentType;//评论类型(文字图片或者商品)
@property (nonatomic, assign) NSInteger floor;       // floor楼层,评论列表以楼层作为id标识
@property (nonatomic, assign) LongTimeType  time;
@property (nonatomic, assign) LongTimeType  timestamp;
@property (nonatomic, strong) TBSCCommentCommodityItem *commentCommodityItem;
@property (nonatomic, strong) NSString *imageName;
//extra
@property (nonatomic, strong) NSArray       *extSymbol;
@property (nonatomic, strong) NSArray       *extSymbolArray;
@property (nonatomic, assign) NSUInteger    type;
//ui
@property (nonatomic, strong) SLAttributedLabel* contentSLabel;
//uiSize
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) CGSize contentlabelSize;


////////////////////////////////////////////////////////////////////////////////////////////////////
//父评论者
@property (nonatomic, assign) NSString                  *parentId;
@property (nonatomic, assign) NSString                  *paCommenterId;
@property (nonatomic, strong) NSString                  *parentNick;
//父评论内容相关
@property (nonatomic, strong) NSString                  *parentContent;
@property (nonatomic, strong) TBSCCommentCommodityItem  *commentCommodityParentItem;
@property (nonatomic, strong) NSString                  *imageParentName;
@property (nonatomic, assign) TBSCCommentContentType    parentContentType;
//父评论extra
@property (nonatomic, strong) NSArray                   *parentExtSymbol;
@property (nonatomic, strong) NSArray                   *parentExtSymbolArray;
@property (nonatomic, assign) NSUInteger                parentType;
//父评论ui
@property (nonatomic, strong) SLAttributedLabel         *parentContentSLabel;
//uiSize
@property (nonatomic, assign) CGFloat                   parentContentHeight;
@property (nonatomic, assign) CGSize                    parentContentlabelSize;
////////////////////////////////////////////////////////////////////////////////////////////////////

//@property (nonatomic, assign) BigNumberType   favourCount;
//@property (nonatomic, assign) BOOL            isPraised; //是否已加赞
//@property (nonatomic, assign) BOOL            isParentPraised; //是否已加赞
//other
@property (nonatomic, assign) BOOL          isImageHadLoad;//图片是否已加载
@property (nonatomic, assign) BOOL          isParentNickShowAsMine;//当别人回复我的评论时，是否父评论里的昵称显示为‘我’
@property (nonatomic, strong) NSString      * detailUrl;

////////////////////////////////////////////////////////////////////////////////////////////////////


-(CGFloat)getCellHeight;
-(CGFloat)getContentHeight:(TBSCCommentContentType)contentType isParentComment:(BOOL)isParentComment;
-(CGFloat)getContentHeightNoText:(TBSCCommentContentType)contentType;

-(void)setCommentCommodityItem:(TBSCCommentCommodityItem*)item;
-(NSString*)getCommentContentPicName;
-(TBSCCommentCommodityItem*)getCommentContentCommodityItem;
-(CGSize)bubbleSizeWithText:(NSString *)text witFontWidth:(CGFloat)fontFloat isParentContent:(BOOL)isParentContent;

//parent
-(BOOL)hasParentComment;
-(void)setCommentCommodityParentItem:(TBSCCommentCommodityItem*)item;
-(NSString*)getCommentParentContentPicName;
-(TBSCCommentCommodityItem*)getCommentParentContentCommodityItem;

@end

//父评论item
@interface TBSCCommentParentItem : TBModel

@end


@interface TBSCCommentImageItem : TBModel
@property (nonatomic, strong) NSString*		picName;

@end

@interface TBSCCommentCommodityItem : TBModel

@property (nonatomic, strong) NSString*		price;//价格

@property (nonatomic, assign) LongIdType    itemId;//商品Id

@property (nonatomic, strong) NSString*		title;//标题

@property (nonatomic, strong) NSString*		itemPic;//图片

@property (nonatomic, strong) NSString *    totalSoldQuantity;//已售数量

-(NSString *)getTotalSoldQuantityNum;
-(void)setFeedCommentCommodityItem:(TBSCCommentCommodityItem*)feedCommentCommodityItem;

@end
