//
//  TBSCConst.h
//  SocializeSDK
//
//  Created by Wan Wentao on 14/11/24.
//  Copyright (c) 2014年 rocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBSCUtils.h"

@interface TBSCConst : NSObject

#define TBSC_NO_NETWORK_ALERT           @"没有网络哦，检查一下系统设置"
#define BASIC_SERVICE_ERROR_ALERT       @"小二很忙，系统很累，请稍后重试"
#define SERVICE_ERROR_ALERT             @"服务器在偷懒，再试试吧"


#define     TBSCPraiseAddOperationNotification          @"TBSCPraiseAddOperationSuccessNotification"
#define     TBSCPraiseRemoveOperationNotification       @"TBSCPraiseRemoveOperationSuccessNotification"
#define     TBSCNewCommentSucceedNotification           @"TBSCNewCommentSucceedNotification"
#define     TBSCCommentDeleteSucceedNotification        @"TBSCCommentDeleteSucceedNotification"


//评论列表
#define COMMENT_PAGE_SIZE           10

//UI
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGB_A(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define SCITEM_HEIGHT       (49 * SCSIZE_SCALE)
#define SCITEM_WIDTH        (60 * SCSIZE_SCALE)

#define BOARDER_BIG                      12 * SCSIZE_SCALE
#define BOARDER_STAND                    8 * SCSIZE_SCALE
#define BOARDER_SMALL                    6 * SCSIZE_SCALE

#define CELL_MIN_HEIGHT                   72 * SCSIZE_SCALE
#define CELL_PADING_TOP                   16 * SCSIZE_SCALE
#define CELL_PADING_BOTTOM                16 * SCSIZE_SCALE
#define CELL_PADING_LEFT                  12 * SCSIZE_SCALE
#define CELL_PADING_RIGHT                 12 * SCSIZE_SCALE



#define CELL_HEAD_HEIGHT                  14 * SCSIZE_SCALE //48
#define CELL_BOTTOM_HEIGHT                36 * SCSIZE_SCALE //16

#define CELL_ICON_WITH                  40
#define CELL_ICON_HEIGHT                40

#define CELL_CONTENTVIEW_WITH                 248 * SCSIZE_SCALE
#define CELL_PARENT_CONTENTVIEW_WITH          224 * SCSIZE_SCALE




#define TBSC_FLOOR_MAX_WIDTH         100 * SCSIZE_SCALE
#define TBSC_FLOOR_MAX_HEIGHT        16 * SCSIZE_SCALE

//font
#define DEFAULT_TEXT_FONT [UIFont fontWithName:@"Helvetica" size:14.0f]
#define DEFAULT_TEXT_BOLDFONT [UIFont fontWithName:@"Helvetica-Bold" size:14.0f]
#define PARENT_TEXT_FONT [UIFont fontWithName:@"Helvetica" size:14.0f]
#define PARENT_TEXT_BOLDFONT [UIFont fontWithName:@"Helvetica-Bold" size:14.0f]

#define  SCSIZE_SCALE       [TBSCUtils iphoneScaleAdapt]
#define Target_LoadAllImage_Speed 0.1

@end
