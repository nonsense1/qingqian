//
//  BusinessModel.h
//  frameTest
//
//  Created by 蔡晓宇 on 16/6/28.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessModel : NSObject

@property (nonatomic,copy) NSString *addr;
@property (nonatomic,copy) NSString *shop_name;
@property (nonatomic,copy) NSString *contact;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *logo;
@property (nonatomic,copy) NSString *photo;
@property (nonatomic,copy) NSString *d;
@property (nonatomic,copy) NSString *tags;
@property (nonatomic,assign) NSInteger score;
@property (nonatomic,copy) NSString *score_num;
@property(nonatomic,copy)NSString *shop_id;

@end
