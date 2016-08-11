//
//  SaomiaoViewController.m
//  frameTest
//
//  Created by 蔡晓宇 on 16/7/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SaomiaoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "erweimaViewController.h"
#define Height [UIScreen mainScreen].bounds.size.height
#define Width [UIScreen mainScreen].bounds.size.width
#define XCenter self.view.center.x
#define YCenter self.view.center.y

#define SHeight 20

#define SWidth (XCenter+30)
@interface SaomiaoViewController() <AVCaptureMetadataOutputObjectsDelegate>{
      AVCaptureSession * session;//输入输出的中间桥梁
     UIImageView * imageView;
}
@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@end


@implementation SaomiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 }

-(void)viewWillAppear:(BOOL)animated{
    // 1. 实例化拍摄设备
    
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake((Width-SWidth)/2,(Height-SWidth)/2+SWidth-30,SWidth,SWidth)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码放入即可自动扫描";
    labIntroudction.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:labIntroudction];

    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake((Width-SWidth)/2,(Height-SWidth)/2,SWidth,SWidth)];
    imageView.image = [UIImage imageNamed:@"scanscanBg.png"];
    [self.view addSubview:imageView];
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame)+5, CGRectGetMinY(imageView.frame)+5, SWidth-10,1)];
    _line.image = [UIImage imageNamed:@"scanLine.jpg"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];

    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2. 设置输入设备
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    if (input ==nil) {
        [self showMessage:@"无扫描设备"];
       
        
    }else{
         input.accessibilityFrame =CGRectMake((Width-SWidth)/2,(Height-SWidth)/2,SWidth,SWidth);
        // 3. 设置元数据输出
        
        // 3.1 实例化拍摄元数据输出
        
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        
        // 3.3 设置输出数据代理
        
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        
          [output setRectOfInterest:CGRectMake((200)/Height,((Width-220)/2)/Width,220/Height,220/Width)];
        // 4. 添加拍摄会话
        
        // 4.1 实例化拍摄会话
        
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        
        // 4.2 添加会话输入
        
        [session addInput:input];
        
        // 4.3 添加会话输出
        
        [session addOutput:output];
        
        // 4.3 设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
        
        [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        
        self.session = session;
        
        // 5. 视频预览图层
        
        // 5.1 实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
        
        AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        
        preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
            preview.frame = self.view.bounds;

        
        [self.view.layer insertSublayer:preview atIndex:0];
        
        self.previewLayer = preview;
      
         [self setOverView];
        // 6. 启动会话
        
        [_session startRunning];
        
        
    }
    
    

}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(CGRectGetMinX(imageView.frame)+5, CGRectGetMinY(imageView.frame)+5+2*num, SWidth-10,1);
        
        if (num ==(int)(( SWidth-10)/2)) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame =CGRectMake(CGRectGetMinX(imageView.frame)+5, CGRectGetMinY(imageView.frame)+5+2*num, SWidth-10,1);
        
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
  
    // 会频繁的扫描，调用代理方法
    
    // 1. 如果扫描完成，停止会话
    
    [self.session stopRunning];
 
    // 2. 删除预览图层
    
    [self.previewLayer removeFromSuperlayer];
     [self.line removeFromSuperview];
    NSLog(@"%@", metadataObjects);
    
    // 3. 设置界面显示扫描结果
    
    if (metadataObjects.count > 0)
        
    {
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        // 提示：如果需要对url或者名片等信息进行扫描，可以在此进行扩展！
        
        NSLog(@"%@", obj.stringValue);
        
        erweimaViewController *erweima = [[erweimaViewController alloc]init];
        erweima.erweima =obj.stringValue;
        [self.navigationController pushViewController:erweima animated:YES];
        
    }
//      metadataObjects = [NSArray array];
    
}


-(void)showMessage:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
    
    
}

#pragma mark - 添加模糊效果
- (void)setOverView {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    CGFloat x = CGRectGetMinX(imageView.frame);
    CGFloat y = CGRectGetMinY(imageView.frame);
    CGFloat w = CGRectGetWidth(imageView.frame);
    CGFloat h = CGRectGetHeight(imageView.frame);
    
    [self creatView:CGRectMake(0, 0, width, y)];
    [self creatView:CGRectMake(0, y, x, h)];
    [self creatView:CGRectMake(0, y + h, width, height - y - h)];
    [self creatView:CGRectMake(x + w, y, width - x - w, h)];
}

- (void)creatView:(CGRect)rect {
    CGFloat alpha = 0.5;
    UIColor *backColor = [UIColor blackColor];
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backColor;
    view.alpha = alpha;
    [self.view addSubview:view];
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
