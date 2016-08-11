//
//  AppDelegate.m
//  frameTest
//
//  Created by mac on 16/6/21.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"
#define DINGWEI  @"http://ios.lsxfpt.com/Appv2/index/dingwei.html"
@interface AppDelegate ()<CLLocationManagerDelegate>{
    CLLocationManager *_locationManager;
    CLLocationDegrees dLatitude;
    CLLocationDegrees dLongitude;
}
@property(nonatomic,strong)CLGeocoder *geocoder;
@property(nonatomic,strong)CLLocationManager *locationManager;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [UIApplication sharedApplication].delegate configureAPIKey];
    
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *controller = [story instantiateViewControllerWithIdentifier:@"welcome"];
    self.window.rootViewController =controller;
    
    [self loacationweb];
    
    return YES;
}





//定位
-(void)loacationweb{
    
    //开启定位服务
    
    //判断设备是否可以使用定位服务 （如何判断 两个 一个是定位服务 另一个方向指示服务）
    
    if ([CLLocationManager locationServicesEnabled] == NO && [CLLocationManager headingAvailable] == NO)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        //程序返回
        return;
    }
    //往下设备可用
    if (_locationManager == nil) {
        
        //初始化定位管理者对象
        
        _locationManager = [[CLLocationManager alloc] init];
        //做定位的相关操作（设置）
        
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 1;
        //设置代理
        
        _locationManager.delegate = self;
        //设置方向转动的角度达到一定值（5度），回调相关方法  单位角度
        
        _locationManager.headingFilter = 100;
        _locationManager.headingOrientation = CLDeviceOrientationPortrait;
        
        //请求用户授权，自从iOS8开始需要手动请求用户授权
        //取到当前设备的版本号，如果大于8.0那就手动开启提示
        
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            
            //此方法请求的授权，仅限于用户在打开使用APP时允许使用系统的定位服务  （在应用使用期间）
            //                [_locationManager requestWhenInUseAuthorization];
            //请求的授权，除了可以在APP打开时允许定位服务，也可以在APP转入后台仍然可以使用定位服务  （永久）
            
            //            if (!_isAlwaysUse) {
            //                [_locationManager requestWhenInUseAuthorization];
            //            } else {
            //                [_locationManager requestAlwaysAuthorization];
            //            }
            //
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    //启动定位服务
    [_locationManager startUpdatingLocation];
    //启动方向定位服务
    [_locationManager startUpdatingHeading];
    
}
#pragma mark - 定位协议中方法 -




//定位失败的方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败：%@",error);
    
    if (error.code == kCLErrorDenied) {
        NSLog(@"用户不允许使用定位功能");
        
    }
    [self dingweiload];
    
}
//位置更新成功的方法 定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    NSLog(@"位置更新成功");
    NSLog(@"%@",locations);
    //取数组中最后一个元素 元素类型是CLLocation类型
    CLLocation *lastLocation = [locations lastObject];
    //(更了解  目的防止更新UI过快 用户体验不好以及上传数据库数据太快)
    static NSTimeInterval lastInterval;
    NSTimeInterval interval = [lastLocation.timestamp timeIntervalSince1970];
    //判断上次刷新label的时间和这次刷新label的时间的间隔小于1 不刷新 直接return返回
    if (abs(interval - lastInterval) < 50000) {
        return ;
    }
    //记录时间距离1970多少秒
    lastInterval = [lastLocation.timestamp timeIntervalSince1970];
    //获取经纬度 结构体
    CLLocationCoordinate2D coordinate = lastLocation.coordinate;
    //分别取出经度和纬度 （重点）
    dLatitude = coordinate.latitude;  //纬度
    dLongitude = coordinate.longitude; //经度
    NSLog(@"经度：%f 纬度：%f",dLongitude,dLatitude);
    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
    
    
    
    NSInteger dlatitud = [[NSString stringWithFormat:@"%f",dLongitude]integerValue];
    if (dlatitud >0) {
        [defaultes setObject:[NSString stringWithFormat:@"%f",dLatitude] forKey:@"lat"];
        [defaultes setObject:[NSString stringWithFormat:@"%f",dLongitude] forKey:@"lng"];
    }else{
        [defaultes setObject:[NSString stringWithFormat:@"%f",dLatitude] forKey:@"lat"];
        [defaultes setObject:[NSString stringWithFormat:@"%f",0-dLongitude] forKey:@"lng"];
    }
    [self dingweiload];
    
    
}
-(void)dingweiload{
    NSString *dlati=[NSString stringWithFormat:@"%f",dLatitude];
    NSString *dlongi = [NSString stringWithFormat:@"%f",dLongitude];
    NSLog(@"%@,%@",dlati,dlongi);
    
    if (dlati==nil) {
        dlati =@"";
    }
    if (dlongi ==nil) {
        dlongi =@"";
    }
    
    
    
    
    /* 判断网络连接*/
    AFNetworkReachabilityManager *rManager = [AFNetworkReachabilityManager sharedManager];
    [rManager startMonitoring];
    [rManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            NSLog(@"wulainjie");
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *controller = [story instantiateViewControllerWithIdentifier:@"tabbar"];
            self.window.rootViewController =controller;
        }else {
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager GET:DINGWEI parameters:@{@"lat":dlati,@"lng":dlongi} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSDictionary * msg = [dic objectForKey:@"msg"];
                NSString *city_id = [msg objectForKey:@"city_id"];
                NSString *name = [msg objectForKey:@"name"];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:city_id forKey:@"city_id"];
                [defaults setObject:name forKey:@"city"];
                [defaults setObject:name forKey:@"dingwei"];
                [defaults setObject:city_id forKey:@"dingwei_id"];
                
                [defaults setObject:city_id forKey:@"c_id"];
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *controller = [story instantiateViewControllerWithIdentifier:@"tabbar"];
                self.window.rootViewController =controller;
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];

        }
        
    }];
    
    
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
