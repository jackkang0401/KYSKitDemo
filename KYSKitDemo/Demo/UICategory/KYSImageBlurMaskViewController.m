//
//  KYSImageBlurMaskViewController.m
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/2/24.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSImageBlurMaskViewController.h"
#import "UIImage+KYSAddition.h"

@interface KYSImageBlurMaskViewController()

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UISlider *blurSlider;
@property(nonatomic,strong)UISlider *saturationSlider;
@property(nonatomic,strong)UISlider *maskSlider;

@end


@implementation KYSImageBlurMaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"图片毛玻璃，水印处理";
    
    self.view.backgroundColor=[UIColor whiteColor];

    
    _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-75, 80, 150, 150)];
    _imageView.image=[[UIImage imageNamed:@"blurmask"] imageBySoft];
    //_imageView.image=[[UIImage imageNamed:@"mask"] imageByBlurSoft];
    [self.view addSubview:_imageView];
    
    
    //毛玻璃
    UILabel *blurlabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-100-65, 80+150+10, 65, 30)];
    blurlabel.text=@"毛玻璃:";
    blurlabel.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:blurlabel];
    
    _blurSlider=[[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-100, 80+150+10, 200, 30)];
    //blurSlider.backgroundColor=[UIColor blueColor];
    _blurSlider.minimumValue=0.0;
    _blurSlider.maximumValue=100.0;
    [_blurSlider addTarget:self action:@selector(blurValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_blurSlider];
    
    UILabel *blurValuelabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_blurSlider.frame)+200, 80+150+10, 65, 30)];
    blurValuelabel.tag=1001;
    blurValuelabel.textAlignment=NSTextAlignmentLeft;
    blurValuelabel.text=@"0.00";
    [self.view addSubview:blurValuelabel];
    
    
    //饱和度
    UILabel *saturationlabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-100-65, 80+150+10+30, 65, 30)];
    saturationlabel.text=@"饱和度:";
    saturationlabel.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:saturationlabel];
    
    _saturationSlider=[[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-100, 80+150+10+30, 200, 30)];
    //saturationSlider.backgroundColor=[UIColor blueColor];
    _saturationSlider.minimumValue=-2.0;
    _saturationSlider.maximumValue=4.0;
    _saturationSlider.value=1.0;
    [_saturationSlider addTarget:self action:@selector(saturationValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_saturationSlider];
    
    UILabel *saturationValuelabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_saturationSlider.frame)+200, 80+150+10+30, 65, 30)];
    saturationValuelabel.tag=1002;
    saturationValuelabel.textAlignment=NSTextAlignmentLeft;
    saturationValuelabel.text=@"1.00";
    [self.view addSubview:saturationValuelabel];
    
    
    //水印
//    UILabel *masklabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-100-65, 80+150+10+30*2, 65, 30)];
//    masklabel.text=@"水印:";
//    masklabel.textAlignment=NSTextAlignmentRight;
//    [self.view addSubview:masklabel];
//    
//    _maskSlider=[[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-100, 80+150+10+30*2, 200, 30)];
//    //maskSlider.backgroundColor=[UIColor blueColor];
//    _maskSlider.minimumValue=0.0;
//    _maskSlider.maximumValue=1.0;
//    [_maskSlider addTarget:self action:@selector(maskValueChange:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:_maskSlider];
//    
//    UILabel *maskValuelabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_maskSlider.frame)+200, 80+150+10+30*2, 65, 30)];
//    maskValuelabel.tag=1003;
//    maskValuelabel.textAlignment=NSTextAlignmentLeft;
//    maskValuelabel.text=@"0.00";
//    [self.view addSubview:maskValuelabel];
    
    UIButton *startBtn=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-70, 80+150+10+30*3, 140, 30)];
    startBtn.backgroundColor=[UIColor blueColor];
    [startBtn setTitle:@"生成mask图片" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(maskAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
//    UIButton *stopBtn=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-50, 80+150+10+30*4, 100, 30)];
//    stopBtn.backgroundColor=[UIColor redColor];
//    [stopBtn setTitle:@"停止定时器" forState:UIControlStateNormal];
//    [startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [stopBtn addTarget:self action:@selector(tintAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:stopBtn];
}

- (void)blurValueChange:(UISlider *)slider{
    NSLog(@"%f",slider.value);
    UILabel *blurValuelabel = [self.view viewWithTag:1001];
    blurValuelabel.text=[NSString stringWithFormat:@"%.2f",slider.value];
    UIImage *image=[UIImage imageNamed:@"blurmask"];
    _imageView.image = [image imageByBlurRadius:_blurSlider.value saturation:1];
}

- (void)saturationValueChange:(UISlider *)slider{
    NSLog(@"%f",slider.value);
    UILabel *saturationValuelabel = [self.view viewWithTag:1002];
    saturationValuelabel.text=[NSString stringWithFormat:@"%.2f",slider.value];
    UIImage *image=[UIImage imageNamed:@"blurmask"];
    _imageView.image = [image imageByBlurRadius:_blurSlider.value saturation:_saturationSlider.value];
}

- (void)maskAction{
    UIImage *maskImage=[UIImage imageNamed:@"mask"];
    //填充mask利用mask不透明部分创建纯色图片
    _imageView.image = [UIImage imageWithColor:[UIColor blueColor] tintBlendMode:kCGBlendModeNormal maskImage:maskImage];
}

- (void)tintAction{
    //UIImage *image=[UIImage imageNamed:@"blurmask"];
    //UIImage *maskImage=[UIImage imageNamed:@"mask"];

}

@end
