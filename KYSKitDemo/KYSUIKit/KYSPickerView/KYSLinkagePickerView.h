//
//  KYSLinkagePickerView.h
//  KYSKitDemo
//
//  Created by 康永帅 on 2016/11/8.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NSArray* (^KYSLinkagePickerViewAnalyzeOriginData)(NSArray*);

@interface KYSLinkagePickerView : UIView

- (void)setDataWithArray:(NSArray *) originArray analyzeBlock:(KYSLinkagePickerViewAnalyzeOriginData) block;


- (void)KYSShow;

- (void)KYSHide;

- (void)KYSReloadData;


@end

/*
{
    "data" : [
              {
                  "data" : [
                            {
                                "data" : [
                                          {
                                              "id" : "60",
                                              "name" : "美国悦宝园昆明北市早教中心"
                                          },
                                          {
                                              "id" : "100",
                                              "name" : "美国悦宝园昆明云都国际早教中心"
                                          }
                                          ],
                                "name" : "昆明"
                            }
                            ],
                  "name" : "云南省"
              },
              {
                  "data" : [
                            {
                                "data" : [
                                          {
                                              "id" : "52",
                                              "name" : "美国悦宝园杭州丰元国际早教中心"
                                          },
                                          {
                                              "id" : "104",
                                              "name" : "美国悦宝园杭州江干区凤起早教中心"
                                          },
                                          {
                                              "id" : "80",
                                              "name" : "美国悦宝园杭州金沙天街早教中心"
                                          },
                                          {
                                              "id" : "101",
                                              "name" : "美国悦宝园杭州萧山早教中心"
                                          },
                                          {
                                              "id" : "87",
                                              "name" : "美国悦宝园杭州中赢国际早教中心"
                                          }
                                          ],
                                "name" : "杭州"
                            },
                            {
                                "data" : [
                                          {
                                              "id" : "106",
                                              "name" : "美国悦宝园浙江宁波文化广场早教中心"
                                          },
                                          {
                                              "id" : "95",
                                              "name" : "美国悦宝园浙江宁波余姚早教中心"
                                          }
                                          ],
                                "name" : "宁波"
                            }
                            ],
                  "name" : "浙江省"
              },
              {
                  "data" : [
                            {
                                "data" : [
                                          {
                                              "id" : "123",
                                              "name" : "美国悦宝园重庆万州万达广场早教中心"
                                          }
                                          ],
                                "name" : "万州"
                            }
                            ],
                  "name" : "重庆市"
              }
              ]
}

*/
