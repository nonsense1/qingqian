//
//  ChangePasswordViewController.m
//  frameTest
//
//  Created by 许争妍 on 16/7/10.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "AFNetworking.h"
#define Revise @"http://ios.lsxfpt.com/app/Linkmobile/password.html"
#import "MBProgressHUD.h"
@interface ChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *theNewCode;
@property (weak, nonatomic) IBOutlet UITextField *theNewCodeConfirm;

@property (weak, nonatomic) IBOutlet UITextField *oldpassword;



@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changePassword:(id)sender {
    
 
        
        NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
        NSString *Newpassword = self.theNewCode.text;
    NSString *NewpasswordAgain = self.theNewCodeConfirm.text;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *oldPassword = self.oldpassword.text;
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:Revise parameters:@{@"uid":uid,@"oldpwd":oldPassword,@"newpwd":Newpassword,@"pwd2":NewpasswordAgain} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            
            NSString * msg = [dic objectForKey:@"msg"];
            NSInteger status = [[dic objectForKey:@"status"]integerValue];
            NSLog(@"%@",msg);
            if (status ==200) {
                [MBProgressHUD Message:@"更改密码成功" For:self.view yOffset:-150.0f];
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

    
    


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
