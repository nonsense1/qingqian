//
//  IndexViewController.m
//  frameTest
//
//  Created by 许争妍 on 16/7/1.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "IndexViewController.h"
#import "HomepageViewControllerTableViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "IndexModel.h"
#define SEARCH @"http://ios.lsxfpt.com/Appv2/index/getCityForName"
@interface IndexViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    
    
    NSString *city;
    NSString *str;
    NSMutableArray *_dataSource;
    NSMutableArray *_dataSource2;
     NSMutableArray *_dataSource3;
     NSMutableArray *_tempsource;
    NSMutableArray *_fenquSource;
    NSArray *Zimu;
 
    

 
    UISearchDisplayController *searchDisplayController;
   // __weak IBOutlet UISearchBar *_searchBar;
    NSArray *data;
    NSArray *filterData;
    NSMutableArray *cityidArray;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *currentCity;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *locationCity;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *recentCity;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *hotCitys;
#define CITY @"http://ios.lsxfpt.com/Appv2/index/city"


//@property NSArray *citysAry;//要显示的城市数组
@property NSMutableArray *indexArray;
@property NSArray *testArray;
@property NSMutableArray *allCity;
@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UISearchBar *_searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(40, 20, self.view.frame.size.width-80, 44)];
    [self.view addSubview:_searchBar];
    _searchBar.delegate = self;
    _searchBar.barStyle = UIBarStyleBlackTranslucent;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.placeholder = @"城市／行政区";
   // self.testArray = @[@"威海",@"北京",@"烟台"];
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
    cityidArray = [NSMutableArray array];
    _fenquSource = [NSMutableArray array];
    _dataSource = [NSMutableArray array];
     _dataSource2 = [NSMutableArray array];
    _dataSource3 = [NSMutableArray array];
    _tempsource = [NSMutableArray array];
    _allCity = [NSMutableArray array];
   
    [self reloadCityList];
    //[self getAllCitys];

    }
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] lastObject] subviews]) {
        if([view isKindOfClass:[UIButton class]]) {
            UIButton * cancel =(UIButton *)view;
            cancel.hidden = YES;
        }
    }
}


-(void)creatUI{
    NSString *locationName = [[NSUserDefaults standardUserDefaults]objectForKey:@"dingwei"];
    self.currentCity.text = locationName;
    [_locationCity setTitle:locationName forState:UIControlStateNormal];
     self.myTableView.tableHeaderView = self.headerView;
   
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.myTableView.sectionIndexColor = [UIColor redColor];
    [self.myTableView setBackgroundView:nil];
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.allowsSelection = YES;
    self.myTableView.showsHorizontalScrollIndicator = NO;
    self.myTableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.myTableView];
    

    //索引数组
    _indexArray = [[NSMutableArray alloc]init];
    for (char ch='A'; ch<='Z'; ch++) {
        if (ch=='I'||ch=='O'||ch=='U'||ch=='V')
            continue;
        [_indexArray addObject:[NSString stringWithFormat:@"%c",ch]];
    }
    
    
    
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//btn点击
- (IBAction)btnClick:(UIButton *)sender {

    
 if (sender.tag ==1){
        //定位城市
        city = [[NSUserDefaults standardUserDefaults]objectForKey:@"dingwei"];
        //NSLog(@"%@",city);
        str = [[NSUserDefaults standardUserDefaults]objectForKey:@"dingwei_id"];
        //NSLog(@"%@",str);
          NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:city forKey:@"city"];
        [defaults setObject:str forKey:@"city_id"];
    }else if (sender.tag ==2){
        city =@"威海";
        str =@"10";
        
        
        
    }else if (sender.tag ==3){
        
        city =@"合肥";
        str =@"2";
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:city forKey:@"city"];
    [defaults setObject:str forKey:@"city_id"];
    //NSLog(@"%@",str);
    [self  dismissViewControllerAnimated:YES completion:nil];
  

}
//获取城市列表
-(void)reloadCityList{
 Zimu = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"J",@"K",@"L",@"M",@"N",@"P",@"Q",@"R",@"S",@"T",@"W",@"X",@"Z"];
AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
manager.responseSerializer = [AFHTTPResponseSerializer serializer];


    [manager GET:CITY parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *msg = [dic objectForKey:@"msg"];
        for (NSString *strr in Zimu) {
            NSArray *arr = [msg valueForKey:[NSString stringWithFormat:@"%@",strr]];
            
            if (arr !=nil) {
                [_fenquSource addObject:strr];
                [_dataSource addObject:arr];
            }
        }
 
        for (NSArray *arr3 in _dataSource) {
            _tempsource = [NSMutableArray array];
            for (int i=0; i<arr3.count; i++) {
                
                IndexModel *model  =[[IndexModel alloc]init];
            
            model.city_id=[arr3[i] objectForKey:@"city_id"] ;
                
            model.name = [arr3[i] objectForKey:@"name"];
                [_tempsource addObject:model];
            }
            [_dataSource3 addObject:_tempsource];
        }
    [self getAllCitys];    
  [self creatUI];
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    [MBProgressHUD Message:@"当前无网络" For:self.view yOffset:-150.0f];
}];
  
}


-(void)getAllCitys{
filterData = [NSMutableArray array];
    IndexModel* model;
    for (int i=0; i<_dataSource3.count; i++) {
        NSArray* citys = _dataSource3[i];
        for (model in citys) {
            NSString* cityName = model.name;
//            NSLog(@"%@",cityName);
            [_allCity addObject:cityName];
            
        }

        }
//    NSLog(@"11111111111111111");
//    NSLog(@"%lu",(unsigned long)_allCity.count);
    }
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.myTableView){
        NSLog(@"%d",_dataSource3.count);
        NSLog(@"%d",[[_dataSource3 objectAtIndex:section]count]);
          return [[_dataSource3 objectAtIndex:section]count];
    }else{
        
//        NSLog(@"%d",filterData.count);
        return filterData.count;
    }
  
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.myTableView) {
        return _fenquSource.count;
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchDisplayController.searchBar.text];
        
        filterData =  [[NSArray alloc] initWithArray:[_allCity filteredArrayUsingPredicate:predicate]];
      
        
        NSLog(@"%@",filterData);
        
        return 1;
    }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.myTableView) {
        IndexModel *model = _dataSource3[indexPath.section][indexPath.row];
        NSString *cityid = model.city_id;
        NSString *cityname =model.name;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:cityid forKey:@"city_id"];
        [defaults setObject:cityname forKey:@"city"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        NSString *cityid = cityidArray[indexPath.row];
//        NSLog(@"%@",cityid);
       
        NSString *cityname =filterData[indexPath.row];
//         NSLog(@"%@",cityname);
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:cityid forKey:@"city_id"];
        [defaults setObject:cityname forKey:@"city"];
     [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}





-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cityidArray = [NSMutableArray array];
    static NSString* idStr = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idStr];

   
    if (tableView == self.myTableView){
    
    
    
//       NSLog(@"%@",_dataSource3);
    IndexModel *model = _dataSource3[indexPath.section][indexPath.row];
    
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idStr];
        
    }
    if (tableView == self.myTableView) {
        cell.textLabel.text = model.name;

    }
    }else{
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idStr];

//            NSLog(@"%d",filterData.count);
//            NSLog(@"%d",indexPath.row);
//            NSLog(@"%@",filterData[indexPath.row]);
//        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:SEARCH parameters:@{@"cityname":filterData[indexPath.row]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",filterData[indexPath.row]);
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"%@",dic);
        
            NSDictionary* msg = [dic objectForKey:@"msg"];
            NSString *city_id = [msg objectForKey:@"city_id"];
            [cityidArray addObject:city_id];
//            NSLog(@"%@",cityidArray);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        cell.textLabel.text = filterData[indexPath.row];
        
        NSLog(@"-----%@",cell.textLabel.text);
        
        
        
        
    }

    
    return cell;
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.myTableView) {
         return [_fenquSource objectAtIndex:section];
    }
    else{
        return 0 ;
    }
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return Zimu;
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
