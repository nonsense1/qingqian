//
//  CooperateViewController.m
//  frameTest
//
//  Created by 蔡晓宇 on 16/7/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "CooperateViewController.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "FirstDViewController.h"
#import "MBProgressHUD.h"
#import "ShangjiaViewController.h"
#define URLL @"http://ios.lsxfpt.com/app/linkmobile/appstoreadd.html"


@interface CooperateViewController (){
      NSMutableArray *namearray;
      NSMutableArray *urlarray;
    NSMutableArray *imagearray;
    NSString *imageUrl;
    UIScrollView *Sview;
}

@end

@implementation CooperateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    namearray = [NSMutableArray array];
    urlarray = [NSMutableArray array];
    imagearray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    self.view.frame= CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    Sview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:Sview];
    Sview.backgroundColor = [UIColor whiteColor];
    
    Sview.scrollEnabled =YES;
    Sview.contentSize = CGSizeMake(0, self.view.frame.size.height+300);
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:URLL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        imageUrl = [dic objectForKey:@"img_url"];
        
        NSArray *listArray = [dic objectForKey:@"list"];
        for (NSDictionary *dicc in listArray) {
            NSString *name = [dicc objectForKey:@"name"];
            NSString *url = [dicc objectForKey:@"url"];
            [namearray addObject:name];
            [urlarray addObject:url];
        }
       
        [self creatUI];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

-(void)creatUI{
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, self.view.frame.size.width-200, 100)];
    [Sview addSubview:lb];
    lb.text = @"合作加盟";
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = [UIFont systemFontOfSize:25];
    
    UIImageView * image  =[[UIImageView alloc]initWithFrame:CGRectMake(10, 110, self.view.frame.size.width-20, 600)];
    [Sview addSubview:image];
    NSLog(@"%@",imageUrl);
    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ios.lsxfpt.com%@",imageUrl]]];
    NSLog(@"%@",namearray);
    
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"11"];
    NSLog(@"%@",str);
    //判断是否是员工
    if ([str isEqualToString:@"1"]) {
        
         UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 700, 100, 50)];
        UILabel *lb1 =  [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 700+70, 100, 50)];
         UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, 700, 150, 50)];
        btn.tag=0;
        UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, 700+70, 150, 50)];
        btn1.tag=1;
        lb.text =namearray[0];
        lb1.text = namearray[1];
        [Sview addSubview:lb1];
        [Sview addSubview:btn1];
        lb1.textColor = [UIColor blackColor];
        [Sview addSubview:lb];
        [Sview addSubview:btn];
        lb.textColor = [UIColor blackColor];
        [btn setTitle:@"直接进入>>>" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setTitle:@"直接进入>>>" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

        
        
        
        
        
    }else{
    
        
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 700+70, 100, 50)];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, 700+70, 150, 50)];
        btn.tag=0;
        [Sview addSubview:lb];
        [Sview addSubview:btn];
        lb.text = namearray[0];
        lb.textColor = [UIColor blackColor];
        [btn setTitle:@"直接进入>>>" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
-(void)btnClick:(UIButton *)btn{
    NSInteger i =btn.tag;
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    ShangjiaViewController *first = [[ShangjiaViewController alloc]init];
    NSString *str = [NSString stringWithFormat:@"http://ios.lsxfpt.com%@",urlarray[i]];
    NSLog(@"%@",str);
    first.Web = str;
    [self.navigationController pushViewController:first animated:YES];
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
