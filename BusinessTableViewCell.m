//
//  BusinessTableViewCell.m
//  frameTest
//
//  Created by 许争妍 on 16/6/27.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BusinessTableViewCell.h"

@implementation BusinessTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)makeACall{
    UIWebView* callWebView = [[UIWebView alloc]init];
    NSURL *telURL = [NSURL URLWithString:@"tel:18806312161"];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.contentView addSubview:callWebView];
}
@end
