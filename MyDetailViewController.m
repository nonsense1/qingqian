//
//  MyDetailViewController.m
//  frameTest
//
//  Created by 蔡晓宇 on 16/7/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MyDetailViewController.h"

@interface MyDetailViewController ()

@end

@implementation MyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+104)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_Detailurl]];
    NSLog(@"%@",_Detailurl);
    [self.view addSubview:web];
    [web loadRequest:request];
    
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
