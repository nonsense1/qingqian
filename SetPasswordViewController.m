//
//  SetPasswordViewController.m
//  frameTest
//
//  Created by mac on 16/6/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "AFNetworking.h"
#define LAST @"http://ios.lsxfpt.com/Appv2/index/register.html"
#import "LoginViewController.h"
#import "TaBarViewController.h"
@interface SetPasswordViewController (){
    NSString *textfile1;
}

@property (weak, nonatomic) IBOutlet UITextField *password1;
@property (weak, nonatomic) IBOutlet UITextField *password2;
@property (weak, nonatomic) IBOutlet UIView *Navview;

@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self..layer.cornerRadius = 5.0;
    
    // Do any additional setup after loading the view.
}

//返回按钮
- (IBAction)returnBlick:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *login = [story instantiateViewControllerWithIdentifier:@"login"];
    //                [self.navigationController pushViewController:login animated:NO];
    
    UIWindow *wind = [UIApplication sharedApplication].keyWindow;
    wind.rootViewController =login;
}
- (IBAction)regisClick:(id)sender {
    textfile1 = self.password1.text;
    NSString *textfile2 = self.password2.text;
    NSString *phonenumber = [[NSUserDefaults standardUserDefaults]objectForKey:@"zhanghao1"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        [manager POST:LAST parameters:@{@"account":phonenumber,@"password":textfile1,@"password2":textfile2} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"%@",dic);
            
            NSString *str = [dic objectForKey:@"msg"];
            NSInteger ret = [[dic objectForKey:@"ret"]integerValue];
//            NSLog(@"str:%@",str);
            if (ret ==0) {
                NSLog(@"1");
                
                
                NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                NSString *zhanghao1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"zhanghao1"];
                [userdefault setObject:zhanghao1 forKey:@"zhanghao"];
                [userdefault setObject:textfile1 forKey:@"password"];
                NSLog(@"%@",textfile1);
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LoginViewController *login = [story instantiateViewControllerWithIdentifier:@"login"];
                //                [self.navigationController pushViewController:login animated:NO];
                
                UIWindow *wind = [UIApplication sharedApplication].keyWindow;
                wind.rootViewController =login;
                
            }else{
                [self showMessage:str];
            }
            
            
                   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"oooo");
            
            
        }];
        
        
    }];
    
    
    
    
    
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
