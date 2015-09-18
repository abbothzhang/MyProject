//
//  EGORefreshTableHeadView.h
//  掌握健康ios 6
//
//  Created by yyq on 13-1-11.
//  Copyright (c) 2013年 夏 科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	EGOOPullRefreshPulling1 = 0,
	EGOOPullRefreshNormal1,
	EGOOPullRefreshLoading1,
    EGOOPullRefreshFinish1,
} EGOPullRefreshState1;

@protocol EGORefreshTableHeadeDelegate;
@interface EGORefreshTableHeadView : UIView {
	
	id _delegate;
	EGOPullRefreshState1 _state;
    
    
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
	
}

@property(nonatomic,assign) id <EGORefreshTableHeadeDelegate> delegate;

- (void)refreshLastUpdatedDate;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView isFinish:(BOOL)isFinish;

@end
@protocol EGORefreshTableHeadeDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeadView*)view;
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeadView*)view;
@optional
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeadView*)view;
@end
