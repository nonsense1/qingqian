//
//  SearchViewController.m
//  frameTest
//
//  Created by 许争妍 on 16/7/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchBarView.h"
#import "BusinessViewController.h"
@interface SearchViewController ()<UISearchBarDelegate>{
    
    NSArray *_dataSource ;
    UISearchBar * searchBarr;
}
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *hotBtns;
@property (weak, nonatomic) IBOutlet UITableView *searchHistory;




@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"left"] style:UIBarButtonItemStylePlain target:self action:@selector(leftitemBtn:)];
    self.navigationItem.leftBarButtonItem = leftitem;
    
     searchBarr = [[UISearchBar alloc] init];
    searchBarr.tag = 10;
    searchBarr.frame = CGRectMake(0, 0, self.navigationItem.titleView.bounds.size.width- 100, 0);
    searchBarr.delegate = self;
//    [searchBar sizeToFit]; //自动调整大小
    self.navigationItem.titleView = searchBarr;
  
       // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden =YES;
    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] lastObject] subviews]) {
        if([view isKindOfClass:[UIButton class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"搜索" forState:UIControlStateNormal];
            cancel.titleLabel.font = [UIFont systemFontOfSize:14];
            [cancel addTarget:self action:@selector(searchBarSearchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

-(void)leftitemBtn:(UIBarButtonItem *)btn{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    searchBar =searchBarr;
    NSString *str = searchBar.text;
    if ([str isEqualToString:@""]) {
        [self showMessage:@"输入不能为空"];
    }else{
    NSLog(@"%@",str);
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:str forKey:@"sousuo"];
    [userDef setObject:@"1" forKey:@"fanhui"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"haha"];
    BusinessViewController* bussiness = [[BusinessViewController alloc]init];
    self.tabBarController.tabBar.hidden =YES;
        
    [self.navigationController pushViewController:bussiness animated:NO];
    }
}

-(void)showMessage:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [searchBarr resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:@"1" forKey:@"haha"];
    [searchBarr resignFirstResponder];
    
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
