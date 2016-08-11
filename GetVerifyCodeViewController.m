//
//  GetVerifyCodeViewController.m
//  frameTest
//
//  Created by mac on 16/6/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GetVerifyCodeViewController.h"
#import "AFNetworking.h"
#import "SumbitVerifyCodeViewController.h"
#import "LoginViewController.h"
#define REGIS @"http://ios.lsxfpt.com/Appv2/index/sendsms.html"
@interface GetVerifyCodeViewController ()
@property (retain, nonatomic) IBOutlet UIButton *getVerifyCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phonenumber;
@property (weak, nonatomic) IBOutlet UIView *Navview;

@end

@implementation GetVerifyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.getVerifyCodeBtn.layer.cornerRadius = 5.0;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getVerifyCode:(id)sender {
    NSString *phonenumber = self.phonenumber.text;
 AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:REGIS parameters:@{@"account":phonenumber} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic);
        
        NSString *str = [dic objectForKey:@"msg"];
        NSInteger ret = [[dic objectForKey:@"ret"]integerValue];
//        NSLog(@"str:%@",str);
        if (ret ==0) {
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            
            [userdefault setObject:phonenumber forKey:@"zhanghao1"];

            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SumbitVerifyCodeViewController *sumbi = [story instantiateViewControllerWithIdentifier:@"second"];
            [self presentViewController:sumbi animated:NO completion:nil];
        }else{
             [self showMessage:str];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

    
}
//返回按钮
- (IBAction)returnBlick:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *login = [story instantiateViewControllerWithIdentifier:@"login"];
    //                [self.navigationController pushViewController:login animated:NO];
    
    UIWindow *wind = [UIApplication sharedApplication].keyWindow;
    wind.rootViewController =login;

}

-(void)showMessage:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
    
    
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
