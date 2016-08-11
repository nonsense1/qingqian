//
//  TaBarViewController.m
//  frameTest
//
//  Created by 赵立权 on 16/7/10.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "TaBarViewController.h"
#import "AFNetworking.h"
#import "LoginViewController.h"
#import "MyFavoriteViewController.h"

#define ZENGSONG @"http://ios.lsxfpt.com/linkmemberappwebview/user/index/is_login"
@interface TaBarViewController ()<UITabBarControllerDelegate>

@end

@implementation TaBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    NSLog(@"%@",tabBarController.tabBar.)
 
     self.tabBarController.selectedIndex =0;
    

    if (tabBarController.tabBar.selectedItem.tag ==3 ||tabBarController.tabBar.selectedItem.tag ==4) {
        
        NSURL *pURL = [NSURL URLWithString:ZENGSONG];
        
        //第二步:创建一个请求
        
        NSURLRequest *pRequest = [NSURLRequest requestWithURL:pURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        
        //第三步:建立连接
        
        NSError *pError = nil;
        
        NSURLResponse *pRespond = nil;
        
        //向服务器发起请求（发起之后,线程就会一直等待服务器响应,直到超出最大响应时间)
        
        NSData *pData = [NSURLConnection sendSynchronousRequest:pRequest returningResponse:&pRespond error:&pError];
        if (pData ==nil) {
            NSLog(@"无网络");
        }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:pData options:NSJSONReadingMutableContainers  error:nil];
        NSLog(@"%@",dic);
        NSInteger status = [[dic objectForKey:@"status"]integerValue];
        
        if (status==1) {
            
            UIWindow *wind=   [UIApplication sharedApplication].keyWindow;
            wind.rootViewController = tabBarController;
            
            
            
        }else{
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *login = [story instantiateViewControllerWithIdentifier:@"login"];
            
            
            UIWindow *wind = [UIApplication sharedApplication].keyWindow;
            wind.rootViewController =login;
        }

        }
    }
    
        
}









// 实现接收到消息后的处理方法

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
