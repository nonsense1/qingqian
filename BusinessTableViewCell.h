//
//  BusinessTableViewCell.h
//  frameTest
//
//  Created by 许争妍 on 16/6/27.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *businessImage;

@property (weak, nonatomic) IBOutlet UIImageView *starImage;
@property (weak, nonatomic) IBOutlet UILabel *businessName;
@property (weak, nonatomic) IBOutlet UILabel *comments;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIButton *call;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (nonatomic,assign)NSString * shop_id;
-(void)makeACall;
@end
