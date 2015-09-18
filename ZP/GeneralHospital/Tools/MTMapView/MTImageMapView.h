//
//  MTImageMapView.h
//  ImageMap
//
//  Created by Almighty Kim on 9/29/12.
//  Copyright (c) 2012 Colorful Glue. All rights reserved.
//

#import <UIKit/UIKit.h>

// in case you want to debug...
//#define DEBUG_MAP_AREA

@class MTImageMapView;

@protocol MTImageMapDelegate <NSObject>
-(void)imageMapView:(MTImageMapView *)inImageMapView
   didSelectMapArea:(NSUInteger)inIndexSelected;
@end

@interface MTImageMapView : UIImageView
{
    id<MTImageMapDelegate> delegate;
    NSMutableArray* array;
}
@property (nonatomic, assign) id<MTImageMapDelegate> delegate;
//-(void)touchAction:(CGPoint )touchPoint withEvent:(NSValue *)touchValue;
-(void)setMapping:(NSArray *)inArrMapping
        doneBlock:(void (^)(MTImageMapView *imageMapView))inBlockDone;
@end


