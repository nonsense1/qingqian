//
//  MineTableViewController.m
//  frameTest
//
//  Created by 许争妍 on 16/7/5.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MineTableViewController.h"
#import "AFNetworking.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "MyDetailViewController.h"
#import "WebViewController.h"
#import "HaloClean.h"
#define YUE @"http://ios.lsxfpt.com/linkmemberappwebview/user/index/is_login"
#define BANBEN @"http://ios.lsxfpt.com/app/Update/getIOSVersion"
#define USERid [[NSUserDefaults standardUserDefaults]objectForKey:@"u_id"]
#import "CooperateViewController.h"
@interface MineTableViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    NSString* imageUploadPath;
    NSString *downloadurl;
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *consumption;

@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *cumulativeIntegral;

@property (weak, nonatomic) IBOutlet UILabel *currentIntegral;
@property (weak, nonatomic) IBOutlet UILabel *mynane;
@property (weak, nonatomic) IBOutlet UILabel *bianhao;
@property (weak, nonatomic) IBOutlet UIImageView *touxiang;

@property (weak, nonatomic) IBOutlet UINavigationItem *myitem;
@property (weak, nonatomic) IBOutlet UILabel *cumulativePoints;
@property (weak, nonatomic) IBOutlet UILabel *currentPoints;
@property (weak, nonatomic) IBOutlet UILabel *cumulativeExchange;
@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
//@property NSString* imagePath;
//@property NSString* imageUploadPath;

@end

@implementation MineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.exchangeBtn.layer.cornerRadius = 5.0;
    self.myTableView.tableHeaderView = self.headerView;
    self.avatar.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alterAvatar:)];
    [self.avatar addGestureRecognizer:singleTap];
    [self setHeadPortrait];
 
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"我的"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:18];
    self.navigationItem.titleView = customLab;
    
    self.myTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44);
}

-(void)setHeadPortrait{
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width/2;
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.borderWidth = 1.5f;
    self.avatar.layer.borderColor = [UIColor whiteColor].CGColor;
}
-(void)alterAvatar:(UITapGestureRecognizer*)gesture{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];

    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        
        [self presentViewController:PickerImage animated:YES completion:nil];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    NSString *imageURl =
    @"http://ios.lsxfpt.com/app/upload/upload/model/face.html";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer
                                  serializer];
    
    
    
    manager.responseSerializer.acceptableContentTypes =[NSSet
                                                        setWithObject:@"text/html"];
    
    [manager POST:imageURl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(newPhoto,
                                                                   1.0)
                                    name:@"text"
                                fileName:@"test.jpg"
                                mimeType:@"image/jpg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"success");
       // NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *dir = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",dir);
        imageUploadPath = dir;
        [self upload];
        
}
 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
    NSLog(@"fail");
}];
    self.avatar.image = newPhoto;
    [self reloadInputViews];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)upload{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer
                                  serializer];
        [manager POST:@"http://ios.lsxfpt.com/mcenter/information/upload_face.html" parameters:@{@"avatar":imageUploadPath}  constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"success again");
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"fail again");
        }];
        
    }

-(void)viewWillAppear:(BOOL)animated{
    
    
      self.tabBarController.tabBar.hidden =NO;
    [self getData];
    

    
}

-(void)getData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"u_id"];
//    NSLog(@"%@",str);
    if (str ==nil) {
        str =@"";
    }
    [manager GET:@"http://ios.lsxfpt.com/app/Linkmobile/index.html" parameters:@{@"u_id":str} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers  error:nil];
        
        NSArray* user = [dic objectForKey:@"users"];
        NSLog(@"%@",user);
        NSInteger status = [[dic objectForKey:@"status"]integerValue];
        if (status ==314) {
            NSLog(@"1");
        }else{
        NSDictionary* userInfo = user[0];
          
        NSString *employee_flg = [userInfo objectForKey:@"employee_flg"];
            if ([employee_flg isEqual:[NSNull null]]) {
                employee_flg =@"";
            }
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:employee_flg forKey:@"11"];
            
            
        self.consumption.text =  [NSString stringWithFormat:@"%@ 元",[userInfo objectForKey:@"paid_remain"]] ;
        self.balance.text =[NSString stringWithFormat:@"%@ 元",[userInfo objectForKey:@"paid_accumulatie"]] ;
        self.cumulativeIntegral.text = [userInfo objectForKey:@"score_power_accumulatie"];
        self.currentIntegral.text = [userInfo objectForKey:@"score_power"];
            
            
        self.cumulativePoints.text =[NSString stringWithFormat:@"%@ 分",[userInfo objectForKey:@"score_accumulatie"]];
        self.currentPoints.text = [NSString stringWithFormat:@"%@ 分",[userInfo objectForKey:@"score"]];
        self.cumulativeExchange.text = [NSString stringWithFormat:@"%@ 分",[userInfo objectForKey:@"money_accumulatie"]];
        self.mynane.text = [ userInfo objectForKey:@"nickname"];
            NSString *mobile = [userInfo objectForKey:@"mobile"];
        NSString *nicknmae = self.mynane.text;
     
        [defaults setObject:nicknmae forKey:@"nickname"];
            [defaults setObject:mobile forKey:@"mobile"];
        self.bianhao.text = [NSString stringWithFormat:@"会员编号：%@",[userInfo objectForKey:@"u_id"]] ;
        NSString * face = [userInfo objectForKey:@"face"];
        
        
            
            
            
        if ([face isEqual:[NSNull null]]) {
            
        }else{

        [self.touxiang sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ios.lsxfpt.com/attachs/%@",face]]];
        }
        
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"fail");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)exchange:(id)sender {
    
    
    WebViewController *webview = [[WebViewController alloc]init];
    NSString *str =@"http://ios.lsxfpt.com/linkmemberappwebview/user/profile/getmoney";
    webview.Web = str;
    
    [self.navigationController pushViewController:webview animated:YES];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyDetailViewController *mydetail = [[MyDetailViewController alloc]init];
//     NSLog(@"%d",indexPath.section);
//    NSLog(@"%d",indexPath.row);
//   
    
    
    
    if (indexPath.section==0) {
        if (indexPath.row ==0) {
            //累计消费
            
            
                    WebViewController *webview = [[WebViewController alloc]init];
                    NSString *str =@"http://ios.lsxfpt.com/linkmemberappwebview/user/center/paidlist";
                    webview.Web = str;
                    
                    [self.navigationController pushViewController:webview animated:YES];
                 }
    }else if (indexPath.section==1){
        
        
        
        
        if (indexPath.row ==0) {
            //累计赠送券
            
                    WebViewController *webview = [[WebViewController alloc]init];
                    NSString *str =@"http://ios.lsxfpt.com/linkmemberappwebview/user/center/scorepowerlist";
                    webview.Web = str;
                    
                    [self.navigationController pushViewController:webview animated:YES];
    
        
        
        }else {
            
        }
     }else if (indexPath.section == 2) {
            
            
            
     
         if (indexPath.row==0) {
        
        //累计积分
             WebViewController *webview = [[WebViewController alloc]init];
             NSString *str =@"http://ios.lsxfpt.com/linkmemberappwebview/user/center/scorelist";
             webview.Web = str;
        
             [self.navigationController pushViewController:webview animated:YES];
        
        
         }else if (indexPath.row == 2) {
             //累计兑换
             
             WebViewController *webview = [[WebViewController alloc]init];
             NSString *str =@"http://ios.lsxfpt.com/linkmemberappwebview/user/center/getmoneylist";
             webview.Web = str;
             
             [self.navigationController pushViewController:webview animated:YES];
         }
        
    
        
       if (indexPath.row ==3) {
            
            //兑换积分
            WebViewController *webview = [[WebViewController alloc]init];
            NSString *str =@"http://ios.lsxfpt.com/linkmemberappwebview/user/profile/getmoney";
            webview.Web = str;
            
            [self.navigationController pushViewController:webview animated:YES];
            
            
            
        }
        
        
    
}
    else if (indexPath.section ==3){
        if (indexPath.row ==0) {


            //电话
            NSString *str3 = [NSString stringWithFormat:@"telprompt://40006311333"];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str3]];

            
        }if (indexPath.row ==1) {
            //合作加盟
            CooperateViewController *coop = [[CooperateViewController alloc]init];
            
            
            [self.navigationController pushViewController:coop animated:YES];
            
        }if (indexPath.row==2) {
            [self showMessage:@"确定清理全部缓存？"];
        }if (indexPath.row ==3) {
//            
//            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//            [manager GET:BANBEN parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//                NSLog(@"%@",dic);
//                NSString *version = [dic objectForKey:@"version"];
//               downloadurl= [dic objectForKey:@"downloadurl"];
//                NSLog(@"%@",version);
//                NSDictionary *infoDic = [[NSBundle mainBundle]infoDictionary];
//                NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
//                NSLog(@"%@",currentVersion);
//                if ([version isEqualToString:currentVersion]) {
//                    [self showMessagee:@"当前为最新版本"];
//                }else{
//                    
//                    [self showMessagee:@"有新版本是否下载？"];
//                    
//                }
//                
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                
//            }];
        }
        
      
    }
    
    
    
}



// 计算缓存大小
- (NSString *)sizeOfCatch {
    // 获取缓存路径
    NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    float fileSize = [HaloClean folderSizeAtPath:cacheFilePath];
    return [NSString stringWithFormat:@"%.2fM",fileSize];
}

// 清除缓存
- (void)cleanCache {
    // 获取缓存路径
    NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    NSError *err;
    float fileSize = [HaloClean folderSizeAtPath:cacheFilePath];
    NSString *str =[NSString stringWithFormat:@"%.2fM",fileSize];
    NSLog(@"str:%@",str);
    UILabel *lb = [self.view viewWithTag:99];
    lb.text = @"0.00M";
    [HaloClean clearCahce:cacheFilePath WithError:err];
    if (err != nil) {
        [MBProgressHUD Message:@"清除失败，请再试一次" For:self.view yOffset:-150.0f];
        
    }else {
        [ MBProgressHUD Message:[NSString stringWithFormat:@"清除内存:%@",str] For:self.view yOffset:-0.0f];
    }
    
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag ==1) {
        if (buttonIndex ==1) {
            [self cleanCache];
        }

        
    }else{
        if (buttonIndex ==1) {
//           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1018221712"]];
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadurl]];
        }
        
    }
   }



- (void)showMessage:(NSString *)message{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag=1;
    [alertView show];
    
}

- (void)showMessagee:(NSString *)message{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 10;
    [alertView show];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}



#pragma mark - Table view data source



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
