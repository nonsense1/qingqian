//
//  MapViewController.m
//  frameTest
//
//  Created by 丰收 on 16/8/11.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MapViewController.h"


@interface MapViewController ()
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    

    MKMapItem *mylocation = [MKMapItem mapItemForCurrentLocation];
    NSLog(@"%@",mylocation);
    mylocation.name  =@"我的位置";
    NSString *currlati =[[NSUserDefaults standardUserDefaults] objectForKey:@"lat"];
    float currentLat = currlati.floatValue;
    NSString *currlongi = [[NSUserDefaults standardUserDefaults] objectForKey:@"lng"];
    float currentLong  = currlongi.floatValue;
    
    NSLog(@"%f++++%f",currentLat,currentLong);
    NSLog(@"%f----%f",self.latitude,self.longitude);
    CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake(currentLat, currentLong);
    
    CLLocationCoordinate2D coords2 = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    MKPlacemark *placeMark1 = [[MKPlacemark alloc]initWithCoordinate:coords1 addressDictionary:nil];
    MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:placeMark1];
    MKPlacemark *placeMark2 = [[MKPlacemark alloc] initWithCoordinate:coords2 addressDictionary:nil];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:placeMark2];
    toLocation.name = @"目的地";
    NSArray *items = [NSArray arrayWithObjects:currentLocation,toLocation, nil];
    NSDictionary *option = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsMapTypeKey:[NSNumber numberWithInteger:MKMapTypeStandard],MKLaunchOptionsShowsTrafficKey:@YES};
    [MKMapItem openMapsWithItems:items launchOptions:option];
   
    
    
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
