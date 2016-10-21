//
//  QTXDataUtils.h
//  qiutianxia
//
//  Created by willbin on 14-1-6.
//  Copyright (c) 2014年 QTX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "NSDictionary+NullReplacement.h"
//#import "NSArray+NullReplacement.h"


// 本类是一些常见小功能的集合

#define kBaseListCellHeight  (415+5+13)

@interface QTXDataUtils : NSObject


#pragma mark - MD5

+ (NSString *)MD5HashFromString:(NSString *)sorStr;

#pragma mark -　日期相关
// 根据日期返回NSDate对象(日期格式: 2014-01-02 03:22:10)
+ (NSDate *)getNSDateFromString:(NSString *)dateStr;

// 根据日期表示返回中文的（周二 12月6日）(日期格式: 2014-01-02 03:22:10)
+ (NSString *)getChineseWeekdayWithDateString:(NSString *)dateStr;

// 根据日期返回时间表示 19:30 (日期格式: 2014-01-02 03:22:10)
+ (NSString *)getTimeStrWithString:(NSString *)dateStr;

// 根据日期返回时间表示,以标准形式定义 (日期格式: 2014-01-02 03:22:10)
+ (NSString *)getTimeStrWithString:(NSString *)dateStr FormatterStr:(NSString *)fStr;

//返回时间所在日期当天的准确时间. (20:19)
+ (NSString *)smallTimewithTimeStr:(NSString *)dateStr;

//判断两个日期是否是同一天
+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2;

// 根据日期返回时间表示 今天time,昨天,前天, 日期 (日期格式: 2014-01-02 03:22:10)
+ (NSString *)getCommentTimeStrWithString:(NSString *)dateStr;

//返回时间所在日期当天的准确时间（2014/06/09） (日期格式: 2014-01-02 03:22)
+ (NSString *)dateWithTimeStr:(NSString *)dateStr;

// 根据日期返回时间表示 "日" (日期格式: 2014-01-02 03:22)
+ (NSString *)getDayStrWithString:(NSString *)dateStr;

// 根据日期返回时间表示 "月:6月" (日期格式: 2014-01-02 03:22)
+ (NSString *)getMonthStrWithString:(NSString *)dateStr;

// 根据日期返回时间表示 "年:2014" (日期格式: 2014-01-02 03:22)
+ (NSString *)getYearStrWithString:(NSString *)dateStr;

// 根据日期返回时间表示 "7-9 06:09" (日期格式: 2014-01-02 03:22)
+ (NSString *)getMonthAndDayWithDateString:(NSString *)dateStr;

// 根据日期Date 返回一个时间字符串
+ (NSString *)getStringFromNowDate;
+ (NSString *)getStringFromDstDate:(NSDate *)dstDate;

// 根据当前时间返回NSString对象(yyyyMMddhhmmss)
+ (NSString *)getTimeStringForNow;


// 根据指定时间返回日差
+ (NSInteger)daysFromDate:(NSDate *)destDate;

// 根据时间字典返回NSString对象()
+ (NSString *)getDateShowStringWithTimeDict:(NSDictionary *)timeDict;

// 今天 09月30日  昨天 09月29日  星期日 08月30日
+ (NSString *)getSimpleDateShowStringWithTimeDict:(NSDictionary *)timeDict;

//  23:25 08-25
+ (NSString *)getDetailDateShowStringWithTimeDict:(NSDictionary *)timeDict;

// 10.25 14:45
+ (NSString *)getDetailDateShowStringWithIntervalStr:(NSString *)intervalStr;

// 12月20日 星期二
+ (NSString *)getVideoDateShowStringWithIntervalStr:(NSString *)intervalStr;


#pragma mark -　其他

// 判断 是否是ip地址
+ (BOOL)validateIPAddress:(NSString *)ipStr;

// 判断 是否是email
+ (BOOL)validateEmail:(NSString *)emailStr;

// 简单判断email, 只判断包含 @, 其他规则由服务器来制定
+ (BOOL)simpleValidateEmail:(NSString *)emailStr;

// 根据图片地址添加上带有大小的字符串 （例如后面加上）
+ (NSURL *)getImageStrWithImageUrlStr:(NSString *)ImageUrlStr width:(NSString *)width height:(NSString *)height;

// 用微博的计数方法来返回字数 测试与新浪腾讯微博网页端一致
+ (int)sinaCountWordForString:(NSString*)str;

// 用微博的计数方法从源字符串中返回对应数量的字符串
+ (NSString *)getSinaCountStringWithContent:(NSString *)contentStr count:(NSInteger)count;

// 根据字符串返回性别表示
+ (NSString *)getGenderDisplayStringWithString:(NSString *)sorStr;

+ (NSString *)getGenderIntStringWithDisplayString:(NSString *)sorStr;

#pragma mark - 数据解析

// 判断对象是否是正常的数据, 如果不是正常的, 有可能为 nsdictionary, nsarry.
+ (BOOL)isValidObject:(id)ufObject;

//+ (BOOL)isValidObject:(id)ufObject;

#pragma mark -  延时执行

+ (void)doSomething:(void (^)(void))functions
     afterDelayTime:(double)delayInSeconds;

//默认 0.8秒
+ (void)doSomethingLater:(void (^)(void))functions;


#pragma mark - 主线程与子线程执行

+ (void)doSomethingOnSubThread:(void (^)(void))functions;

+ (void)doSomethingOnMainThread:(void (^)(void))functions;


#pragma mark - image

+ (UIImage *)imageWithImgFileName:(NSString *)imgName;

+ (UIImage *)imageWithImgFileName:(NSString *)imgName
                           ofType:(NSString *)typeStr;

#pragma mark - view转化为image

+ (UIImage *)captureScrollView:(UIScrollView *)scrollView;

// 高清屏幕不失真
//http://stackoverflow.com/questions/4334233/how-to-capture-uiview-to-uiimage-without-loss-of-quality-on-retina-display

// 这个速度更快  比 renderInContext  这个返回的大小
+ (UIImage *)newImageWithView:(UIView *)view;   // ios7以后

//  renderInContext方法
+ (UIImage *)oldWayImageWithView:(UIView *)view;   // iphone4用


// new
// http://stackoverflow.com/questions/11104042/how-to-get-a-rotated-zoomed-and-panned-image-from-an-uiimageview-at-its-full-re?lq=1
+ (UIImage *)captureView:(UIImageView *)faceImageView andSubview:(UIView *)enclosingView;


//#pragma mark - 处理数据
//
//+ (NSDictionary *)getProperDictWithData:(NSData *)jsonData;

@end
