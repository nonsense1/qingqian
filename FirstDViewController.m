//
//  FirstDViewController.m
//  frameTest
//
//  Created by 蔡晓宇 on 16/7/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "FirstDViewController.h"
#import "MBProgressHUD.h"
@interface FirstDViewController ()<UIWebViewDelegate>
@property(nonatomic,copy)MBProgressHUD *HUD;
@end

@implementation FirstDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    

    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+64)];
    web.scrollView.bounces =NO;

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ios.lsxfpt.com%@",_detailUrl]]];

    web.delegate =self;
    [self.view addSubview:web];
    [web loadRequest:request];


}
-(void)viewWillAppear:(BOOL)animated{
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
