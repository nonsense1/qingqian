//
//  HomepageViewControllerTableViewController.m
//  frameTest
//
//  Created by 许争妍 on 16/6/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HomepageViewControllerTableViewController.h"
#import "SearchBarViewForHomepage.h"
#import "IndexViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "erweimaViewController.h"
#import "SaomiaoViewController.h"
#import "AFNetworking.h"
#import "BusinessViewController.h"
#import "DetailViewController.h"
#import "BusinessModel.h"
#import "BusinessTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "NSString+Hashing.h"
#import "SearchViewController.h"
#import "SearchBarView.h"
#import "MBProgressHUD.h"
#import "NSString+Hashing.h"
#import "FirstDViewController.h"
#import "MessageViewController.h"
#import "UIImageView+WebCache.h"
#import "WebViewController.h"
#define LOGIN @"http://ios.lsxfpt.com/Appv2/index/login.html"
#define DINGWEI  @"http://ios.lsxfpt.com/Appv2/index/dingwei.html"
#define SELF @"http://ios.lsxfpt.com/mobile/index/index.html"

#define FIRST @"http://ios.lsxfpt.com/Appv2/index/index.html"
@interface HomepageViewControllerTableViewController ()<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    CLLocationManager *_locationManager;
    CLLocationDegrees dLatitude;
    CLLocationDegrees dLongitude;
    NSMutableArray *ModelArray;
    NSInteger sendertag;
    NSMutableArray *photoArray;
    NSMutableArray *titleArray;
    NSMutableArray *imageArray;
    NSMutableArray *BtnArray;
    NSMutableArray *cat_i;
     NSMutableArray *link_urls;
     NSMutableArray *link_photos;
    UIButton *btn ;
    
    
}
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *btns;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *smalllabel;




@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (retain, nonatomic) IBOutlet UIView *myView;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *smallbutton;
@property (weak, nonatomic) IBOutlet UIImageView *imgv1;
@property (weak, nonatomic) IBOutlet UIImageView *imgv2;
@property (weak, nonatomic) IBOutlet UIImageView *imgv3;
@property (weak, nonatomic) IBOutlet UIImageView *imgv4;
@property (weak, nonatomic) IBOutlet UIImageView *imgv5;
@property (weak, nonatomic) IBOutlet UIImageView *imgv6;
//@property(strong,nonatomic)NSArray *images;
@property(nonatomic,strong)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *city;
@property double longtitude;
@property double latitude;
@property (weak, nonatomic) IBOutlet UILabel *cityname;
@property(nonatomic,strong)CLGeocoder *geocoder;
@property(nonatomic,strong)CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@end




@implementation HomepageViewControllerTableViewController

//-(NSArray*)images{
//    if (!_images) {
//        _images = @[@"a.jpg",@"b.jpg",@"c.jpg",@"d.jpg"];
//    }
//    return _images;
//}
-(CLGeocoder *)geocoder
{
    if (_geocoder==nil) {
        _geocoder=[[CLGeocoder alloc]init];
    }
    return _geocoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 0,370,30)];
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [label addGestureRecognizer:singleTap7];
    label.text = @"请输入商家名";
    label.textColor = [UIColor lightGrayColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    label.layer.cornerRadius = 5.0;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    cat_i = [NSMutableArray array];
    imageArray = [NSMutableArray array];
    BtnArray = [NSMutableArray array];
    photoArray = [NSMutableArray array];
    titleArray = [NSMutableArray array];
    link_urls = [NSMutableArray array];
    link_photos = [NSMutableArray array];

}


-(void)creatUI{
    
    _imgv1.userInteractionEnabled = YES;
    _imgv2.userInteractionEnabled = YES;
    _imgv5.userInteractionEnabled = YES;
    _imgv3.userInteractionEnabled = YES;
    _imgv4.userInteractionEnabled = YES;
    _imgv6.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)];
    [_imgv1 addGestureRecognizer:singleTap1];
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)];
    [_imgv2 addGestureRecognizer:singleTap2];
    UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)];
    [_imgv3 addGestureRecognizer:singleTap3];
    UITapGestureRecognizer *singleTap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)];
    [_imgv4 addGestureRecognizer:singleTap4];
    UITapGestureRecognizer *singleTap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)];
    [_imgv5 addGestureRecognizer:singleTap5];
    UITapGestureRecognizer *singleTap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)];
    [_imgv6 addGestureRecognizer:singleTap6];
    UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 0,300,30)];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    
  
        [btn removeFromSuperview];
   
    
    btn = [[UIButton alloc]initWithFrame:CGRectMake(50, self.view.frame.size.height+ModelArray.count*100-150,self.view.frame.size.width-100, 50)];
    [self.view addSubview:btn];
    [btn setTitle:@"---------加载更多--------" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(loadmore:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font =[UIFont systemFontOfSize:15];
    
    self.pageControl.numberOfPages = link_photos.count;
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    [self startTimer];
    [self initScrollView];
    
    [self.view addSubview:self.pageControl];
    _myTableView.delegate =self;
    _myTableView.dataSource =self;
    [_myTableView registerNib: [UINib nibWithNibName:@"BusinessTableViewCell" bundle:nil]  forCellReuseIdentifier:@"re"];
    self.myTableView.tableHeaderView = self.headerView;
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    if ([CLLocationManager locationServicesEnabled]&&[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [self.locationManager requestAlwaysAuthorization];
    }
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 10;
    [_locationManager startUpdatingLocation];
    _cityname.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"city"];
}

-(void)click:(UITapGestureRecognizer *)gestureRecognizer{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *search = [story instantiateViewControllerWithIdentifier:@"search"];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [self.navigationController pushViewController:search animated:NO];
    
}

//加载更多点击方法
-(void)loadmore:(UIButton *)btn{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"haha"];
    [defaults setObject:@"2" forKey:@"fanhui"];
    
    BusinessViewController *business = [[BusinessViewController alloc]init];
    business.biaoji =@"1";
    [self.navigationController pushViewController:business animated:YES];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"re" forIndexPath:indexPath];
    NSLog(@"%d",ModelArray.count);
    if (ModelArray.count==0) {
        return cell;
    }else{
    
    BusinessModel *model =ModelArray[indexPath.row];
    if ([model.shop_name  isEqual:@""]) {
        return cell;
    }
    else{
        cell.businessName.text = model.shop_name;
        cell.address.text = model.addr;
        int score =model.score;
        if (score==0) {
            [cell.starImage setImage:[UIImage imageNamed:@"0"]];
        }else if (score<=5){
            [cell.starImage setImage:[UIImage imageNamed:@"0.5"]];
        } else if (score<=10) {
            [cell.starImage setImage:[UIImage imageNamed:@"1"]];
        }else if (score<=15) {
            [cell.starImage setImage:[UIImage imageNamed:@"1.5"]];
        }else if (score<=20) {
            [cell.starImage setImage:[UIImage imageNamed:@"2"]];
        }else if (score<=25) {
            [cell.starImage setImage:[UIImage imageNamed:@"2.5"]];
        }else if (score<=30) {
            [cell.starImage setImage:[UIImage imageNamed:@"3"]];
        }else if (score<=35) {
            [cell.starImage setImage:[UIImage imageNamed:@"3.5"]];
        }else if (score<=40) {
            [cell.starImage setImage:[UIImage imageNamed:@"4"]];
        }else if (score<=45) {
            [cell.starImage setImage:[UIImage imageNamed:@"4.5"]];
        }else if (score<=50) {
            [cell.starImage setImage:[UIImage imageNamed:@"5"]];
        }
        cell.distance.text =[NSString stringWithFormat:@"<%@",model.d];
        cell.comments.text = [NSString stringWithFormat:@"%@评价",model.score_num];
        [cell.businessImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ios.lsxfpt.com/attachs/%@",model.photo]]];
        cell.shop_id = model.shop_id;
    }
    return cell;
    }
}
//二维码扫描

- (IBAction)GetQRCode:(id)sender {
    self.hidesBottomBarWhenPushed =YES;
    SaomiaoViewController *saomiao = [[SaomiaoViewController alloc]init];
    [self.navigationController pushViewController:saomiao animated:YES];
    self.hidesBottomBarWhenPushed  =NO;
    
    
}

- (IBAction)Changecity:(UIButton *)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    IndexViewController *index = [story instantiateViewControllerWithIdentifier:@"city"];
    [self.navigationController presentViewController:index animated:YES completion:nil];
}

-(void)autoScroll
{
    int totalPage = link_photos.count;
    int page = self.pageControl.currentPage >=totalPage -1?0:self.pageControl.currentPage+1;
    self.scrollView.contentOffset = CGPointMake(page*self.scrollView.frame.size.width, 0);
    
}

-(void)startTimer
{
    if (self.timer) {
    
    }else {
        NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
        
        self.timer = timer;
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    }   

    
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
        
    _myTableView.contentSize= CGSizeMake(0, self.view.frame.size.height+ModelArray.count*100-100);
   
    CGPoint position = scrollView.contentOffset;
    int index =position.x/self.myView.frame.size.width;
    self.pageControl.currentPage = index;
    
    
}
-(void)initScrollView{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,self.myView.bounds.size.width,self.myView.bounds.size.height)];
    self.scrollView.contentSize = CGSizeMake(self.myView.bounds.size.width*link_photos.count, self.myView.bounds.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    NSLog(@"%lu",(unsigned long)link_photos.count);
    
    for (int i = 0; i<link_photos.count; i++) {
        //UIImage *image = [UIImage imageNamed:link_photos[i]];
        UIImageView *imageView = [[UIImageView alloc] init];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ios.lsxfpt.com/attachs/%@",link_photos[i]]]];
        
        imageView.frame = CGRectMake(self.myView.bounds.size.width * i, 0, self.myView.bounds.size.width, self.myView.bounds.size.height);
        
        imageView.contentMode = UIViewContentModeScaleToFill;
        
        [self.scrollView addSubview:imageView];
        UIButton* enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        enterButton.frame = CGRectMake(self.myView.bounds.size.width * i, 0, self.myView.bounds.size.width, self.myView.bounds.size.height);
        enterButton.tag = i;
        [enterButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:enterButton];
    }
     }


-(void)btnClick:(UIButton*)btn{
    WebViewController *webview = [[WebViewController alloc]init];
    NSString* str = link_urls[btn.tag];
    webview.Web = str;
    [self.navigationController pushViewController:webview animated:YES];         }

//首页商家列表下载
-(void)downloadShop{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *str = @"last";
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            
            [MBProgressHUD Message:@"当前无网络" For:self.view yOffset:-150.0f];
            NSString *catchFilePath = [NSHomeDirectory()stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@",[str MD5Hash]]];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:catchFilePath]) {
                NSData *dataArr = [NSData dataWithContentsOfFile:catchFilePath];
                [self readdFrom:dataArr];
                
            }
            
        }else{
            
            NSString *lat = [[NSUserDefaults standardUserDefaults]objectForKey:@"lat"];
            NSLog(@"%@",lat);
            NSString *lng = [[NSUserDefaults standardUserDefaults]objectForKey:@"lng"];
            NSLog(@"%@",lng);
            if (lat==nil) {
                lat =@"";
            }
            if (lng ==nil) {
                lng =@"";
            }
            NSString *city_d = [[NSUserDefaults standardUserDefaults]objectForKey:@"city_id"];
            NSLog(@"%@",city_d);
            if (city_d == nil) {
                city_d = @"";
            }
            
            [manager GET:FIRST parameters:@{@"city_id":city_d,@"lat":lat,@"lng":lng} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@",[str MD5Hash]]];
                [responseObject writeToFile:cacheFilePath atomically:YES];
                [self readdFrom:responseObject];
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
    }];
    
    
}





-(void)viewWillDisappear:(BOOL)animated{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"haha"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"guanzhu"];
    NSLog(@"%@",uid);
    if (uid ==nil) {
        NSLog(@"退出登录");
    }else{
        NSString *zhang = [[NSUserDefaults standardUserDefaults]objectForKey:@"zhanghao"];
        NSString *mima = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
        NSLog(@"%@",zhang);
        NSLog(@"%@",mima);

        if (zhang==nil || mima ==nil) {
            NSLog(@"未登录");
            
        }else{
            
            NSURL *pURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://ios.lsxfpt.com/Appv2/index/login/account/%@/password/%@",zhang,mima]];
            
            //第二步:创建一个请求
            
            NSURLRequest *pRequest = [NSURLRequest requestWithURL:pURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            
            //第三步:建立连接
            
            NSError *pError = nil;
            
            NSURLResponse *pRespond = nil;
            
            //向服务器发起请求（发起之后,线程就会一直等待服务器响应,直到超出最大响应时间)
            
            NSData *pData = [NSURLConnection sendSynchronousRequest:pRequest returningResponse:&pRespond error:&pError];
            NSLog(@"%@",pData);
            if (pData==nil) {
                NSLog(@"无网络");
            }else{
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:pData options:NSJSONReadingMutableContainers  error:nil];
                NSLog(@"%@",dic);
                NSInteger status = [[dic objectForKey:@"ret"]integerValue];
                if (status !=0) {
                 
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"zhanghao"];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
                    
                 
                }else{
                    
                    NSArray *arr = [dic objectForKey:@"msg"];
                    
                    
                    NSString *str = arr[0];
                    NSString *u_id = [arr[1] objectForKey:@"u_id"];
                    NSString *uid = [arr[1] objectForKey:@"uid"];
                    
                    
                    //判断是否登陆成功
                    if (status ==0) {
                        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                        [userdefault setObject:u_id forKey:@"u_id"];
                        [userdefault setObject:uid forKey:@"uid"];
                    }else{
                                                [self showMessage:str];
                    }
                    
                }
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            }];
//
                
            }
        }
        
    }
    
}

-(void)menuTapped:(UIGestureRecognizer*)gesture{
    
    UIView *viewClick = [gesture view];
    NSString *catid = cat_i[viewClick.tag-1];
    NSUserDefaults *defaults =   [NSUserDefaults standardUserDefaults];
    [defaults setObject:catid forKey:@"cat"];
    [defaults setObject:@"1" forKey:@"haha"];
    [defaults setObject:@"2" forKey:@"fanhui"];
 
    BusinessViewController *business = [[BusinessViewController alloc]init];
     business.biaoji =@"1";
    [self.navigationController pushViewController:business animated:YES];
    
    
}
-(void)readdFrom:(NSData *)data{
    ModelArray = [NSMutableArray array];
    link_photos = [NSMutableArray array];
    link_urls = [NSMutableArray array];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSDictionary *msg = [dic objectForKey:@"msg"];
    NSArray*ad = [msg objectForKey:@"ad"];
    
    for (int i=0; i<ad.count; i++) {
        NSString *link_url = [ad[i] objectForKey:@"link_url"];
        NSString *photo = [ad[i] objectForKey:@"photo"];
        if (link_url ==nil ||photo==nil) {
            NSLog(@"空");
            
        }else{
            
            [link_urls addObject:link_url];
            [link_photos addObject:photo];
            NSLog(@"%@",link_urls);
            NSLog(@"%@",link_photos);
            
        }
    }    //获取button
    
    NSArray * function = [msg objectForKey:@"function"];
      NSArray *extension = [msg objectForKey:@"Extension"];
    
    for (int i=0; i<function.count; i++) {
        NSString *url =[function[i] objectForKey:@"url"];
        NSString *photo = [function[i] objectForKey:@"photo"];
//        NSLog(@"http://ios.lsxfpt.com/attachs:%@",photo);
        
        
        
        NSLog(@"%@",photo);
        NSString *title = [function[i] objectForKey:@"title"];
        NSLog(@"%@",title);
        if (title ==nil ||url ==nil) {
            NSLog(@"没有title或者url");
        }else{
            //按钮的路径与图片
            [photoArray addObject:photo];
            [titleArray addObject:title];
            NSLog(@"*****%@",photoArray);
            NSLog(@"---------------------%@",titleArray);
            NSLog(@"%@",photo);
            NSArray*urlid = [url componentsSeparatedByString:@"/mobile/shop/index/cat/"];
            NSLog(@"%@",urlid);
            if (urlid.count <=1) {
                NSString *cat_id =@"";
                [cat_i addObject:cat_id];
            }else{
                NSString *cat_id =urlid[1];
                NSLog(@"%@",cat_id);
                [cat_i addObject:cat_id];
                NSLog(@"cat_i%@",cat_i);
                
            }
        }
        
        
    }
    for (int i = 0; i<_btns.count; i++) {
        UIImageView *image1 =_btns[i];
        image1.userInteractionEnabled = YES;
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapped:)];
        [image1 addGestureRecognizer:tapGesture];
//        image1.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ios.lsxfpt.com/attachs/%@",photoArray[i]]]]];
       [image1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ios.lsxfpt.com/attachs/%@",photoArray[i]]]];

                UILabel *lb = _smalllabel[i];
                NSLog(@"-------------------------------%@",titleArray);
                lb.text = titleArray[i];
    }
    
    
    //4个view
  
    for (int i=0; i<extension.count; i++) {
       
        NSString *image_url = [extension[i] objectForKey:@"img_url"];
        NSString *btn_url = [extension[i] objectForKey:@"btn_url"];
        NSLog(@"-----%@,--------%@",image_url,btn_url);
        if (image_url==nil || btn_url ==nil) {
            
            image_url=@"";
            btn_url =@"";
            [imageArray addObject:image_url];
            [BtnArray addObject:btn_url];
            
        }else{
            [imageArray addObject:image_url];
            [BtnArray addObject:btn_url];
        }
        
    }
    //首页 imageview 的获取
     [_imgv1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ios.lsxfpt.com%@",imageArray[0]]]];
//    _imgv1.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ios.lsxfpt.com%@",imageArray[0]]]]];
    _imgv2.userInteractionEnabled = YES;
    _imgv3.userInteractionEnabled = YES;
    _imgv4.userInteractionEnabled = YES;
    [_imgv2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ios.lsxfpt.com%@",imageArray[1]]]];
    [_imgv3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ios.lsxfpt.com%@",imageArray[2]]]];
    [_imgv4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ios.lsxfpt.com%@",imageArray[3]]]];
    
//    _imgv2.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ios.lsxfpt.com%@",imageArray[1]]]]];
//    _imgv3.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ios.lsxfpt.com%@",imageArray[2]]]]];
//    _imgv4.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ios.lsxfpt.com%@",imageArray[3]]]]];
    
    
    
    for (int i=0; i<function.count; i++) {
        NSString *url =[function[i] objectForKey:@"url"];
        NSString *photo = [function[i] objectForKey:@"photo"];
        NSString *title = [function[i] objectForKey:@"title"];
        //按钮的路径与图片
        [photoArray addObject:photo];
        [titleArray addObject:title];
        NSArray*urlid = [url componentsSeparatedByString:@"/mobile/shop/index/cat/"];
        if (urlid.count<=1) {
            NSString *cat_id =@"";
            [cat_i addObject:cat_id];
            
        }else{
            
            NSString *cat_id =urlid[1];
            [cat_i addObject:cat_id];
        }
    }
    NSArray *array = [msg objectForKey:@"shop"];
    
    NSLog(@"%@",array);
    if ([array isEqual:[NSNull null]]) {
        
        ModelArray = [NSMutableArray array];
        
    }else{
    for (int i=0; i<array.count; i++) {
        
        BusinessModel *model = [[BusinessModel alloc]init];
        model.shop_id = [array[i] objectForKey:@"shop_id"];
        model.shop_name = [array[i] objectForKey:@"shop_name"];
        NSLog(@"%@",model.shop_name);
        model.addr = [array[i] objectForKey:@"addr"];
        model.d = [array[i] objectForKey:@"d"];
        model.photo = [array[i] objectForKey:@"photo"];
        model.score= [[array[i] objectForKey:@"score"]integerValue];
        model.score_num= [array[i] objectForKey:@"score_num"];
        [ModelArray addObject:model];
    
    }
    }
    [_myTableView reloadData];
    [self creatUI];
    
}
#pragma  - UiiamggeViewClick-


//6个webview的点击时间
-(void)clickCategory:(UITapGestureRecognizer *)gestureRecognizer{
    FirstDViewController *first = [[FirstDViewController alloc]init];
    
    UIView *viewClicked=[gestureRecognizer view];
    
    
    if (viewClicked ==_imgv1) {
        first.detailUrl =BtnArray[0];
        [self.navigationController pushViewController:first animated:YES];
    } else if (viewClicked ==_imgv2){
        
        first.detailUrl =BtnArray[1];
        [self.navigationController pushViewController:first animated:YES];
    }else if (viewClicked ==_imgv3){
        first.detailUrl =BtnArray[2];
        [self.navigationController pushViewController:first animated:YES];
    }else if (viewClicked ==_imgv4){
        first.detailUrl =BtnArray[3];
        [self.navigationController pushViewController:first animated:YES];
    }else if (viewClicked ==_imgv5){
        first.detailUrl =BtnArray[4];
        [self.navigationController pushViewController:first animated:YES];
    }else if (viewClicked ==_imgv6){
        first.detailUrl =BtnArray[5];
        [self.navigationController pushViewController:first animated:YES];
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DetailViewController *detail = [[DetailViewController alloc]init];
    BusinessModel *model =ModelArray[indexPath.row];
    NSString * str = [NSString stringWithFormat:@"http://ios.lsxfpt.com/appwebview/shop/detail/shop_id/%@",model.shop_id];
    detail.detailUrl =str;
    detail.shop_id = model.shop_id;
    [self.navigationController pushViewController:detail animated:YES];
}
//页面将要出现 显示 记录点击的城市
-(void)viewWillAppear:(BOOL)animated{
     [self downloadShop];
    BusinessViewController *business = [[BusinessViewController alloc]init];
    business.biaoji =@"";
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"city"];
    NSLog(@"%@",str);
    self.cityname.text =str;
    self.tabBarController.tabBar.hidden =NO;
    
}
-(void)push{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *search = [story instantiateViewControllerWithIdentifier:@"search"];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [self.navigationController pushViewController:search animated:NO];
    
    
}

- (IBAction)messageShow:(UIButton *)sender {
    
    MessageViewController *message = [[MessageViewController alloc]init];
    [self.navigationController pushViewController:message animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return ModelArray.count;
    
    
}


-(void)showMessage:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
    
    
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 1;
//}
//


/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
