//
//  VerifyPhoneNumViewController.m
//  frameTest
//
//  Created by 许争妍 on 16/7/12.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "VerifyPhoneNumViewController.h"
#import "AFNetworking.h"
#define REGIS @"http://ios.lsxfpt.com/appv2/index/sendsms_new.html"
@interface VerifyPhoneNumViewController (){
      int time;
}
@property(nonatomic,retain) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIImageView *lb1;
@property (weak, nonatomic) IBOutlet UITextField *yanzheng;
@property (weak, nonatomic) IBOutlet UIImageView *lb22;
@property (weak, nonatomic) IBOutlet UIButton *huoquYZ;

@end

@implementation VerifyPhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}



- (IBAction)huoquyanzheng:(id)sender {
    NSString *phone =_phoneNum.text;
    
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:REGIS parameters:@{@"mobile":phone} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        NSString * status = [dic objectForKey:@"status"];
        NSString *msg = [dic objectForKey:@"msg"];
        if ([status isEqualToString:@"success"]) {
            NSLog(@"成功");
            time =60;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeMethod) userInfo:nil repeats:YES];

            
        }else{
            
            [self showMessage:msg];
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        
        
    }];

    
    
}



-(void)timeMethod{
    
    time--;
   _huoquYZ.userInteractionEnabled =NO;
    [_huoquYZ setTitle:[NSString stringWithFormat:@"%d后获取",time] forState:UIControlStateNormal];
//    _huoquYZ.titleLabel.text =[NSString stringWithFormat:@"%d后获取",time];
    if (time==0) {
        [self.timer invalidate];
        [_huoquYZ setTitle:@"获取验证码" forState:UIControlStateNormal];
        _huoquYZ.userInteractionEnabled =YES;
        
    }
    
}




- (IBAction)submit:(id)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *myPhoneNum = self.phoneNum.text;
    NSString *myPassword = self.password.text;
    NSString *yanzhengNum = self.yanzheng.text;
    NSLog(@"%@,%@,%@",myPhoneNum,myPassword,yanzhengNum);
  
    [manager POST:@"http://ios.lsxfpt.com/appv2/index/mobile_new.html"  parameters:@{@"mobile":myPhoneNum,@"password":myPassword,@"scode":yanzhengNum} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers  error:nil];
        NSLog(@"%@",dic);
        NSString *msg = [dic objectForKey:@"msg"];
        NSString* status = [dic objectForKey:@"status"];
        if ([status isEqualToString:@"success"]) {
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault setObject:myPhoneNum forKey:@"mobile"];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            [self showMessage:msg];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
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
