//
//  KYSChoicePhoto.h
//  KYSChoicePhoto
//
//  Created by Liu Zhao on 2016/10/24.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 iOS 10 权限配置：
    Privacy - Camera Usage Description          :访问相机
    Privacy - Photo Library Usage Description   :访问相册
 */


/*
 image:保存的图片
 error:错误信息
 isSuccess:是否成功
 */
typedef void(^KYSSaveImageBlock)(UIImage *image,NSError *error,BOOL isSuccess);

typedef void(^KYSChoiceImageBlock)(UIImage *image,BOOL isEditingImage);


@interface KYSChoicePhoto : NSObject

@property (nonatomic,assign)BOOL allowsEditing;

+ (instancetype)sharedChoicePhoto;

//保存图片到相册
- (void)saveImageToPhotos:(UIImage *)image completeBlock:(KYSSaveImageBlock)completeBlock;

//拍摄或选择照片
- (void)showPhotoChoicesWith:(KYSChoiceImageBlock)choiceBlock;

@end
