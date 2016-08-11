//
//  SearchBarView.m
//  frameTest
//
//  Created by 许争妍 on 16/6/28.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SearchBarView.h"

@implementation SearchBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UISearchBar *searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(10, 0, frame.size.width-100, 30)];
        
        [searchBar setSearchBarStyle:UISearchBarStyleMinimal];
        
        [searchBar setPlaceholder:@"输入商户名／品名／商品名"];
        
        [self addSubview:searchBar];
        
        
    }
        
       
        
    
    
    return self;
    
}
@end

