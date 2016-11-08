//
//  KYSPickerView.h
//  flashServes
//
//  Created by Liu Zhao on 16/5/19.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KYSPickerViewDelegate;
@protocol KYSPickerViewDateDataSource;
@protocol KYSPickerViewNormalDataSource;

typedef NS_ENUM(NSInteger,KYSPickerViewType){
    KYSPickerViewNormal = 0, //普通
    KYSPickerViewDate = 1    //时间
};

@interface KYSPickerView : UIView

@property(nonatomic,weak)id<KYSPickerViewDelegate> delegate;
@property(nonatomic,weak)id<KYSPickerViewDateDataSource> dateDataSource;
@property(nonatomic,weak)id<KYSPickerViewNormalDataSource> normalDataSource;


//frame 为父视图的frame
- (instancetype)initWithFrame:(CGRect)frame type:(KYSPickerViewType)type;

- (void)KYSShow;

- (void)KYSHide;

- (void)KYSReloadData;

@end


@protocol KYSPickerViewDelegate <NSObject>

@optional
/*
 普通类型：返回对应component的数组
 时间类型：返回NSdate对象
 */
- (void)KYSPickerView:(KYSPickerView *)pickerView selectedObject:(id)object;

- (void)cancelWithPickerView:(KYSPickerView *)pickerView;

- (void)KYSPickerView:(KYSPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end

//KYSPickerViewNormal implementation
@protocol KYSPickerViewNormalDataSource <NSObject>

@required
//默认 @[]
- (NSArray *)dataSourceKYSPickerView:(KYSPickerView *)pickerView componentIndex:(NSInteger)index;

@optional
//时间pickerView无效，默认是1，可不设置
- (NSInteger)numberOfComponentsInPickerView:(KYSPickerView *)pickerView;

- (NSInteger)selectedIndexKYSPickerView:(KYSPickerView *)pickerView componentIndex:(NSInteger)index;



@end


//KYSPickerViewDate implementation
@protocol KYSPickerViewDateDataSource <NSObject>

@optional
- (NSDate *)currentDateKYSPickerView:(KYSPickerView *)pickerView;
- (NSDate *)minDateKYSPickerView:(KYSPickerView *)pickerView;
- (NSDate *)maxDateKYSPickerView:(KYSPickerView *)pickerView;

@end




/*
 {
 "status": "200",
 "data": [
 {
 "name": "安徽省",
 "data": [
 {
 "name": "合肥",
 "data": [
 {
 "name": "美国悦宝园合肥华润五彩城早教中心",
 "id": "82"
 },
 {
 "name": "美国悦宝园合肥早教中心",
 "id": "24"
 }
 ]
 }
 ]
 },
 {
 "name": "北京市",
 "data": [
 {
 "name": "昌平",
 "data": [
 {
 "name": "美国悦宝园北京昌平镇早教中心",
 "id": "117"
 },
 {
 "name": "美国悦宝园北京回龙观早教中心",
 "id": "33"
 },
 {
 "name": "美国悦宝园北京天通苑早教中心",
 "id": "43"
 }
 ]
 },
 {
 "name": "朝阳",
 "data": [
 {
 "name": "美国悦宝园北京东坝早教中心",
 "id": "69"
 },
 {
 "name": "美国悦宝园北京甘露园早教中心",
 "id": "47"
 },
 {
 "name": "美国悦宝园北京双桥早教中心",
 "id": "51"
 },
 {
 "name": "美国悦宝园北京太阳宫早教中心",
 "id": "9"
 },
 {
 "name": "美国悦宝园北京亚运村早教中心",
 "id": "32"
 }
 ]
 },
 {
 "name": "大兴",
 "data": [
 {
 "name": "美国悦宝园北京大兴城乡世纪早教中心",
 "id": "74"
 },
 {
 "name": "美国悦宝园北京大兴绿地早教中心",
 "id": "113"
 }
 ]
 },
 {
 "name": "房山",
 "data": [
 {
 "name": "美国悦宝园北京房山长阳早教中心",
 "id": "119"
 }
 ]
 },
 {
 "name": "丰台",
 "data": [
 {
 "name": "美国悦宝园北京丰台草桥上品早教中心",
 "id": "85"
 },
 {
 "name": "美国悦宝园北京丰台大成物美早教中心",
 "id": "83"
 },
 {
 "name": "美国悦宝园北京丰台京港城早教中心",
 "id": "111"
 }
 ]
 },
 {
 "name": "海淀",
 "data": [
 {
 "name": "美国悦宝园北京大钟寺早教中心",
 "id": "1"
 }
 ]
 },
 {
 "name": "怀柔",
 "data": [
 {
 "name": "美国悦宝园北京怀柔新悦百货早教中心",
 "id": "115"
 }
 ]
 },
 {
 "name": "密云",
 "data": [
 {
 "name": "美国悦宝园北京密云万象城早教中心",
 "id": "114"
 }
 ]
 },
 {
 "name": "石景山",
 "data": [
 {
 "name": "美国悦宝园北京苹果园早教中心",
 "id": "96"
 }
 ]
 },
 {
 "name": "顺义",
 "data": [
 {
 "name": "美国悦宝园北京顺义早教中心",
 "id": "46"
 }
 ]
 },
 {
 "name": "通州",
 "data": [
 {
 "name": "美国悦宝园北京通州北苑早教中心",
 "id": "108"
 }
 ]
 }
 ]
 },
 {
 "name": "福建省",
 "data": [
 {
 "name": "福州",
 "data": [
 {
 "name": "美国悦宝园福州爱琴海早教中心",
 "id": "79"
 },
 {
 "name": "美国悦宝园福州新华商场早教中心",
 "id": "38"
 }
 ]
 },
 {
 "name": "厦门",
 "data": [
 {
 "name": "美国悦宝园厦门早教中心",
 "id": "10"
 }
 ]
 }
 ]
 },
 {
 "name": "甘肃省",
 "data": [
 {
 "name": "兰州",
 "data": [
 {
 "name": "美国悦宝园兰州港联早教中心",
 "id": "65"
 }
 ]
 }
 ]
 },
 {
 "name": "广东省",
 "data": [
 {
 "name": "佛山",
 "data": [
 {
 "name": "美国悦宝园佛山禅城早教中心",
 "id": "61"
 },
 {
 "name": "美国悦宝园佛山南海早教中心",
 "id": "28"
 }
 ]
 },
 {
 "name": "广州",
 "data": [
 {
 "name": "美国悦宝园广州番禺早教中心",
 "id": "34"
 },
 {
 "name": "美国悦宝园广州越秀早教中心",
 "id": "41"
 }
 ]
 },
 {
 "name": "惠州",
 "data": [
 {
 "name": "美国悦宝园广东惠州早教中心",
 "id": "67"
 }
 ]
 },
 {
 "name": "深圳",
 "data": [
 {
 "name": "美国悦宝园深圳早教中心",
 "id": "35"
 }
 ]
 }
 ]
 },
 {
 "name": "贵州省",
 "data": [
 {
 "name": "贵阳",
 "data": [
 {
 "name": "美国悦宝园贵阳早教中心",
 "id": "64"
 },
 {
 "name": "美国悦宝园贵州贵阳万科早教中心",
 "id": "129"
 }
 ]
 }
 ]
 },
 {
 "name": "海南省",
 "data": [
 {
 "name": "海口",
 "data": [
 {
 "name": "美国悦宝园海南海口早教中心",
 "id": "42"
 }
 ]
 }
 ]
 },
 {
 "name": "河北省",
 "data": [
 {
 "name": "保定",
 "data": [
 {
 "name": "美国悦宝园河北保定早教中心",
 "id": "55"
 }
 ]
 },
 {
 "name": "沧州",
 "data": [
 {
 "name": "美国悦宝园河北沧州黄骅早教中心",
 "id": "92"
 }
 ]
 },
 {
 "name": "邯郸",
 "data": [
 {
 "name": "美国悦宝园河北邯郸富玛特早教中心",
 "id": "77"
 }
 ]
 },
 {
 "name": "廊坊",
 "data": [
 {
 "name": "美国悦宝园河北燕郊早教中心",
 "id": "94"
 },
 {
 "name": "美国悦宝园廊坊早教中心",
 "id": "53"
 }
 ]
 },
 {
 "name": "石家庄",
 "data": [
 {
 "name": "美国悦宝园石家庄万达早教中心",
 "id": "73"
 }
 ]
 },
 {
 "name": "唐山",
 "data": [
 {
 "name": "美国悦宝园河北唐山早教中心",
 "id": "103"
 }
 ]
 },
 {
 "name": "张家口",
 "data": [
 {
 "name": "美国悦宝园河北张家口早教中心",
 "id": "70"
 }
 ]
 }
 ]
 },
 {
 "name": "河南省",
 "data": [
 {
 "name": "濮阳",
 "data": [
 {
 "name": "美国悦宝园河南濮阳早教中心",
 "id": "75"
 }
 ]
 },
 {
 "name": "郑州",
 "data": [
 {
 "name": "美国悦宝园河南郑州大商新玛特中原中心",
 "id": "89"
 },
 {
 "name": "美国悦宝园河南郑州惠济万达早教中心",
 "id": "110"
 }
 ]
 }
 ]
 },
 {
 "name": "黑龙江省",
 "data": [
 {
 "name": "大庆",
 "data": [
 {
 "name": "美国悦宝园黑龙江大庆早教中心",
 "id": "57"
 }
 ]
 },
 {
 "name": "哈尔滨",
 "data": [
 {
 "name": "美国悦宝园哈尔滨爱建早教中心",
 "id": "8"
 }
 ]
 },
 {
 "name": "齐齐哈尔",
 "data": [
 {
 "name": "美国悦宝园黑龙江齐齐哈尔早教中心",
 "id": "71"
 }
 ]
 }
 ]
 },
 {
 "name": "湖南省",
 "data": [
 {
 "name": "衡阳",
 "data": [
 {
 "name": "美国悦宝园湖南衡阳泰宇盛世明都早教中心",
 "id": "120"
 }
 ]
 }
 ]
 },
 {
 "name": "吉林省",
 "data": [
 {
 "name": "长春",
 "data": [
 {
 "name": "美国悦宝园吉林长春早教中心",
 "id": "97"
 }
 ]
 }
 ]
 },
 {
 "name": "江苏省",
 "data": [
 {
 "name": "南通",
 "data": [
 {
 "name": "美国悦宝园江苏南通早教中心",
 "id": "98"
 }
 ]
 },
 {
 "name": "苏州",
 "data": [
 {
 "name": "美国悦宝园江苏常熟裕坤美城早教中心",
 "id": "107"
 },
 {
 "name": "美国悦宝园苏州相城早教中心",
 "id": "72"
 },
 {
 "name": "美国悦宝园苏州园区早教中心",
 "id": "50"
 },
 {
 "name": "美国悦宝园张家港早教中心",
 "id": "20"
 }
 ]
 },
 {
 "name": "泰州",
 "data": [
 {
 "name": "美国悦宝园江苏泰州万达早教中心",
 "id": "112"
 }
 ]
 },
 {
 "name": "无锡",
 "data": [
 {
 "name": "美国悦宝园江苏无锡早教中心",
 "id": "93"
 }
 ]
 }
 ]
 },
 {
 "name": "江西省",
 "data": [
 {
 "name": "南昌市",
 "data": [
 {
 "name": "美国悦宝园江西南昌红谷滩早教中心",
 "id": "118"
 }
 ]
 }
 ]
 },
 {
 "name": "辽宁省",
 "data": [
 {
 "name": "鞍山",
 "data": [
 {
 "name": "美国悦宝园辽宁鞍山早教中心",
 "id": "59"
 }
 ]
 },
 {
 "name": "大连",
 "data": [
 {
 "name": "美国悦宝园大连早教中心",
 "id": "58"
 }
 ]
 }
 ]
 },
 {
 "name": "内蒙古自治区",
 "data": [
 {
 "name": "包头",
 "data": [
 {
 "name": "美国悦宝园内蒙包头七巧国早教中心",
 "id": "126"
 }
 ]
 },
 {
 "name": "呼和浩特",
 "data": [
 {
 "name": "美国悦宝园呼和浩特赛罕早教中心",
 "id": "30"
 },
 {
 "name": "美国悦宝园呼和浩特新城早教中心",
 "id": "56"
 }
 ]
 }
 ]
 },
 {
 "name": "青海省",
 "data": [
 {
 "name": "西宁",
 "data": [
 {
 "name": "美国悦宝园青海西宁早教中心",
 "id": "91"
 }
 ]
 }
 ]
 },
 {
 "name": "山东省",
 "data": [
 {
 "name": "东营",
 "data": [
 {
 "name": "美国悦宝园山东东营早教中心",
 "id": "102"
 }
 ]
 },
 {
 "name": "济南",
 "data": [
 {
 "name": "美国悦宝园济南浆水泉早教中心",
 "id": "18"
 }
 ]
 },
 {
 "name": "济宁",
 "data": [
 {
 "name": "美国悦宝园山东济宁太白国际早教中心",
 "id": "86"
 }
 ]
 },
 {
 "name": "青岛",
 "data": [
 {
 "name": "美国悦宝园青岛李沧早教中心",
 "id": "84"
 },
 {
 "name": "美国悦宝园青岛早教中心",
 "id": "29"
 },
 {
 "name": "美国悦宝园山东青岛崂山大拇指早教中心",
 "id": "128"
 }
 ]
 },
 {
 "name": "泰安",
 "data": [
 {
 "name": "美国悦宝园山东泰安万达早教中心",
 "id": "127"
 }
 ]
 },
 {
 "name": "潍坊",
 "data": [
 {
 "name": "美国悦宝园山东潍坊早教中心",
 "id": "27"
 }
 ]
 },
 {
 "name": "淄博",
 "data": [
 {
 "name": "美国悦宝园山东淄博早教中心",
 "id": "48"
 }
 ]
 }
 ]
 },
 {
 "name": "山西省",
 "data": [
 {
 "name": "大同",
 "data": [
 {
 "name": "美国悦宝园大同早教中心",
 "id": "36"
 }
 ]
 },
 {
 "name": "太原",
 "data": [
 {
 "name": "美国悦宝园山西太原早教中心",
 "id": "23"
 }
 ]
 }
 ]
 },
 {
 "name": "陕西省",
 "data": [
 {
 "name": "西安",
 "data": [
 {
 "name": "美国悦宝园西安高新早教中心",
 "id": "26"
 },
 {
 "name": "美国悦宝园西安未央早教中心",
 "id": "44"
 }
 ]
 },
 {
 "name": "榆林",
 "data": [
 {
 "name": "美国悦宝园陕西神木早教中心",
 "id": "39"
 }
 ]
 }
 ]
 },
 {
 "name": "上海市",
 "data": [
 {
 "name": "宝山",
 "data": [
 {
 "name": "美国悦宝园上海宝山淞南早教中心",
 "id": "131"
 }
 ]
 },
 {
 "name": "北外滩",
 "data": [
 {
 "name": "美国悦宝园上海北外滩早教中心",
 "id": "40"
 }
 ]
 },
 {
 "name": "长宁",
 "data": [
 {
 "name": "美国悦宝园上海缤谷早教中心",
 "id": "88"
 }
 ]
 },
 {
 "name": "闵行",
 "data": [
 {
 "name": "美国悦宝园上海闵行七宝早教中心",
 "id": "105"
 },
 {
 "name": "美国悦宝园上海新荟城早教中心",
 "id": "130"
 }
 ]
 },
 {
 "name": "浦东",
 "data": [
 {
 "name": "美国悦宝园上海周浦绿地缤纷广场早教中心",
 "id": "125"
 }
 ]
 },
 {
 "name": "闸北",
 "data": [
 {
 "name": "美国悦宝园上海静安大宁早教中心",
 "id": "124"
 }
 ]
 }
 ]
 },
 {
 "name": "四川省",
 "data": [
 {
 "name": "成都",
 "data": [
 {
 "name": "美国悦宝园成都成华万科魔方街早教中心",
 "id": "121"
 },
 {
 "name": "美国悦宝园成都龙湖北城早教中心",
 "id": "122"
 },
 {
 "name": "美国悦宝园成都青羊早教中心",
 "id": "63"
 },
 {
 "name": "美国悦宝园成都武侯早教中心",
 "id": "13"
 },
 {
 "name": "星河悦宝园",
 "id": "90"
 }
 ]
 },
 {
 "name": "德阳",
 "data": [
 {
 "name": "美国悦宝园四川德阳早教中心",
 "id": "49"
 }
 ]
 }
 ]
 },
 {
 "name": "天津市",
 "data": [
 {
 "name": "河北",
 "data": [
 {
 "name": "美国悦宝园天津河北北宁湾早教中心",
 "id": "116"
 }
 ]
 },
 {
 "name": "河东",
 "data": [
 {
 "name": "美国悦宝园天津爱琴海早教中心",
 "id": "78"
 }
 ]
 },
 {
 "name": "塘沽",
 "data": [
 {
 "name": "美国悦宝园天津滨海早教中心",
 "id": "62"
 }
 ]
 }
 ]
 },
 {
 "name": "云南省",
 "data": [
 {
 "name": "昆明",
 "data": [
 {
 "name": "美国悦宝园昆明北市早教中心",
 "id": "60"
 },
 {
 "name": "美国悦宝园昆明云都国际早教中心",
 "id": "100"
 }
 ]
 }
 ]
 },
 {
 "name": "浙江省",
 "data": [
 {
 "name": "杭州",
 "data": [
 {
 "name": "美国悦宝园杭州丰元国际早教中心",
 "id": "52"
 },
 {
 "name": "美国悦宝园杭州江干区凤起早教中心",
 "id": "104"
 },
 {
 "name": "美国悦宝园杭州金沙天街早教中心",
 "id": "80"
 },
 {
 "name": "美国悦宝园杭州萧山早教中心",
 "id": "101"
 },
 {
 "name": "美国悦宝园杭州中赢国际早教中心",
 "id": "87"
 }
 ]
 },
 {
 "name": "宁波",
 "data": [
 {
 "name": "美国悦宝园浙江宁波文化广场早教中心",
 "id": "106"
 },
 {
 "name": "美国悦宝园浙江宁波余姚早教中心",
 "id": "95"
 }
 ]
 }
 ]
 },
 {
 "name": "重庆市",
 "data": [
 {
 "name": "万州",
 "data": [
 {
 "name": "美国悦宝园重庆万州万达广场早教中心",
 "id": "123"
 }
 ]
 }
 ]
 }
 ],
 "time": "1478592080"
 }
 
 */








