//
//  MessageViewController.m
//  frameTest
//
//  Created by 蔡晓宇 on 16/7/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MessageViewController.h"
#define MESS @"http://ios.lsxfpt.com/linkmemberappwebview/user/center/messageList"
@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden =YES;
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+64)];
    web.scrollView.bounces =NO;

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:MESS]];
    
    [self.view addSubview:web];
    [web loadRequest:request];
    // Do any additional setup after loading the view.
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
