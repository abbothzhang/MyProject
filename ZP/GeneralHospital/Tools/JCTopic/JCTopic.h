//
//  JCTopic.h
//  PSCollectionViewDemo
//
//  Created by jc on 14-1-7.
//
//

#import <UIKit/UIKit.h>
@protocol JCTopicDelegate<NSObject>
-(void)didClick:(id)data;
-(void)currentPage:(int)page total:(NSUInteger)total;
@end
typedef NS_ENUM(NSInteger, JCTopicStyle) {
    JCTopicLeft=0,
    JCTopicMiddle,
    JCTopicRight,
};
@interface JCTopic : UIScrollView<UIScrollViewDelegate>{
    bool flag;
    int scrollTopicFlag;
    NSTimer * scrollTimer;
    int currentPage;
    CGSize imageSize;
    UIImage *image;
    UIPageControl *pageControl;
    UILabel * title;
}
@property(nonatomic,strong) NSArray      *pics;
@property(nonatomic,assign) NSInteger    totalNum;
@property(nonatomic,assign) CGRect       rect;
@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,assign) JCTopicStyle    type;
@property(nonatomic,retain)id<JCTopicDelegate> JCdelegate;
-(void)releaseTimer;
-(void)upDate;
@end
