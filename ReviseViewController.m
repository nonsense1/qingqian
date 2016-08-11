//
//  ReviseViewController.m
//  frameTest
//
//  Created by 蔡晓宇 on 16/7/9.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ReviseViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#define Revise @"http://ios.lsxfpt.com/app/Linkmobile/password.html"
@interface ReviseViewController ()

@end

@implementation ReviseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITextField *file = [[UITextField alloc]initWithFrame:CGRectMake(150,100, self.view.frame.size.width-200, 30)];
    [self.view addSubview:file];
    file.tag = 10;
    file.layer.borderWidth = 0.5;
    UILabel *lb  =[[UILabel alloc]initWithFrame:CGRectMake(10, 100, 50, 50)];
    [self.view addSubview:lb];
    lb.font = [UIFont systemFontOfSize:15];
    lb.text = @"原密码";
    
    
    UITextField *file1 = [[UITextField alloc]initWithFrame:CGRectMake(150,200, self.view.frame.size.width-200, 30)];
    [self.view addSubview:file1];
    file1.layer.borderWidth = 0.5;
    UILabel *lb1  =[[UILabel alloc]initWithFrame:CGRectMake(10, 200, 50, 50)];
    [self.view addSubview:lb1];
    lb1.font = [UIFont systemFontOfSize:15];
    lb1.text = @"新密码";
    file1.tag =20;
    
    UITextField *file2 = [[UITextField alloc]initWithFrame:CGRectMake(150,300, self.view.frame.size.width-200, 30)];
    [self.view addSubview:file2];
    file1.layer.borderWidth = 0.5;
    UILabel *lb2  =[[UILabel alloc]initWithFrame:CGRectMake(10, 300, 50, 50)];
    [self.view addSubview:lb2];
    lb2.font = [UIFont systemFontOfSize:15];
    lb2.text = @"新密码";
    file2.tag =30;
    file2.layer.borderWidth = 0.5;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(200, 500, 200, 50)];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor yellowColor];
    
    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}



-(void)BtnClick:(UIButton *)btn{
    
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    UITextField *ff= [self.view viewWithTag:10];
    NSString  *fftex = ff.text;
    
    UITextField *ff1 = [self.view viewWithTag:20];
    NSString  *ff1tex = ff1.text;
    UITextField *ff2 = [self.view viewWithTag:30];
    NSString  *ff2tex = ff2.text;
    
   AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:Revise parameters:@{@"uid":uid,@"oldpwd":fftex,@"newpwd":ff1tex,@"pwd2":ff2tex} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        
        NSString * msg = [dic objectForKey:@"msg"];
        NSInteger status = [[dic objectForKey:@"status"]integerValue];
         NSLog(@"%@",msg);
        if (status ==200) {
             [MBProgressHUD Message:@"密码修改成功" For:self.view yOffset:-150.0f];
            [self.navigationController popViewControllerAnimated:YES];
            
           
        }else{
            
            [self showMessage:msg];
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
