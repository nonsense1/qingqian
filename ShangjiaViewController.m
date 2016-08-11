//
//  ShangjiaViewController.m
//  frameTest
//
//  Created by 蔡晓宇 on 16/7/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ShangjiaViewController.h"
#import "MBProgressHUD.h"
#import "UIImage+animatedGIF.h"
@interface ShangjiaViewController ()<MBProgressHUDDelegate,UIWebViewDelegate>

@property(nonatomic,copy)MBProgressHUD *HUD;

@end

@implementation ShangjiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    web.delegate = self;
    web.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1.00];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_Web]];
    NSLog(@"%@",_Web);
    
    [self.view addSubview:web];
    [web loadRequest:request];
    
    

}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.backBarButtonItem.title=@"返回";
    
    self.tabBarController.tabBar.hidden =YES;
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
