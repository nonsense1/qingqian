//
//  BusinessViewController.m
//  frameTest
//
//  Created by 许争妍 on 16/6/27.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BusinessViewController.h"
#import "BusinessTableViewCell.h"
#import "SearchBarView.h"
#import "DOPDropDownMenu.h"
#import "AFNetworking.h"
#import "BusinessModel.h"
#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#define SHANGJIA @"http://ios.lsxfpt.com/App/shop/loaddata.html"
#define FENLEI @"http://ios.lsxfpt.com/app/shop/getShopCats"
#define CHENGSHI @"http://ios.lsxfpt.com/app/shop/getShopAreaByCityId"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "SearchViewController.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "UIImage+animatedGIF.h"
#import "BussDetailViewController.h"

#define USERid [[NSUserDefaults standardUserDefaults]objectForKey:@"u_id"]
@interface BusinessViewController ()<UITableViewDataSource,UITableViewDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,MBProgressHUDDelegate,UINavigationControllerDelegate>{
    
    //一级标题数组
    NSMutableArray *titleArray;
    NSMutableArray *secondtitle;
    NSMutableArray *secondArray;
    NSMutableArray *arrar;
    NSMutableArray *chengshi;
    NSMutableArray *chengshiarr;
    NSMutableArray *_dataArray;
    NSMutableArray *business_id;
    NSMutableArray *business;
    NSMutableArray *city_id;
    NSMutableArray *area_ids;
    NSMutableArray *cat_ids;
    NSMutableArray *cat_id;
    NSMutableArray *area_names;
    NSMutableArray *area;
    NSString *pinjie;
    NSString *cat;
}
@property UITableView *tableView;
@property (nonatomic, strong) NSArray *classifys;
@property (nonatomic, strong) NSArray *cates;
@property (nonatomic, strong) NSArray *movices;
@property (nonatomic, strong) NSArray *hostels;
@property (nonatomic, strong) NSArray *areas;
@property (nonatomic, strong) NSArray *furongareas;
@property (nonatomic, strong) NSArray *sorts;
@property (nonatomic, strong) NSArray *mdzz;
@property (nonatomic, weak) DOPDropDownMenu *menu;
@property NSString *city;
@property(nonatomic,copy)MBProgressHUD *HUD;
@end

@implementation BusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//   self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = [UIColor whiteColor];
   
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 0,self.view.frame.size.width-60,30)];
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [label addGestureRecognizer:singleTap7];
    label.text = @"请输入商家名";
    label.textColor = [UIColor lightGrayColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    label.layer.cornerRadius = 5.0;
    label.clipsToBounds = YES;
    
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    //地区及商圈
   

}
- (void)layoutViewsAnimation {
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.mode = MBProgressHUDModeCustomView;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"defamation" withExtension:@"gif"];
    UIImage *gifImage = [UIImage animatedImageWithAnimatedGIFURL:url];
    UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 44, 100, 100)];
    gifImageView.image = gifImage;
    gifImageView.layer.cornerRadius = 50;
    gifImageView.layer.masksToBounds = YES;
    _HUD.customView = gifImageView;
    _HUD.delegate = self;
    _HUD.labelText = @"加载中";
    //    [self downRefresh];
}
-(void)viewWillAppear:(BOOL)animated{
    business = [NSMutableArray array];
    business_id = [NSMutableArray array];
    cat_id =[NSMutableArray array];
    cat_ids =[NSMutableArray array];
    area_names = [NSMutableArray array];
    secondArray = [NSMutableArray array];
    secondtitle = [NSMutableArray array];
    pinjie = @"http://ios.lsxfpt.com/attachs/";
    area = [NSMutableArray array];
    city_id = [NSMutableArray array];
    area_ids = [NSMutableArray array];
    //    _data2 = [NSMutableArray array];
    titleArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    arrar =[[NSMutableArray alloc]init];
    //    _data1 = [[NSMutableArray alloc]init];
    chengshi = [NSMutableArray array];
    chengshiarr = [NSMutableArray array];
    NSString *str  = [[NSUserDefaults standardUserDefaults]objectForKey:@"haha"];
    NSLog(@"%@",str);
    NSLog(@"%@",self.biaoji);
    if ([self.biaoji isEqualToString:@"1" ] || [str isEqualToString:@"1"]) {
        self.tabBarController.tabBar.hidden =YES;
    }else{
        self.tabBarController.tabBar.hidden =NO;
    }
    AFNetworkReachabilityManager *kManager = [AFNetworkReachabilityManager sharedManager];
    [kManager startMonitoring];
    [kManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            
            
            
            
        }else {
            [self loadareas];
            [self layoutViewsAnimation];
            [self fenleidownload];
        }
    }];
    
    //  创建标题菜单
      //一级分类
    
}
-(void)creatUI{
    //  创建标题菜单
   


      _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,110, self.view.bounds.size.width, self.view.bounds.size.height-110)style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib: [UINib nibWithNibName:@"BusinessTableViewCell" bundle:nil]  forCellReuseIdentifier:@"re"];
    [self.view addSubview:_tableView];
    self.sorts = @[@"距离优先",@"默认排序"];
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
    _menu = menu;
    // 创建menu 第一次显示 不会调用点击代理，可以用这个手动调用
    [menu selectDefalutIndexPath];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self downRefresh];
        
    }];
    
    [header setTitle:@"自定义状态" forState:MJRefreshStatePulling];
    _tableView.mj_header = header;
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self upRefresh];
        //表格刷新完毕 结束视图刷新
     
    }];
    
    
}





-(void)click:(UITapGestureRecognizer *)gestureRecognizer{
    NSString *str1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"fanhui"];
    NSLog(@"%@",str1);
    
    NSString *str  = [[NSUserDefaults standardUserDefaults]objectForKey:@"haha"];
    
    if ([str isEqualToString:@"1"] && [str1 isEqualToString:@"1"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchViewController *search = [story instantiateViewControllerWithIdentifier:@"search"];
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                             forBarMetrics:UIBarMetricsDefault];
        [self.navigationController pushViewController:search animated:YES];
    }
    
}



- (void)downRefresh{
    //下拉刷新的时候 情况所有数据
    _page = 1;
    [_dataArray removeAllObjects];
    [self downloadd];
    
    
}
-(void)upRefresh{
    _page++;
    
    
    [self downloadd];
}


- (void)menuReloadData
{

    [_menu reloadData];
}


- (IBAction)selectIndexPathAction:(id)sender {
    [_menu selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:2 item:2]];
}



- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 3;
}//
//三个栏 对应的一级标题
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return titleArray.count;
    }else if (column == 1){
        if (chengshi.count==0) {
            return 0;
        }else{
        return chengshi.count;
        }
    }else {
        return self.sorts.count;
    }
}
//一级标题
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        if (titleArray.count==0) {
            return 0;
        }else{
        
        NSLog(@"250行：%d",titleArray.count);
        return titleArray[indexPath.row];
        }
    } else if (indexPath.column == 1){
        if (area_names.count==0) {
            return 0;
        }else{
        
        return area_names[indexPath.row];
        }
    } else {
        return self.sorts[indexPath.row];
        
    }
}
- (NSString *)menu:(DOPDropDownMenu *)menu imageNameForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    //    if (indexPath.column == 0 || indexPath.column == 1) {
    //        return [NSString stringWithFormat:@"ic_filter_category_%ld",(long)indexPath.row];
    //    }
    return nil;
}

- (NSString *)menu:(DOPDropDownMenu *)menu imageNameForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    //    if (indexPath.column == 0 && indexPath.item >= 0) {
    //        return [NSString stringWithFormat:@"ic_filter_category_%ld",(long)indexPath.item];
    //    }
    return nil;
}

// new datasource

- (NSString *)menu:(DOPDropDownMenu *)menu detailTextForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    //    if (indexPath.column < 2) {
    //        return [@(arc4random()%1000) stringValue];
    //    }
    return nil;
}

- (NSString *)menu:(DOPDropDownMenu *)menu detailTextForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    //    return [@(arc4random()%1000) stringValue];
    return nil;
}




//点击  二级的数目
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    if (column ==0) {
        if (row == 0) {
            return 0;
        } else if (row > 0){
            NSMutableArray *ma=secondtitle[row];
            NSInteger ima=ma.count;
            return ima;
            
        }
    }
    if (column==1) {
        if (row==0) {
            return 0;
        }else if (row >0){
            NSMutableArray * diqu  =chengshi[row];
        
            NSInteger cheng = diqu.count;
       
            return cheng;
        }
    }
    if (column==2) {
        if (row==0) {
            return self.mdzz.count;
        }
    }
    return 0;
}
//二级列表 赋值

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        
        return secondtitle[indexPath.row][indexPath.item];
    }
    
    if (indexPath.column == 1) {
        if (chengshi.count==0) {
            return 0;
        }else{
    
        return chengshi[indexPath.row][indexPath.item];
    }
    }
    if (indexPath.column == 2) {
        if (indexPath.row == 0) {
            return self.mdzz[indexPath.item];
        }
    }
    
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   
    if (indexPath.item >= 0) {
        
        if (indexPath.column==0) {
            NSString *catid =  cat_ids[indexPath.row][indexPath.item];
            
            
            [defaults setValue:catid forKey:@"cat"];
            [self downloadd];
            //
        }
        
        NSLog(@"点击了 %ld - %ld - %ld 项目",(long)indexPath.column,(long)indexPath.row,(long)indexPath.item);
        if (indexPath.column ==1) {
            
           
            NSString *businessid = business_id[indexPath.row][indexPath.item];
            NSString *area_i = area_ids[indexPath.row];
            
            [defaults setValue:area_i forKey:@"areaid"];
            
            [defaults setValue:businessid forKey:@"business"];
            [self downloadd];
        }
    }else {
        if (indexPath.column==2) {
            NSArray *order = @[@"1",@"2"];
            NSString * orderr = order[indexPath.row];
            [defaults setValue:orderr forKey:@"order"];
            [self downloadd];
        }
    }
    
    _page=1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"416行：%d",_dataArray.count);
    return _dataArray.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"re" forIndexPath:indexPath];
    if (_dataArray.count==0) {
        
    }else{
    BusinessModel *model =_dataArray[indexPath.row];
    
  
    if ([model.shop_name  isEqual:@""]) {
        return cell;
    }
    else{
        cell.businessName.text = model.shop_name;
        cell.address.text = model.addr;
        int score =model.score;
    
        if (score==0) {
          
            [cell.starImage setImage:[UIImage imageNamed:@"0"]];
            
        } else if(score<=5){
            
          [cell.starImage setImage:[UIImage imageNamed:@"0.5"]];
        } else if (score<=10) {
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
        cell.comments.text = [NSString stringWithFormat:@"%@评价",model.score_num];
        [cell.businessImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ios.lsxfpt.com/attachs/%@",model.photo]]];
        cell.shop_id = model.shop_id;
        
    }
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


//获取分类标题
-(void)fenleidownload{
     _dataArray = [[NSMutableArray alloc]init];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:FENLEI parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr  = [dic objectForKey:@"CatList"];
        NSLog(@"%@",arr);
        for (int i=0; i<arr.count; i++) {
            NSString *strr = [arr[i] objectForKey:@"cate_name"];
            [titleArray addObject:strr];
            NSArray *erji = [arr[i] objectForKey:@"childrenCatList"];
            for (NSDictionary *dicChi in erji) {
                [secondArray addObject:[dicChi objectForKey:@"cate_name"]];
                
                [cat_id addObject:[dicChi objectForKey:@"cate_id"]];
            }
            secondtitle[i] = secondArray;
            cat_ids[i] =cat_id;
            //qingkong
            secondArray = [NSMutableArray array];
            cat_id = [NSMutableArray array];
        }
        
        [self download];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"1");
    }];
    
}
//详细页面
-(void)download{
     NSString *catt = [[NSUserDefaults standardUserDefaults]objectForKey:@"cat"];
    if ([self.biaoji isEqualToString:@"1"]) {
       
             if (catt ==nil) {
            catt =@"";
        }
        
    }else{
        
     catt =@"";
        
    }
 
    NSString *sousuo = [[NSUserDefaults standardUserDefaults]objectForKey:@"sousuo"];
    NSLog(@"%@",sousuo);
    
  
    if (sousuo ==nil) {
        sousuo =@"";
    }
    NSString *cityid = [[NSUserDefaults standardUserDefaults]objectForKey:@"city_id"];
    if (cityid==nil) {
        cityid =@"10";
    }
    
    
    NSString *lat = [[NSUserDefaults standardUserDefaults]objectForKey:@"lat"];
    NSString *lng = [[NSUserDefaults standardUserDefaults]objectForKey:@"lng"];
    NSLog(@"%@",lat);
    NSLog(@"%@",lng);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if (lat ==nil) {
        lat =@"";
    }
    if (lng ==nil) {
        lng =@"";
    }
    NSLog(@"%@",lat);
    NSLog(@"%@",lng);
    NSLog(@"%@",catt);
    [manager GET:SHANGJIA parameters:@{@"city_id":cityid,@"cat":catt,@"area":@"",@"business":@"",@"order":@"",@"p":@"0000",@"keyword":sousuo,@"lat":lat,@"lng":lng} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        NSArray *arr = [dic objectForKey:@"shop_list"];
        NSString *arrr = [dic objectForKey:@"shop_list"];
        if ([arr isEqual:[NSNull null]]) {
            _dataArray = [NSMutableArray array];
        }else{
        for (int i =0; i<arr.count; i++) {
            BusinessModel * model = [[BusinessModel alloc]init];
            model.addr = [arr[i] objectForKey:@"addr"];
            model.shop_name = [arr[i] objectForKey:@"shop_name"];
            model.tags = [arr[i] objectForKey:@"tags"];
            model.logo = [arr[i] objectForKey:@"logo"];
            model.photo = [arr[i] objectForKey:@"photo"];
            model.score= [[arr[i] objectForKey:@"score"]integerValue];
            model.score_num= [arr[i] objectForKey:@"score_num"];
            model.d = [arr[i] objectForKey:@"d"];
            model.shop_id = [arr[i] objectForKey:@"shop_id"];
            [_dataArray addObject:model];
        }
        }
        [self creatUI];
        [_tableView reloadData];
        _HUD.removeFromSuperViewOnHide = YES;
        [_HUD hide:YES ];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//点击栏目 的下载方法
-(void)downloadd{
    
  NSString *catt =[[NSUserDefaults standardUserDefaults] objectForKey:@"cat"];
    if (catt==nil) {
        catt =@"";
    }
    NSString *busi = [[NSUserDefaults standardUserDefaults]objectForKey:@"business"];
    if (busi==nil) {
        busi =@"";
    }
    NSString *area_i = [[NSUserDefaults standardUserDefaults]objectForKey:@"areaid"];
    if (area_i==nil) {
        area_i =@"";
    }
    
    NSString *order = [[NSUserDefaults standardUserDefaults]objectForKey:@"order"];
    if (order ==nil) {
        order =@"1";
    }
    NSString *sousuo = [[NSUserDefaults standardUserDefaults]objectForKey:@"sousuo"];
    
    if (sousuo ==nil) {
        sousuo =@"";
    }
    NSString *cityid = [[NSUserDefaults standardUserDefaults]objectForKey:@"city_id"];

    NSLog(@"取到的分类id是：%@",catt);
    NSLog(@"取到的城市id是：%@",busi);
    NSLog(@"取到的商圈id是：%@",area_i);
    NSLog(@"排序方式是：%@",order);
    NSLog(@"搜索的内容是：%@",sousuo);
    NSLog(@"城市列表：%@",cityid);
    
    if (cityid==nil) {
        cityid =@"10";
    }
    if (_page<=1) {
        _dataArray =[NSMutableArray array];
    }
    NSString *lat = [[NSUserDefaults standardUserDefaults]objectForKey:@"lat"];
    NSString *lng = [[NSUserDefaults standardUserDefaults]objectForKey:@"lng"];
    
    if (lat ==nil ||lng ==nil) {
        lat =@"";
        lng=@"";
    }
    
     NSString *page = [NSString stringWithFormat:@"%d",_page];
    NSLog(@"当前页数%d",_page);
    NSLog(@"记录经纬度%@ %@",lat,lng);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:SHANGJIA parameters:@{@"city_id":cityid,@"cat":catt,@"area":area_i,@"business":busi,@"order":order,@"p":page,@"keyword":sousuo,@"lat":lat,@"lng":lng} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr = [dic objectForKey:@"shop_list"];
        if ([arr isEqual:[NSNull null]]) {
            
            _dataArray =[NSMutableArray array];
            
        }else{
            for (int i =0; i<arr.count; i++) {
                BusinessModel * model = [[BusinessModel alloc]init];
                model.addr = [arr[i] objectForKey:@"addr"];
                model.shop_name = [arr[i] objectForKey:@"shop_name"];
                model.tags = [arr[i] objectForKey:@"tags"];
                model.logo = [arr[i] objectForKey:@"logo"];
                model.photo = [arr[i] objectForKey:@"photo"];
                model.score= [[arr[i] objectForKey:@"score"]integerValue];
                model.score_num= [arr[i] objectForKey:@"score_num"];
                model.d = [arr[i] objectForKey:@"d"];
                model.shop_id = [arr[i] objectForKey:@"shop_id"];
                [_dataArray addObject:model];
                
            }
        }
       
      
        [_tableView.mj_header  endRefreshing];
        
        [_tableView.mj_footer endRefreshing];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}




-(void)viewWillDisappear:(BOOL)animated{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sousuo"];
    if ([self.biaoji isEqualToString:@"1"]) {
        
    }else{
         [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"cat"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"shop_id"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"business"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"areaid"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"order"];
    }
     [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"haha"];
     [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"fanhui"];
 
}
//城市列表
-(void)loadareas{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
      NSString *cityid = [[NSUserDefaults standardUserDefaults]objectForKey:@"city_id"];
    NSLog(@"%@",cityid);
    if (cityid == nil) {
        cityid = @"";
    }
    [manager GET:CHENGSHI parameters:@{@"city_id":cityid} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        
        NSArray *ShopAreas = [dic objectForKey:@"ShopAreas"];
        NSString *ShopArea = [dic objectForKey:@"ShopAreas"];
        
        //如果为空
        if ([ShopArea isEqual:[NSNull null]]) {
            NSLog(@"列表为空");
            chengshi = [NSMutableArray array];
            business_id =[NSMutableArray array];
        }else{
            
            
            
            
        for (int i=0; i<ShopAreas.count; i++) {
          
            NSString *area_name = [ShopAreas[i] objectForKey:@"area_name"];
            if (area_name == nil) {
                area_name = @"";
            }
            NSLog(@"%@",area_name);
            NSString *area_id =[ShopAreas[i] objectForKey:@"area_id"];
            if (area_id == nil) {
                area_id = @"";
            }
            [area_ids addObject:area_id];
        
            [area_names addObject:area_name];
            NSLog(@"%lu",(unsigned long)area_names.count);

            NSArray *businesslist =[ShopAreas[i] objectForKey:@"businessList"];
            NSString *businesss = [ShopAreas[i] objectForKey:@"businessList"];
            if (businesss == nil) {
                businesss = @"";
            }
            NSLog(@"-----------%@",businesslist);
            NSLog(@"%@",businesss);
            if (businesslist.count<1) {
                NSLog(@"无商圈");
            }else{
            
            NSArray *businessList = [ShopAreas[i] objectForKey:@"businessList"];
            
                NSLog(@"%@",businessList);
            
            
            for (NSDictionary *dicChi in businessList) {
                //城市三级名字
                [chengshiarr addObject:[dicChi objectForKey:@"business_name"]];
           
//
                NSString * businessid = [dicChi objectForKey:@"business_id"];
                NSLog(@"%@",businessid);
                if (businessid ==nil) {
                     NSString *is_hot = [dicChi objectForKey:@"area_id"];
                    
                    [business addObject:is_hot];
                    
                }else{
               
                
                //城市三级id
                [business addObject:[dicChi objectForKey:@"business_id"]];
                
            }
                
              
            }
            
        }
        
              chengshi[i] = chengshiarr;
            business_id[i] =business;
            chengshiarr = [NSMutableArray array];
            business = [NSMutableArray array];
          
        }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BussDetailViewController *detail = [[BussDetailViewController alloc]init];
    
    if (_dataArray.count==0) {
        return;
    }
    BusinessModel *model =_dataArray[indexPath.row];
    
    //    NSString * str = [NSString stringWithFormat:@"http://ios.lsxfpt.com/appwebview/shop/detail/shop_id/%@",model.shop_id];
    
    detail.shop= model.shop_id;
    //    detail.detailUrl =str;
    [self.navigationController  pushViewController:detail animated:YES];
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    
    
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
