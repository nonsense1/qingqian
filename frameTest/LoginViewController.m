//
//  LoginViewController.m
//  frameTest
//
//  Created by mac on 16/6/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "GetVerifyCodeViewController.h"
#import "TaBarViewController.h"
#import "ForgetPasswordViewController.h"
#define LOGIN @"http://ios.lsxfpt.com/Appv2/index/login.html"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *zhang;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (retain, nonatomic) IBOutlet UIView *teleLoginView;
@property (retain, nonatomic) IBOutlet UIButton *getVerifyCode;
@property (retain, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIImageView *darkgray;

@property (weak, nonatomic) IBOutlet UIImageView *drakgaryy;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.getVerifyCode.layer.cornerRadius = 5.0;
    self.login.layer.cornerRadius = 5.0;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    NSString *zhang = [[NSUserDefaults standardUserDefaults]objectForKey:@"zhanghao"];
    NSString *mima = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
     self.zhang.text=zhang;
  self.password.text=mima;
}
//返回按钮
- (IBAction)btnClick:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TaBarViewController *tabBarController = [story instantiateViewControllerWithIdentifier:@"tabbar"];
    UIWindow *wind=   [UIApplication sharedApplication].keyWindow;
    wind.rootViewController = tabBarController;
}
//注册
- (IBAction)Regis:(UIButton *)sender {
   
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
    GetVerifyCodeViewController *get = [story instantiateViewControllerWithIdentifier:@"get"];
    
        [self presentViewController:get animated:YES completion:nil];
}

//    [self.navigationController pushViewController:get animated:YES];
    

   
- (IBAction)login:(id)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    //
    //    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    NSString *zhang = self.zhang.text;
    NSString*password = self.password.text;
    NSLog(@"%@,%@",zhang,password);
    
    [manager POST:LOGIN parameters:@{@"account":zhang,@"password":password} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers  error:nil];
        NSLog(@"%@",dic);
        NSInteger status = [[dic objectForKey:@"ret"]integerValue];
        NSString *str =[dic objectForKey:@"msg"];
        
        NSLog(@"************%@",str);
        
        
        if (status !=0) {
            NSString *str = [dic objectForKey:@"msg"];
            [self showMessage:str];
            
        }else{
            NSArray *arr = [dic objectForKey:@"msg"];
            
            NSString *str = arr[0];
            NSString *u_id = [arr[1] objectForKey:@"u_id"];
            NSString *uid = [arr[1] objectForKey:@"uid"];
            NSLog(@"%@",u_id);
            NSLog(@"%@",uid);
 
            NSLog(@"str:%@",str);
            
            
            //判断是否登陆成功
            if (status ==0) {
                NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                [userdefault setObject:password forKey:@"password"];
                [userdefault setObject:zhang forKey:@"zhanghao"];
                [userdefault setObject:u_id forKey:@"u_id"];
                [userdefault setObject:uid forKey:@"uid"];
                
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                TaBarViewController *tabBarController = [story instantiateViewControllerWithIdentifier:@"tabbar"];
                
                //                TaBarViewController *tabBarController =[[TaBarViewController alloc]init];
                UIWindow *wind=   [UIApplication sharedApplication].keyWindow;
                wind.rootViewController = tabBarController;
            }else{
                [self showMessage:str];
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        
        
    }];
    
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.zhang resignFirstResponder];
     [self.password resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//忘记密码
- (IBAction)forgetPassword:(UIButton *)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ForgetPasswordViewController *forgot = [story instantiateViewControllerWithIdentifier:@"forgot"];
    [self presentViewController:forgot animated:YES completion:nil];
    
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
