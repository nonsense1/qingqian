//
//  SearchBarViewForHomepage.m
//  frameTest
//
//  Created by 许争妍 on 16/6/28.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SearchBarViewForHomepage.h"

@implementation SearchBarViewForHomepage

- (instancetype)initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UISearchBar *searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width-50, 30)];
        
        [searchBar setSearchBarStyle:UISearchBarStyleMinimal];
        
        [searchBar setPlaceholder:@"输入商户名／搜索词"];
        
        [self addSubview:searchBar];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame=CGRectMake(searchBar.frame.size.width+30, 0, 50, 30);
        button.titleLabel.text = @"签到";
        
        [button setImage:[UIImage imageNamed:@"iconfont-record.png"] forState:UIControlStateNormal];
        
        [self addSubview:button];
        
        [button addTarget:self action:@selector(speechSend) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}

@end
