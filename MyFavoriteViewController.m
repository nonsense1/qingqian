//
//  MyFavoriteViewController.m
//  frameTest
//
//  Created by 许争妍 on 16/6/29.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MyFavoriteViewController.h"
#import "BusinessTableViewCell.h"
#import "AFNetworking.h"
#import "BusinessModel.h"
#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "loveModel.h"
#import "LoginViewController.h"
#define LOVE @"http://ios.lsxfpt.com/app/favorites/index/"
#import "MJRefresh.h"
#define ZENGSONG @"http://ios.lsxfpt.com/linkmemberappwebview/user/index/is_login"

#define USERid [[NSUserDefaults standardUserDefaults]objectForKey:@"u_id"]
@interface MyFavoriteViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    UISearchBar * lovesearchBar;
    NSMutableArray *_datasource;
    int _page;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;



@end

@implementation MyFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page=1;
  _datasource = [NSMutableArray array];
  lovesearchBar= [[UISearchBar alloc] init];
    //lovesearchBar.frame = CGRectMake(50, 64, self.view.frame.size.width-100, 0);
    lovesearchBar.frame = CGRectMake(0, 64, self.view.frame.size.width, 0);
    lovesearchBar.delegate = self;
    [lovesearchBar sizeToFit]; //自动调整大小
//    self.navigationItem.titleView = searchBar;
    [self.view addSubview:lovesearchBar];
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"我的关注"];
    customLab.textAlignment = NSTextAlignmentCenter;
    customLab.font = [UIFont boldSystemFontOfSize:18];
    self.navigationItem.titleView = customLab;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.myTableView addGestureRecognizer:gestureRecognizer];
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self upRefresh];
        //表格刷新完毕 结束视图刷新
        
    }];

    // Do any additional setup after loading the view.
}

-(void)hideKeyboard{
    [lovesearchBar resignFirstResponder];
}
-(void)creatUI{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [_myTableView registerNib:[UINib nibWithNibName:@"BusinessTableViewCell" bundle:nil] forCellReuseIdentifier:@"re"];

    
    
}
//搜索的协议方法
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _datasource = [NSMutableArray array];
    NSString *str = searchBar.text;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:str forKey:@"guanzhu"];
    //    NSLog(@"%dadasd");
    [searchBar resignFirstResponder];
    
    [self download];
    
    
    
}








//释放第一响应
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];}




    

-(void)upRefresh{
    _page++;
    
    
    [self download];
}



    
-(void)viewWillAppear:(BOOL)animated{
  
    _page=1;
  self.tabBarController.tabBar.hidden =NO;

    
      [self download];
}


//下载
-(void)download{
    NSString *lat = [[NSUserDefaults standardUserDefaults]objectForKey:@"lat"];
    NSLog(@"%@",lat);
    NSString *lng = [[NSUserDefaults standardUserDefaults]objectForKey:@"lng"];
    if (_page<=1) {
         _datasource = [NSMutableArray array];
    }
    
   
    NSString *guanzhu = [[NSUserDefaults standardUserDefaults]objectForKey:@"guanzhu"];
    if (lat==nil) {
        lat =@"";
    }
    
    
    if (lng ==nil) {
        lng =@"";
    }
    
    NSLog(@"---------------------------------%@",guanzhu);
    if (guanzhu ==nil) {
        guanzhu =@"";
    }
    
    NSString *love = [[NSUserDefaults standardUserDefaults]objectForKey:@"zhuangtai"];
    
    NSLog(@"love%@",love);
     NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    if (uid ==nil) {
        uid =@"";
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"%@",uid);
    NSString *page = [NSString stringWithFormat:@"%d",_page];
    NSLog(@"page:%@",page);
    NSLog(@"%@",guanzhu);
    [manager GET:LOVE parameters:@{@"uid":uid,@"like":guanzhu,@"lat":lat,@"lng":lng,@"page":page} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        NSArray *shops = [dic objectForKey:@"shops"];
//        NSLog(@"149行：%lu",(unsigned long)shops.count);
        if ([shops isEqual:[NSNull null]]) {
            _datasource = [NSMutableArray array];
            
        }else{
            for (int i=0; i<shops.count; i++) {
                loveModel * model = [[loveModel alloc]init];
                model.shop_name = [shops[i] objectForKey:@"shop_name"];
                NSLog(@"******************%@",model.shop_name);
                model.shop_id = [shops[i] objectForKey:@"shop_id"];
                model.photo = [shops[i] objectForKey:@"photo"];
                model.d = [shops[i] objectForKey:@"d"];
                model.score= [[shops[i] objectForKey:@"score"]integerValue];
                model.score_num= [shops[i] objectForKey:@"score_num"];
                model.addr = [shops[i] objectForKey:@"addr"];
                [_datasource addObject:model];
               }
        }
     
        [self.myTableView.mj_footer endRefreshing];
        [_myTableView reloadData];
        [self creatUI];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}



////下载
//-(void)downloadd{
//    NSString *lat = [[NSUserDefaults standardUserDefaults]objectForKey:@"lat"];
//    NSLog(@"%@",lat);
//    NSString *lng = [[NSUserDefaults standardUserDefaults]objectForKey:@"lng"];
//    
//    NSString *guanzhu = [[NSUserDefaults standardUserDefaults]objectForKey:@"guanzhu"];
//    if (lat==nil) {
//        lat =@"";
//    }
//    
//    
//    if (lng ==nil) {
//        lng =@"";
//    }
//    
//    NSLog(@"---------------------------------%@",guanzhu);
//    if (guanzhu ==nil) {
//        guanzhu =@"";
//    }
//    
//    NSString *love = [[NSUserDefaults standardUserDefaults]objectForKey:@"zhuangtai"];
//    
//    NSLog(@"love%@",love);
//    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
//    if (uid ==nil) {
//        uid =@"";
//    }
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSLog(@"%@",uid);
//    NSString *page = [NSString stringWithFormat:@"%d",_page];
//    NSLog(@"page:%@",page);
//    NSLog(@"%@",guanzhu);
//    [manager GET:LOVE parameters:@{@"uid":uid,@"like":guanzhu,@"lat":lat,@"lng":lng,@"page":page} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic);
//        
//        NSArray *shops = [dic objectForKey:@"shops"];
//        //        NSLog(@"149行：%lu",(unsigned long)shops.count);
//        
//        
//        if ([shops isEqual:[NSNull null]]) {
//            _datasource = [NSMutableArray array];
//            
//        }else{
//            
//            
//            
//            for (int i=0; i<shops.count; i++) {
//                loveModel * model = [[loveModel alloc]init];
//                model.shop_name = [shops[i] objectForKey:@"shop_name"];
//                 NSLog(@"******************%@",model.shop_name);
//                model.shop_id = [shops[i] objectForKey:@"shop_id"];
//                model.photo = [shops[i] objectForKey:@"photo"];
//                model.d = [shops[i] objectForKey:@"d"];
//                model.score= [[shops[i] objectForKey:@"score"]integerValue];
//                model.score_num= [shops[i] objectForKey:@"score_num"];
//                model.addr = [shops[i] objectForKey:@"addr"];
//                [_datasource addObject:model];
//            }
//        }
//        
//        [self.myTableView.mj_footer endRefreshing];
//        [_myTableView reloadData];
//      
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
//}
//
//
//
//
//
//
//
//
//
//
//
//

















-(void)viewWillDisappear:(BOOL)animated{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"guanzhu"];
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"guanzhu"];
    
    NSLog(@"%@",str);
    
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"re" forIndexPath:indexPath];
    if (_datasource.count==0) {
        return cell;
    }else{
        
        loveModel * model = _datasource[indexPath.row];
        if ([model.shop_name  isEqual:@""]) {
            return cell;
        }
        else{
            cell.businessName.text = model.shop_name;
            NSLog(@"%@",model.shop_name);
            cell.address.text = model.addr;
            int score =model.score;
            NSLog(@"socore:%d",score);
        if (score==0) {
            [cell.starImage setImage:[UIImage imageNamed:@"0"]];
        }else if (score<=5){
             [cell.starImage setImage:[UIImage imageNamed:@"0.5"]];
        }
        else if (score<=10) {
            [cell.starImage setImage:[UIImage imageNamed:@"1"]];
        }else if (score<=15) {
            [cell.starImage setImage:[UIImage imageNamed:@"1.5"]];
        }else if (score<=20) {
            [cell.starImage setImage:[UIImage imageNamed:@"2"]];
        }else if (score<=25) {
            [cell.starImage setImage:[UIImage imageNamed:@"2.5"]];
        }else if (score<=30) {
            [cell.starImage setImage:[UIImage imageNamed:@"3"]];
        }else if (score<=35) {
            [cell.starImage setImage:[UIImage imageNamed:@"3.5"]];
        }else if (score<=40) {
            [cell.starImage setImage:[UIImage imageNamed:@"4"]];
        }else if (score<=45) {
            [cell.starImage setImage:[UIImage imageNamed:@"4.5"]];
        }else if (score<=50) {
            [cell.starImage setImage:[UIImage imageNamed:@"5"]];
        }
        cell.distance.text =[NSString stringWithFormat:@"<%@",model.d];
        NSLog(@"%@",cell.distance.text);
        cell.comments.text = [NSString stringWithFormat:@"%@评价",model.score_num];
         [cell.businessImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ios.lsxfpt.com/attachs/%@",model.photo]]];
        cell.shop_id = model.shop_id;
    }
    
    return cell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datasource.count;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detail = [[DetailViewController alloc]init];
    
    NSLog(@"263行：%lu",(unsigned long)_datasource.count);
    loveModel *model =_datasource[indexPath.row];
    detail.shop_id = model.shop_id;
    NSString * str = [NSString stringWithFormat:@"http://ios.lsxfpt.com/appwebview/shop/detail/shop_id/%@",model.shop_id];
    detail.detailUrl =str;
    //[self.navigationController presentViewController:detail animated:YES completion:^{
    
    [self.navigationController  pushViewController:detail animated:YES];
    
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
