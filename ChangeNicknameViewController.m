//
//  ChangeNicknameViewController.m
//  frameTest
//
//  Created by 许争妍 on 16/7/10.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ChangeNicknameViewController.h"
#import "AFNetworking.h"
#define NAME @"http://ios.lsxfpt.com/app/Linkmobile/nickname.html"
@interface ChangeNicknameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *Nickname;

@end

@implementation ChangeNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
    
    
    
    
    
}
- (IBAction)ChangeNickname:(UIButton *)sender {
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *name = self.Nickname.text;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:NAME parameters:@{@"nickname":name ,@"uid":uid} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        NSString *msg = [dic objectForKey:@"msg"];
        NSInteger stutus = [[dic objectForKey:@"status"]integerValue];
//        NSLog(@"%d",msg);
        
        if (stutus ==200) {
            
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             NSString *nicknames = self.Nickname.text;
            [defaults setObject:nicknames forKey:@"nickname"];
           
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
