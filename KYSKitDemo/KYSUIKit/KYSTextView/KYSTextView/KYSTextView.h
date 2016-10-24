//
//  KYSTextView.h
//  KYSTextView
//
//  Created by 康永帅 on 16/6/2.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KYSTextViewDelegate <UITextViewDelegate>

- (void)textView:(UITextView *)textView didTapAtCharactersIndex:(NSInteger)index;

@end

@interface KYSTextView : UITextView

@end
