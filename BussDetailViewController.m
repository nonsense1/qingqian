//
//  BussDetailViewController.m
//  frameTest
//
//  Created by 蔡晓宇 on 16/8/9.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BussDetailViewController.h"
#import "SDAutoLayout.h"
//#import "MapViewController.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import <MapKit/MapKit.h>
#define BUSS @"http://ios.lsxfpt.com/app/shop/detail.html"
#define W sview.frame.size.width
#define H sview.frame.size.height
@interface BussDetailViewController (){
    NSString *photo;
    UIScrollView *sview;
    NSString *shop_name;
    NSString *cate;
    NSString *addr;
    NSString *business_time;
    NSString *details;
    NSString *prantname;
    NSString *tel;
    float lat;
    float lng;
}

@end

@implementation BussDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
     sview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:sview];
    sview.scrollEnabled =YES;
    sview.contentSize = CGSizeMake(0, self.view.frame.size.height+300);
    sview.backgroundColor =[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
//    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    [self download];
    
    
    
}

-(void)creatUI{
    UIImageView *image = [[UIImageView alloc]init];
    image.backgroundColor =[UIColor whiteColor];
    [sview addSubview:image];
    image.sd_layout
    .topSpaceToView(sview,0)
    .leftSpaceToView(sview,0)
    .heightIs(300)
    .widthIs(W);
//    [image setBackgroundColor:[UIColor redColor]];
    NSLog(@"%@",photo);
    
    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ios.lsxfpt.com/attachs/%@",photo]]];
    
    UIView *views = [[UIView alloc]init];
    [sview addSubview:views];
    views.sd_layout
    .topSpaceToView(image,0)
    .leftSpaceToView(sview,0)
    .heightIs(80)
    .widthIs(W);
        views.backgroundColor = [UIColor whiteColor];
    
    UILabel *lbname = [[UILabel alloc]init];
    [views addSubview:lbname];
    lbname.font = [UIFont systemFontOfSize:15];
    lbname.sd_layout
    .topSpaceToView(views,10)
    .leftSpaceToView(views,10)
    .heightIs(30)
    .widthIs(300);
    
  
    lbname.text = shop_name;
  
   
    
    UILabel *lbex = [[UILabel alloc]init];
    [views addSubview:lbex];
    lbex.sd_layout
    .topSpaceToView(lbname,5)
    .leftSpaceToView(views,10)
    .heightIs(30)
    .widthIs(150);
    lbex.font = [UIFont systemFontOfSize:12];
    lbex.text = [NSString stringWithFormat:@"%@--%@",prantname,cate];

    
    
    
    UIView *viewtwo = [[UIView alloc]init];
    viewtwo.userInteractionEnabled = YES;
    [sview addSubview:viewtwo];
    viewtwo.backgroundColor = [UIColor whiteColor];
    viewtwo.sd_layout
    .topSpaceToView(views,10)
    .leftSpaceToView(sview,0)
    .heightIs(60)
    .widthIs(W);
    
    UIImageView *imageV= [[UIImageView alloc]init];
    [viewtwo addSubview:imageV];
    imageV.sd_layout
    .topSpaceToView(viewtwo,10)
    .leftSpaceToView(viewtwo,0)
    .heightIs(30)
    .widthIs(30);
    imageV.image = [UIImage imageNamed:@"zuobiao"];
    [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(daohang)]];
    
    
    UILabel *location = [[UILabel alloc]init];
    [viewtwo addSubview:location];
    location.userInteractionEnabled = YES;
    location.sd_layout
    .topSpaceToView(viewtwo,15)
    .leftSpaceToView(viewtwo,30)
    .heightIs(30)
    .widthIs(W-150);
    location.numberOfLines =2;
    location.text = addr;
    location.font = [UIFont systemFontOfSize:12];
    [location addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(daohang)]];
    
    
    
    UILabel *lb1 = [[UILabel alloc]init];
    [viewtwo addSubview:lb1];
    lb1.sd_layout
    .topSpaceToView(viewtwo,10)
    .leftSpaceToView(location,15)
    .heightIs(40)
    .widthIs(1);
    lb1.backgroundColor = [UIColor grayColor];
    
    UIButton *btn = [[UIButton alloc]init];
    [viewtwo addSubview:btn];
    btn.sd_layout
    .topSpaceToView(viewtwo,10)
    .rightSpaceToView(viewtwo,25)
    .heightIs(40)
    .widthIs(40);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];

    UIView*viewthree = [[UIView alloc]init];
    [sview addSubview:viewthree];
    viewthree.sd_layout
    .topSpaceToView(viewtwo,10)
    .leftSpaceToView(sview,0)
    .heightIs(60)
    .widthIs(W);
    viewthree.backgroundColor = [UIColor whiteColor];
    
    UILabel *timelb = [[UILabel alloc]init];
    [viewthree addSubview:timelb];
    timelb.text = @"营业时间：";
    timelb.sd_layout
    .topSpaceToView(viewthree,15)
    .leftSpaceToView(viewthree,10)
    .heightIs(30)
    .widthIs(80);
    
    timelb.font = [UIFont systemFontOfSize:12];
    
    
    UILabel * timeT = [[UILabel alloc]init];
    [viewthree addSubview:timeT];
    timeT.text = business_time;
    timeT.sd_layout
    .topSpaceToView(viewthree,15)
    .leftSpaceToView(timelb,0)
    .heightIs(30)
    .widthIs(150);
    
    
    CGSize size = [self sizeForCellContent:details fixMaxWidth:200];
    UIView *viewfour = [[UIView alloc]init];
    [sview addSubview:viewfour];
    viewfour.backgroundColor = [UIColor whiteColor];
    viewfour.sd_layout
    .topSpaceToView(viewthree,10)
    .leftSpaceToView(sview,0)
    .heightIs(size.height+30)
    .widthIs(W);
 
    
    UILabel*lbD = [[UILabel alloc]init];
    lbD.font = [UIFont systemFontOfSize:15];
    [viewfour addSubview:lbD];
    lbD.sd_layout
    .topSpaceToView(viewfour,5)
    .leftSpaceToView(viewfour,10)
    .heightIs(20)
    .widthIs(250);
    lbD.text = shop_name;

    lbD.numberOfLines =10;
    
    UILabel *lbZSY = [[UILabel alloc]init];
    [viewfour addSubview:lbZSY];
    lbZSY.font = [UIFont systemFontOfSize:12];
    lbZSY.text =details;
    lbZSY.numberOfLines =10;
    lbZSY.sd_layout
    .topSpaceToView(viewfour,30)
    .leftSpaceToView(viewfour,10)
    .widthIs(W-20)
    .heightIs(size.height);
    
   
   
    
    

    
}

-(void)download{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"%@",_shop);
    [manager GET:BUSS parameters:@{@"shop_id":_shop} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *detail = [dic objectForKey:@"detail"];
        NSDictionary *shopname = [detail objectForKey:@"shopcate_name"];
       cate = [shopname objectForKey:@"cate_name"];
        prantname = [shopname objectForKey:@"parentname"];
        NSLog(@"%@",dic);
        //电话
       tel = [detail objectForKey:@"tel"];
        
       photo = [detail objectForKey:@"photo"];
        
       shop_name = [detail objectForKey:@"shop_name"];
        
        addr = [detail objectForKey:@"addr"];
        NSString *lati =[detail objectForKey:@"lat"];
        lat = lati.floatValue;
        NSString *lngi = [detail objectForKey:@"lng"];
        lng = lngi.floatValue;
        NSDictionary *ex = [dic objectForKey:@"ex"];
        
        //营业时间
       business_time = [ex objectForKey:@"business_time"];
        //简介
        
        
        details = [ex objectForKey:@"details"];
        if ([details isEqual:[NSNull null]]) {
            details=@"";
        }
        
        
        [self creatUI];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}
//自适应高度
- (CGSize)sizeForCellContent:(NSString *)strContent fixMaxWidth:(CGFloat)w {
    // 先获取文字的属性，特别是影响文字所占尺寸相关的
    UIFont *font = [UIFont systemFontOfSize:14];
    // 把该属性放到字典中
    NSDictionary *dicAttr = [[NSDictionary alloc] initWithObjectsAndKeys:font,NSFontAttributeName, nil];
    // 通过字符串的计算文字所占尺寸方法获取尺寸
    CGSize size = [strContent boundingRectWithSize:CGSizeMake(w, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicAttr context:nil].size; // size: 指定计算后文字显示的最大宽度，高度无需指定，计算后可返回； options: 选项 通常使用 .....LineFragment...和...Font.... 这两个，其选项之间可进行或运算，一次可使用多个；前者是计算文本尺寸以每一行文本的矩形区域为单位，后者是以每个文字的字体属性计算后的尺寸算总数。
    // 在早期计算文字的尺寸，是用以size开头的方法，但这类方法从ios6开始已被弃用，在开发中不要再使用。要用上面的方法
    //    [strContent sizeWithFont:<#(UIFont *)#> constrainedToSize:<#(CGSize)#>]
    
    // 判断计算出的尺寸高度是否小于最小值 55 ＝ 45 ＋ 5+ 5
    if (size.height < 55) {
        size.height = 55; // 否则，可能会连头像都显示不全
    }
    
    return size;
}


- (void)daohang {
    
    MKMapItem *mylocation = [MKMapItem mapItemForCurrentLocation];
    NSLog(@"====%@",mylocation.placemark);
    
    NSString *currlati =[[NSUserDefaults standardUserDefaults] objectForKey:@"lat"];
    float currentLat = currlati.floatValue;
    NSString *currlongi = [[NSUserDefaults standardUserDefaults] objectForKey:@"lng"];
    float currentLong  = currlongi.floatValue;
    
    CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake(currentLat, currentLong);
    CLLocationCoordinate2D coords2 = CLLocationCoordinate2DMake(lat, lng);
    
    
    MKPlacemark *placeMark1 = [[MKPlacemark alloc]initWithCoordinate:coords1 addressDictionary:nil];
    MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:placeMark1];
    currentLocation.name = @"我的位置";
    
    
    MKPlacemark *placeMark2 = [[MKPlacemark alloc] initWithCoordinate:coords2 addressDictionary:nil];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:placeMark2];
    toLocation.name = addr;
    NSArray *items = [NSArray arrayWithObjects:currentLocation,toLocation, nil];
    NSDictionary *option = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsMapTypeKey:[NSNumber numberWithInteger:MKMapTypeStandard],MKLaunchOptionsShowsTrafficKey:@YES};
    [MKMapItem openMapsWithItems:items launchOptions:option];
    
}

-(void)btnClick:(UIButton *)btn{
    NSLog(@"%@",tel);
    //电话
    NSString *str3 = [NSString stringWithFormat:@"telprompt://%@",tel];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str3]];

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
