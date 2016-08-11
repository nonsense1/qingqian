//
//  LogOutTableViewController.m
//  frameTest
//
//  Created by 许争妍 on 16/7/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LogOutTableViewController.h"
#import "AFNetworking.h"
#import "MyFavoriteViewController.h"
#import "LoginViewController.h"
#import "ReviseViewController.h"
#import "ChangeNicknameViewController.h"
#import "ChangePasswordViewController.h"
#import "TaBarViewController.h"
#import "WebViewController.h"
#import "VerifyPhoneNumViewController.h"
//#import "VerifyPhoneNumAgainViewController.h"
@interface LogOutTableViewController ()
#define FIRST @"http://ios.lsxfpt.com/Appv2/Index/check_mobile.html"
#define EXIT @"http://ios.lsxfpt.com/Appv2/index/logout"
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;

@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *showlable;


@end

@implementation LogOutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logoutBtn.layer.cornerRadius = 5.0;
    self.myTableView.tableHeaderView = self.headerView;
    _myTableView.delegate = self;
    _myTableView.dataSource =self;
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSString *nickname = [[NSUserDefaults standardUserDefaults]objectForKey:@"nickname"];
    self.nickname.text =nickname;
    
    NSString *phonenumber = [[NSUserDefaults standardUserDefaults]objectForKey:@"mobile"];
    NSLog(@"%@",phonenumber);
    if (phonenumber ==nil) {
         self.phoneNum.text =@"请绑定手机号";
        self.showlable.text = @"绑定";
    }else{
        NSString *phoneFirst = [phonenumber substringToIndex:3];
//        NSLog(@"%@",phoneFirst);
        
        NSString *phoneLast = [phonenumber substringFromIndex:7];
//        NSLog(@"%@",phoneLast);
        NSString *phonenumber = [NSString stringWithFormat:@"%@****%@",phoneFirst,phoneLast];
        self.showlable.text = @"更改";
        self.phoneNum.text = phonenumber;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logout:(id)sender {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:EXIT parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers  error:nil];
        NSLog(@"%@",dic);
        NSInteger ret = [[dic objectForKey:@"ret"]integerValue];
        
        if (ret==0) {
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"uid"];
          
            
            
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TaBarViewController *tabBarController = [story instantiateViewControllerWithIdentifier:@"tabbar"];
            
          
            UIWindow *wind=   [UIApplication sharedApplication].keyWindow;
            wind.rootViewController = tabBarController;
            
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

    
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReviseViewController *regisview = [[ReviseViewController alloc]init];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChangeNicknameViewController *changenick = [story instantiateViewControllerWithIdentifier:@"nick"];
    ChangePasswordViewController *changepasss = [story instantiateViewControllerWithIdentifier:@"pass"];
    VerifyPhoneNumViewController *verify= [story instantiateViewControllerWithIdentifier:@"tag"];
    
    

    switch (indexPath.section) {
            
        case 0:
            
            
            
            [self.navigationController pushViewController:changenick animated:YES];
            break;
            
        case 1:
            if (indexPath.row==0) {
                 [self.navigationController pushViewController:verify animated:YES];
            }else if (indexPath.row==1){
                WebViewController *webview = [[WebViewController alloc]init];
                NSString *str =@"http://ios.lsxfpt.com/linkmemberappwebview/user/profile/setBankInfo";
                webview.Web = str;
                
                [self.navigationController pushViewController:webview animated:YES];
                

                
            }else if (indexPath.row ==2){
                
                WebViewController *webview = [[WebViewController alloc]init];
                NSString *str =@"http://ios.lsxfpt.com/linkmemberappwebview/User/Profile/RealName";
                webview.Web = str;
                
                [self.navigationController pushViewController:webview animated:YES];
                

                
            }
           
            break;
            
            
            
        case 2:
            
            
             [self.navigationController pushViewController:changepasss animated:YES];
            
            
            break;
            
            
            
        default:
            break;
    }
    
    
    
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
