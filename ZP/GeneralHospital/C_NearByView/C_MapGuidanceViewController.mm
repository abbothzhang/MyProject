//
//  B2MapViewController.m
//  SmartLeadingExamining
//
//  Created by 夏科杰 on 15/1/7.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import "C_MapGuidanceViewController.h"
#import "UXActionSheet.h"
#import "Masonry.h"
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]
#define ISIOS6 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=6)
@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@interface UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end

@implementation UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
    CGContextRotateCTM(bitmap, M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end




@implementation C_MapGuidanceViewController
@synthesize target,location,pharmacyName;
#pragma mark - IOS 5 Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}
#pragma mark - IOS 6 Rotation
- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;//UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
-(void)initParameter
{
    Candrive=YES;
    BeginCityName=nil;
    EndCityName=nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParameter];
    
    
    WS(ws);
    self.title=@"地图导航";
    self.view.backgroundColor = UIColorFromRGB(0xefefef);
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    MRouteSearch = [[BMKRouteSearch alloc]init];
    _locService = [[BMKLocationService alloc]init];
    
    
    MapView=[[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHE-64)];
    MapView.delegate = self;
    trafficState=1;
    [MapView setCenterCoordinate:target];
    MapView.mapType = trafficState;
    MapView.showMapScaleBar = true;
    MapView.mapScaleBarPosition = CGPointMake(10, 20);
    MapView.zoomLevel = 16;
    MapView.overlooking = -30;
    [self.view addSubview:MapView];
 
    [MapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    RouteAnnotation* item = [[RouteAnnotation alloc]init];
    item.type=100;
    item.coordinate = target;
    item.title = pharmacyName;
    [MapView addAnnotation:item];
    
    UIButton *trafficBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    trafficBtn.tag=1;
    [trafficBtn setImage:[UIImage imageNamed:@"B2_Resources.bundle/icon_traffic_control@2x.png"] forState:UIControlStateNormal];
    [trafficBtn setImage:[UIImage imageNamed:@"B2_Resources.bundle/icon_traffic_control_enable@2x.png"] forState:UIControlStateSelected];
    [trafficBtn addTarget:self action:@selector(trafficAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:trafficBtn];
    [trafficBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.lessThanOrEqualTo(@-10);
        make.top.lessThanOrEqualTo(@10);
    }];
    
    mapTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mapTypeBtn.tag=1;
    [mapTypeBtn setImage:[UIImage imageNamed:@"B2_Resources.bundle/icon_map_setting_normal@2x.png"] forState:UIControlStateNormal];
    [mapTypeBtn setImage:[UIImage imageNamed:@"B2_Resources.bundle/icon_map_setting_normal@2x.png"] forState:UIControlStateSelected];
    [mapTypeBtn addTarget:self action:@selector(mapTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mapTypeBtn];
    
    [mapTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.lessThanOrEqualTo(@-10);
        make.top.lessThanOrEqualTo(@60);
    }];
    
    UIButton *selfLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    [selfLocation setImage:[UIImage imageNamed:@"B2_Resources.bundle/icon_location_button@2x.png"] forState:UIControlStateNormal];
    [selfLocation setImage:[UIImage imageNamed:@"B2_Resources.bundle/icon_location_button@2x.png"] forState:UIControlStateSelected];
    [selfLocation addTarget:self action:@selector(selfAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selfLocation];
    [selfLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.lessThanOrEqualTo(@-10);
        make.top.lessThanOrEqualTo(@120);
    }];
    
    
    UIImageView *viewBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"B2_Resources.bundle/b2_by_way_back.png"]];
    viewBack.frame = CGRectMake(9, SCREEN_HIGHE-70-49,SCREEN_WIDTH-18,49);
    viewBack.userInteractionEnabled = YES;
    [self.view addSubview:viewBack];
    
    [viewBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(302, 49));
        make.centerX.equalTo(ws.view);
        make.bottom.equalTo(ws.view).offset(-15);
    }];
    
    NSArray* triffArray= [NSArray arrayWithObjects:
                          @[@"B2_Resources.bundle/b2_by_car.png",@"B2_Resources.bundle/b2_by_car_clicked.png"],
                          @[@"B2_Resources.bundle/b2_by_bus.png",@"B2_Resources.bundle/b2_by_bus_clicked.png"],
                          @[@"B2_Resources.bundle/b2_by_foot.png",@"B2_Resources.bundle/b2_by_foot_clicked.png"],
                          nil];
    
    for (int i=0; i<3; i++) {
        UIButton *triffBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        triffBtn.frame = CGRectMake(i*100, 0, 100, 50);
        triffBtn.tag=i;
        [triffBtn setImage:[UIImage imageNamed:[[triffArray objectAtIndex:i] objectAtIndex:0]] forState:UIControlStateNormal];
        [triffBtn setImage:[UIImage imageNamed:[[triffArray objectAtIndex:i] objectAtIndex:1]] forState:UIControlStateHighlighted];
        [triffBtn setImage:[UIImage imageNamed:[[triffArray objectAtIndex:i] objectAtIndex:1]] forState:UIControlStateSelected];
        [triffBtn addTarget:self action:@selector(triffAction:) forControlEvents:UIControlEventTouchUpInside];
        [viewBack addSubview:triffBtn];
        
    }
    mapTypeView=[[UIView alloc] init];
    mapTypeView.hidden=YES;
    mapTypeView.backgroundColor=UIColorFromRGBA(0x1f62d6,0.5);
    [[mapTypeView layer] setMasksToBounds:YES];
    [[mapTypeView layer] setCornerRadius:2];
    [self.view addSubview:mapTypeView];
    [mapTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws.view).centerOffset(CGPointMake(SCREEN_HIGHE, 0));
        make.size.mas_equalTo(CGSizeMake(300,150));
    }];
    
    NSArray* labelArray=@[@"2D平面图",@"3D俯视图",@"卫星图"];
    for (int i=0; i<3; i++) {
        UIButton *upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        upBtn.frame = CGRectMake(8.25+97.25*i, 20, 89, 58);
        upBtn.tag=i;
        [upBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"B2_Resources.bundle/map_setting_view_btn_%d.png",i]] forState:UIControlStateNormal];
        [upBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"B2_Resources.bundle/map_setting_view_btn_%d.png",i]] forState:UIControlStateSelected];
        [upBtn addTarget:self action:@selector(UpAction:) forControlEvents:UIControlEventTouchUpInside];
        [mapTypeView addSubview:upBtn];
        
        UILabel* upLabel=[[UILabel alloc] initWithFrame:CGRectMake(8.25+97.25*i, 88, 89, 20)];
        upLabel.text=[labelArray objectAtIndex:i];
        upLabel.textAlignment=NSTextAlignmentCenter;
        upLabel.textColor=[UIColor whiteColor];
        upLabel.backgroundColor=[UIColor clearColor];
        [mapTypeView addSubview:upLabel];
        
        
    }
    
    
    // Do any additional setup after loading the view.
}


- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}
-(void)viewWillAppear:(BOOL)animated {
    [MapView viewWillAppear];
    MapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    MRouteSearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _geocodesearch.delegate = self;
    [self startLocService];
    [self onClickReverseGeocode:target];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [MapView viewWillDisappear];
    MapView.delegate = nil; // 不用时，置nil
    MRouteSearch.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _geocodesearch.delegate = nil;
    [self stopLocService];
    
}
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        if (BeginCityName==nil) {
            BeginCityName=[[NSString alloc] initWithFormat:@"%@",result.addressDetail.city];
        }else
        {
            EndCityName=[[NSString alloc] initWithFormat:@"%@",result.addressDetail.city];
        }
        NSLog(@"%@------%@",BeginCityName,EndCityName);
        if ([BeginCityName isEqualToString:EndCityName]) {
            Candrive=YES;
        }
    }
}

-(void)onClickReverseGeocode:(CLLocationCoordinate2D)localpoint
{
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = localpoint;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}

-(void)stopLocService
{
    [_locService stopUserLocationService];
    MapView.showsUserLocation = NO;//先关闭显示的定位图层
    
}

-(void)startLocService
{
    [_locService startUserLocationService];
    MapView.showsUserLocation = NO;//显示定位图层
    MapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    MapView.showsUserLocation = YES;//显示定位图层
}


-(void)naviMap:(UIButton*)sender
{
    
}

-(void)selfAction:(UIButton *)sender
{
    
    if (MapView.userTrackingMode==BMKUserTrackingModeFollow) {
        [self startFollowHeading];
    }else if(MapView.userTrackingMode==BMKUserTrackingModeFollowWithHeading)
    {
        [self startLocation];
    }else if(MapView.userTrackingMode==BMKUserTrackingModeNone)
    {
        [self startFollowing];
    }
    
}
//普通态
-(void)startLocation
{
    NSLog(@"进入普通定位态");
    
    MapView.showsUserLocation = NO;//先关闭显示的定位图层
    MapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    MapView.showsUserLocation = YES;//显示定位图层
}


//跟随态
-(void)startFollowing
{
    NSLog(@"进入跟随态");
    MapView.showsUserLocation = NO;
    MapView.userTrackingMode = BMKUserTrackingModeFollow;
    MapView.showsUserLocation = YES;
    
}
//罗盘态
-(void)startFollowHeading
{
    NSLog(@"进入罗盘态");
    MapView.showsUserLocation = NO;
    MapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    MapView.showsUserLocation = YES;
    
}
//停止定位
-(void)stopLocation
{
    MapView.userTrackingMode = BMKUserTrackingModeNone;
    MapView.showsUserLocation = NO;
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [MapView updateLocationData:userLocation];
    if (userLocation != nil) {
        if (selfLocat.latitude==0) {
            [self onClickReverseGeocode:userLocation.location.coordinate];
        }
        selfLocat=userLocation.location.coordinate;
        NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    }
    //  NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    if (userLocation != nil) {
        if (selfLocat.latitude==0) {
            [self onClickReverseGeocode:userLocation.location.coordinate];
        }
        selfLocat=userLocation.location.coordinate;
        // NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    }
    [MapView updateLocationData:userLocation];
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

-(void)UpAction:(UIButton *)sender
{
    [mapTypeBtn setTag:1];
    [mapTypeBtn setImage:[UIImage imageNamed:@"B2_Resources.bundle/icon_map_setting_normal@2x.png"] forState:UIControlStateNormal];
    [mapTypeBtn setImage:[UIImage imageNamed:@"B2_Resources.bundle/icon_map_setting_normal@2x.png"] forState:UIControlStateSelected];
    WS(ws);
    [mapTypeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws.view).centerOffset(CGPointMake(SCREEN_HIGHE, 0));
        make.size.mas_equalTo(CGSizeMake(300,150));
    }];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         [mapTypeView layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         mapTypeView.hidden=YES;
                     }
     ];
    
    switch ([sender tag]) {
        case 0:
            MapView.showsUserLocation = NO;//先关闭显示的定位图层
            MapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
            MapView.mapType = BMKMapTypeStandard;
            MapView.showsUserLocation = YES;//显示定位图层
            
            break;
        case 1:
        {
            MapView.showsUserLocation = NO;
            MapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
            MapView.showsUserLocation = YES;
        }
            break;
        case 2:
            MapView.mapType = BMKMapTypeSatellite;
            break;
            
        default:
            break;
    }
}

#pragma mark 选择地图类型效果
-(void)mapTypeAction:(UIButton* )sender
{   WS(ws);
    if ([sender tag]==1) {
        [sender setTag:2];
        [sender setImage:[UIImage imageNamed:@"B2_Resources.bundle/map_setting_view_btn_close@2x.png"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"B2_Resources.bundle/map_setting_view_btn_close@2x.png"] forState:UIControlStateSelected];
        
        mapTypeView.hidden=NO;
        [mapTypeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(ws.view);
            make.size.mas_equalTo(CGSizeMake(300,150));
        }];
        [UIView animateWithDuration:0.5 animations:^{
            [mapTypeView layoutIfNeeded];
        }];
        
    }else{
        [sender setTag:1];
        [sender setImage:[UIImage imageNamed:@"B2_Resources.bundle/icon_map_setting_normal@2x.png"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"B2_Resources.bundle/icon_map_setting_normal@2x.png"] forState:UIControlStateSelected];
        
        [mapTypeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(ws.view).centerOffset(CGPointMake(SCREEN_HIGHE, 0));
            make.size.mas_equalTo(CGSizeMake(300,150));
        }];
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             [mapTypeView layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             mapTypeView.hidden=YES;
                         }
         ];
        
        
    }
}



-(void)trafficAction:(UIButton* )sender
{
    
    if (MapView.isTrafficEnabled) {
        [MapView setTrafficEnabled:NO];
        [sender setImage:[UIImage imageNamed:@"B2_Resources.bundle/icon_traffic_control@2x.png"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"B2_Resources.bundle/icon_traffic_control_enable@2x.png"] forState:UIControlStateSelected];
    }else
    {
        [MapView setTrafficEnabled:YES];
        [sender setImage:[UIImage imageNamed:@"B2_Resources.bundle/icon_traffic_control_enable@2x.png"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"B2_Resources.bundle/icon_traffic_control@2x.png"] forState:UIControlStateSelected];
    }
}



#pragma mark - 交通工具搜索方法
-(void)triffAction:(UIButton *)sender
{
    switch ([sender tag]) {
        case 0:
            [self onClickDriveSearch];
            break;
        case 1:
        {
            if (Candrive) {
                [self onClickBusSearch];
            }else
            {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                      message:@"本地图暂不支持不同城市之间公交导航"
                                                                     delegate:self
                                                            cancelButtonTitle:nil
                                                            otherButtonTitles:@"确定",nil];
                [myAlertView show];
            }
            
        }
            break;
        case 2:
        {
            if (Candrive) {
                [self onClickWalkSearch];
            }else
            {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                      message:@"本地图暂不支持不同城市之间步行导航"
                                                                     delegate:self
                                                            cancelButtonTitle:nil
                                                            otherButtonTitles:@"确定",nil];
                [myAlertView show];
            }
            
        }
            
            break;
            
        default:
            break;
    }
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        case 100:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"renameMark"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"renameMark"];
                view.canShowCallout = TRUE;
                
                view.selected=YES;
                
                UIButton *naviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                naviBtn.backgroundColor = [UIColor clearColor];
                [naviBtn addTarget:self action:@selector(showAllMap) forControlEvents:UIControlEventTouchUpInside];
                [naviBtn setImage:[UIImage imageNamed:@"B2_Resources.bundle/b2_anjuke_icon_to_position@2x.png"] forState:UIControlStateNormal];
                [naviBtn setImage:[UIImage imageNamed:@"B2_Resources.bundle/b2_anjuke_icon_to_position1@2x.png"] forState:UIControlStateHighlighted];
                naviBtn.frame = CGRectMake(0, 0, 60, 42);
                [[naviBtn layer] setMasksToBounds:YES];
                [[naviBtn layer] setCornerRadius:2];
                
                [[naviBtn layer]setBorderWidth:1];
                [[naviBtn layer]setBorderColor:[UIColorFromRGB(0x888888) CGColor]];
                
                view.rightCalloutAccessoryView=naviBtn;
            } else {
                [view setNeedsDisplay];
            }
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/pin_purple.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
    }
    return nil;
    
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:MapView.annotations];
    [MapView removeAnnotations:array];
    array = [NSArray arrayWithArray:MapView.overlays];
    [MapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        int size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [MapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [MapView addAnnotation:item]; // 添加起点标注
            }
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [MapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [MapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
    }
    
}
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:MapView.annotations];
    [MapView removeAnnotations:array];
    array = [NSArray arrayWithArray:MapView.overlays];
    [MapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        int size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [MapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [MapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [MapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [MapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [MapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        
        
    }
}

- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:MapView.annotations];
    [MapView removeAnnotations:array];
    array = [NSArray arrayWithArray:MapView.overlays];
    [MapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        int size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [MapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [MapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [MapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [MapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        
        
    }
    
}

-(void)showAllMap
{
    
    UXActionSheet *actionSheet=[[UXActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"导航到%@",pharmacyName]
                                                  cancelButtonTitle:@"取消"
                                                               show:^(long index) {
                                                                   switch (index) {
                                                                       case 0:
                                                                       {
                                                                           //初始化调启导航时的参数管理类
                                                                           BMKNaviPara* para = [[BMKNaviPara alloc]init];
                                                                           //指定导航类型
                                                                           para.naviType = BMK_NAVI_TYPE_NATIVE;
                                                                           
                                                                           //初始化终点节点
                                                                           BMKPlanNode* end = [[BMKPlanNode alloc]init];
                                                                           //指定终点经纬度
                                                                           
                                                                           end.pt = target;
                                                                           //指定终点名称
                                                                           end.name =pharmacyName;
                                                                           //指定终点
                                                                           para.endPoint = end;
                                                                           
                                                                           //指定返回自定义scheme
                                                                           para.appScheme = @"jjry://";
                                                                           
                                                                           //调启百度地图客户端导航
                                                                           [BMKNavigation openBaiduMapNavigation:para];
                                                                       }
                                                                           break;
                                                                       case 1:
                                                                       {
                                                                           NSURL *urlStr = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?saddr=%.8f,%.8f&daddr=%.8f,%.8f&directionsmode=transit",selfLocat.latitude,selfLocat.longitude,target.latitude,target.longitude]];
                                                                           if ([[UIApplication sharedApplication] canOpenURL:urlStr]) {
                                                                               
                                                                               [[UIApplication sharedApplication] openURL:urlStr];
                                                                           }else{
                                                                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/google-maps/id585027354?mt=8"]];
                                                                           }
                                                                           
                                                                       }
                                                                           break;
                                                                       case 2:
                                                                       {
                                                                           NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"iosamap://navi?sourceApplication=broker&backScheme=openbroker2&poiname=%@&poiid=BGVIS&lat=%.8f&lon=%.8f&dev=1&style=2",@"",target.latitude,target.longitude]];
                                                                           [[UIApplication sharedApplication] openURL:url];
                                                                       }
                                                                           break;
                                                                       case 3:
                                                                       {
                                                                           if (!ISIOS6) {//ios6 调用goole网页地图
                                                                               NSString *urlString = [[NSString alloc]
                                                                                                      initWithFormat:@"http://maps.google.com/maps?saddr=&daddr=%.8f,%.8f&dirfl=d",target.latitude,target.longitude];
                                                                               
                                                                               NSURL *aURL = [NSURL URLWithString:urlString];
                                                                               [[UIApplication sharedApplication] openURL:aURL];
                                                                           }else{//ios7 跳转apple map
                                                                               
                                                                               
                                                                               MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
                                                                               MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:target addressDictionary:nil]];
                                                                               
                                                                               toLocation.name = pharmacyName;
                                                                               [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil] launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil] forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
                                                                           }
                                                                           
                                                                       }
                                                                           break;
                                                                           
                                                                       default:
                                                                           break;
                                                                   }
                                                                   
                                                               }
                                                             cancel:^{
                                                                 
                                                             }
                                                        selectArray:nil
                                                  otherButtonTitles:@"百度地图", @"谷歌地图",@"高德地图",@"苹果地图",nil];
    
    
}


-(void)onClickBusSearch
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = selfLocat;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = target;
    NSLog(@"%@---%@",start,end);
    BMKTransitRoutePlanOption *transitMRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitMRouteSearchOption.city= BeginCityName;
    transitMRouteSearchOption.from = start;
    transitMRouteSearchOption.to = end;
    BOOL flag = [MRouteSearch transitSearch:transitMRouteSearchOption];
    
    if(flag)
    {
        NSLog(@"bus检索发送成功");
    }
    else
    {
        NSLog(@"bus检索发送失败");
    }
}


// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    if (view.annotation.title!=nil&&[view.annotation.title length]>0&&view.annotation.coordinate.latitude>0&&view.annotation.coordinate.longitude) {
        [self showAllMap];
    }
    NSLog(@"paopaoclick,%@,%f,%f",view.annotation.title,view.annotation.coordinate.latitude,view.annotation.coordinate.longitude);
}

-(void)onClickDriveSearch
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = selfLocat;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = target;
    NSLog(@"%@---%@",start,end);
    BMKDrivingRoutePlanOption *drivingMRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingMRouteSearchOption.from = start;
    drivingMRouteSearchOption.to = end;
    BOOL flag = [MRouteSearch drivingSearch:drivingMRouteSearchOption];
    if(flag)
    {
        NSLog(@"car检索发送成功");
    }
    else
    {
        NSLog(@"car检索发送失败");
    }
    
}


-(void)onClickWalkSearch
{
    NSLog(@"=====%f,%f",selfLocat.latitude,selfLocat.longitude);
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = selfLocat;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = target;
    BMKWalkingRoutePlanOption *walkingMRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkingMRouteSearchOption.from = start;
    walkingMRouteSearchOption.to = end;
    BOOL flag = [MRouteSearch walkingSearch:walkingMRouteSearchOption];
    
    if(flag)
    {
        NSLog(@"walk检索发送成功");
    }
    else
    {
        NSLog(@"walk检索发送失败");
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
