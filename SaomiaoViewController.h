//
//  SaomiaoViewController.h
//  frameTest
//
//  Created by 蔡晓宇 on 16/7/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaomiaoViewController : UIViewController{
    
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}
@property (nonatomic, retain) UIImageView * line;
@end
