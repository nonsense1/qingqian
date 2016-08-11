//
//  ForgetPasswordViewController.m
//  frameTest
//
//  Created by 蔡晓宇 on 27/7/11.
//  Copyright © 2027年 mac. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#define DETAIL @"http://ios.lsxfpt.com/Appwebview/passport/forget/way/2"
@interface ForgetPasswordViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *web;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor whiteColor];
      self.tabBarController.tabBar.hidden =YES;
    self.web.scrollView.bounces =NO;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:DETAIL]];
    self.web.delegate = self;
    [self.view addSubview:self.web];
    [self.web loadRequest:request];
    
    UIView *view= [[UIView alloc]initWithFrame:CGRectMake(0, self.web.frame.size.height-50, self.view.frame.size.width, 50)];
    [self.web addSubview:view];
//    view.backgroundColor = [UIColor colorWithRed:0.18 green:0.74 blue:0.67 alpha:1.00];
    
}

-(void)back:(UIButton*)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 30, 50, 30)];
    [self.view addSubview:btn];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
//    [btn setBackgroundColor:[UIColor colorWithRed:0.18 green:0.74 blue:0.67 alpha:1.00]];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];}

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
