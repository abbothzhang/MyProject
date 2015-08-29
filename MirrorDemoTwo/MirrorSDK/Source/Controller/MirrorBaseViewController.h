//
//  MirrorBaseViewController.h
//  MirrorSDK
//
//  Created by 龙冥 on 10/15/14.
//  Copyright (c) 2014 Taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MirrorLayoutSubViewsDelegate <NSObject>

@optional

- (void)layoutSubviews;

@end

@interface MirrorUILayoutSubView : UIView {
@private
    __unsafe_unretained id <MirrorLayoutSubViewsDelegate> _delegate;
}

@property (nonatomic,assign) id<MirrorLayoutSubViewsDelegate> delegate;

@end

@interface MirrorBaseViewController : UIViewController <MirrorLayoutSubViewsDelegate> {
@private
    NSString *_paramURLArgs;
    UIView *_errorView;
}

@property (nonatomic,strong) NSString *paramURLArgs;

- (void)layoutSubviews;
- (void)showToast:(NSString *)text;

@end
