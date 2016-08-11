//
//  SumbitVerifyCodeViewController.m
//  frameTest
//
//  Created by mac on 16/6/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SumbitVerifyCodeViewController.h"
#import "AFNetworking.h"
#import "LoginViewController.h"
#define YANZHENG @"http://ios.lsxfpt.com/Appv2/index/checksms.html"
@interface SumbitVerifyCodeViewController ()


@property (weak, nonatomic) IBOutlet UITextField *yanzhengtext;

@property (weak, nonatomic) IBOutlet UITextField *yanzheng;

@property (weak, nonatomic) IBOutlet UIView *Navview;

@end

@implementation SumbitVerifyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  

    

    
}
//返回按钮
- (IBAction)returnBlick:(UIButton *)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *login = [story instantiateViewControllerWithIdentifier:@"login"];
    //                [self.navigationController pushViewController:login animated:NO];
    
    UIWindow *wind = [UIApplication sharedApplication].keyWindow;
    wind.rootViewController =login;
}
- (IBAction)yanzhengBlick:(id)sender {
    NSString *yanzhengs = self.yanzhengtext.text;
    NSLog(@"%@",yanzhengs);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager GET:YANZHENG parameters:@{@"scode":yanzhengs} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic);
        
        NSString *str = [dic objectForKey:@"msg"];
        NSInteger ret = [[dic objectForKey:@"ret"]integerValue];
//        NSLog(@"str:%@",str);
        
        if (ret==0) {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SumbitVerifyCodeViewController *sumbi = [story instantiateViewControllerWithIdentifier:@"third"];
            [self presentViewController:sumbi animated:NO completion:nil];
            
        }else{
        
        
        
        [self showMessage:str];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    

}

-(void)showMessage:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
    
    
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
