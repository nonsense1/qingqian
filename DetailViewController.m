//
//  DetailViewController.m
//  frameTest
//
//  Created by 蔡晓宇 on 16/7/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DetailViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIImage+animatedGIF.h"
#define ZENGSONG @"http://ios.lsxfpt.com/linkmemberappwebview/user/index/is_login"
#define SHOUCANG @"http://ios.lsxfpt.com/appv2/index/checkfavorites"
@interface DetailViewController ()<MBProgressHUDDelegate,UIWebViewDelegate>{
    UIButton* myFavorite;
    NSInteger status;
}

//@property (nonatomic,retain)NSString *shop_id;
@property(nonatomic,copy)MBProgressHUD *HUD;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+64)];
    web.delegate =self;
    web.backgroundColor = [UIColor whiteColor];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_detailUrl]];
     myFavorite = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [myFavorite addTarget:self action:@selector(addFavorite) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:myFavorite];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    [self.view addSubview:web];
    [web loadRequest:request];
}
- (void)layoutViewsAnimation {
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.mode = MBProgressHUDModeCustomView;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"defamation" withExtension:@"gif"];
    UIImage *gifImage = [UIImage animatedImageWithAnimatedGIFURL:url];
    UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 44, 100, 100)];
    gifImageView.image = gifImage;
    gifImageView.layer.cornerRadius = 50;
    gifImageView.layer.masksToBounds = YES;
    _HUD.customView = gifImageView;
    _HUD.delegate = self;
    _HUD.labelText = @"加载中";
    //    [self downRefresh];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
       _HUD.removeFromSuperViewOnHide = YES;
    [_HUD hide:YES ];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
       [self layoutViewsAnimation];
    self.tabBarController.tabBar.hidden =YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    

    [manager GET:ZENGSONG parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic);
        status = [[dic objectForKey:@"status"]integerValue];

//        NSLog(@"%d",status);
        if (status==1) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            NSString *uid =[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
//            NSLog(@"%@",uid);
//            NSLog(@"%@",self.shop_id);
            [manager GET:SHOUCANG parameters:@{@"shop_id":self.shop_id,@"uid":uid} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
                NSInteger statuss = [[dic objectForKey:@"ret"]integerValue];
                //NSLog(@"%d",statuss);
//                NSString *users = [dic objectForKey:@"users"];
                if (statuss ==203) {
                    //关注
                    
                    [myFavorite setBackgroundImage:[UIImage imageNamed:@"心2.png"] forState:UIControlStateNormal];
                }else{
                    //未关注
                    [myFavorite setBackgroundImage:[UIImage imageNamed:@"心.png"] forState:UIControlStateNormal];
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error");
            }];
            
            NSLog(@"%@",self.shop_id);
            
            
        }else{
            //进入页面未登录
            [myFavorite setBackgroundImage:[UIImage imageNamed:@"心.png"] forState:UIControlStateNormal];
            
            
            
        }
        
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
-(void)addFavorite{

    if (status==1) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSString *uid =[[NSUserDefaults standardUserDefaults] objectForKey:@"u_id"];


        [manager GET:@"http://ios.lsxfpt.com/mobile/shop/setFavoritestype" parameters:@{@"shop_id":self.shop_id,@"uid":uid} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *str =[[NSString alloc]initWithData:responseObject encoding:NSJSONReadingMutableContainers];
            NSLog(@"%@",str);
            if ([str isEqualToString:@"1"]) {
                //关注成功
               
                 [myFavorite setBackgroundImage:[UIImage imageNamed:@"心2.png"] forState:UIControlStateNormal];
            }else{
                //取消关注成功
                 [myFavorite setBackgroundImage:[UIImage imageNamed:@"心.png"] forState:UIControlStateNormal];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error");
        }];
        
        
        
        
        
        
    }else{
        //关注失败 登录
          [MBProgressHUD Message:@"未登录，请先登录！" For:self.view yOffset:-150.0f];
        
    }
    
   
    
    
    
    
    
    
  
}
-(void)showMessage:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
    
    
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
