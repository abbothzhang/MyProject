//
//  B2_MapViewController.h
//  SmartLeadingExamining
//
//  Created by 夏科杰 on 15/1/7.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface C_MapGuidanceViewController : UcmedViewStyle<BMKMapViewDelegate, BMKRouteSearchDelegate,BMKLocationServiceDelegate,UIActionSheetDelegate,BMKGeoCodeSearchDelegate>
{
    BMKMapView* MapView;
    BMKRouteSearch* MRouteSearch;
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
    int trafficState;//交通状态
    UIView* mapTypeView;//弹出选择视图
    UIButton *mapTypeBtn;//地图类型按钮
    CLLocationCoordinate2D selfLocat;//当前坐标
    NSString *BeginCityName;
    NSString *EndCityName;
    bool     Candrive;
    BMKAnnotationView* newAnnotation;
    
    
}
@property(nonatomic,assign) CLLocationCoordinate2D target;
@property(nonatomic,assign) CLLocationCoordinate2D location;
@property(nonatomic,strong) NSString* pharmacyName;
@end
