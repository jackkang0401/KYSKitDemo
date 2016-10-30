//
//  KYSChoicePhoto.m
//  KYSChoicePhoto
//
//  Created by Liu Zhao on 2016/10/24.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import "KYSChoicePhoto.h"
#import "AppDelegate.h"

@interface KYSChoicePhoto()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@property (nonatomic, copy)KYSSaveImageBlock saveCompleteBlock;
@property (nonatomic, copy)KYSChoiceImageBlock choiceImageBlock;

@property (nonatomic, weak)UIWindow *window;
@property (nonatomic, strong)UIActionSheet *sheet;
@property (nonatomic, strong)UIImagePickerController *pickerController;


@end


@implementation KYSChoicePhoto


+ (instancetype)sharedChoicePhoto{
    static KYSChoicePhoto *shared=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared=[[KYSChoicePhoto alloc] init];
    });
    return shared;
}

- (instancetype)init {
    if (self = [super init]) {
        self.allowsEditing = YES;
    }
    return self;
}

- (void)dealloc{
    self.saveCompleteBlock=nil;
    self.choiceImageBlock=nil;
}

#pragma mark - public
//保存图片到相册
- (void)saveImageToPhotos:(UIImage *)image completeBlock:(KYSSaveImageBlock)completeBlock
{
    self.saveCompleteBlock=completeBlock;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if (self.saveCompleteBlock) {
        self.saveCompleteBlock(image,error,NULL==error);
    }
}

//拍摄或选择照片
- (void)showPhotoChoicesWith:(KYSChoiceImageBlock)choiceBlock {
    self.sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择照片",@"拍照" ,nil];
    self.choiceImageBlock = choiceBlock;
    self.pickerController.allowsEditing=self.allowsEditing;
    [self.sheet showInView:self.window];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerControllerSourceType sourceType ;
    
    if (buttonIndex == 2) { // 取消
        return;
    }
    
    if (buttonIndex == 1) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }else {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    //初始化
    self.pickerController.delegate = self;
    _pickerController.sourceType = sourceType;
    [self.window.rootViewController presentViewController:_pickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *imageKey=@"UIImagePickerControllerOriginalImage";
    if (self.allowsEditing) {
        imageKey = @"UIImagePickerControllerEditedImage";
    }
    if (self.choiceImageBlock) {
        self.choiceImageBlock(info[imageKey],self.allowsEditing);
    }
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    _pickerController = nil;
}

// 点击cancel 调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - lazy load

- (UIWindow *)window{
    if (!_window) {
        AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
        _window=delegate.window;
    }
    return _window;
}

- (UIImagePickerController *)pickerController {
    if (!_pickerController) {
        _pickerController = [[UIImagePickerController alloc] init];
    }
    return _pickerController;
    
}



@end
