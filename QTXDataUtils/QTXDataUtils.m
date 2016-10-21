//
//  QTXDataUtils.m
//  qiutianxia
//
//  Created by willbin on 14-1-6.
//  Copyright (c) 2014年 QTX. All rights reserved.
//

#import "QTXDataUtils.h"

#import <CommonCrypto/CommonDigest.h>

@implementation QTXDataUtils

#pragma mark - MD5

+ (NSString *)MD5HashFromString:(NSString *)sorStr
{
    if(sorStr.length == 0) {
        return nil;
    }
    
    const char *cStr = [sorStr UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}

#pragma mark - Date 相关

+ (NSString *)getStringFromNowDate
{
    return [self getStringFromDstDate:[NSDate date]];
}

+ (NSString *)getStringFromDstDate:(NSDate *)dstDate
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];   //实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // 设置日期格式
    
    NSString *destString = [dateFormat stringFromDate:dstDate];
    return destString;
}

+ (NSDate *)getNSDateFromString:(NSString *)dateStr
{
    //    CST -06:00 美国中部标准时间
    //    CCT +08:00 中国标准时间
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];   //实例化一个NSDateFormatter对象
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CCT"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];  //设定时间格式,这里可以设置成自己需要的格式
    
    NSDate *destDate =[dateFormat dateFromString:dateStr];
    
    return destDate;
}

+ (NSString *)getChineseWeekdayWithDateString:(NSString *)dateStr
{
    NSString *weekStr=nil;
    NSDate *destDate = [QTXDataUtils getNSDateFromString:dateStr];
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:destDate];
    
    NSInteger week = [comps weekday];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    
    if(week==1)
    {
        weekStr=@"周日";
    }else if(week==2){
        weekStr=@"周一";
        
    }else if(week==3){
        weekStr=@"周二";
        
    }else if(week==4){
        weekStr=@"周三";
        
    }else if(week==5){
        weekStr=@"周四";
        
    }else if(week==6){
        weekStr=@"周五";
        
    }else if(week==7){
        weekStr=@"周六";
    }
    else {
        
    }
    
    NSString *destStr = [NSString stringWithFormat:@"%@  %ld月%ld日", weekStr, (long)month, (long)day];
    
    return destStr;
}

+ (NSString *)getTimeStrWithString:(NSString *)dateStr
{
    NSDate *destDate = [QTXDataUtils getNSDateFromString:dateStr];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:destDate];
    
    NSInteger hour = [comps hour];
    NSInteger minute = [comps minute];
    
    NSString *destStr = [NSString stringWithFormat:@"%02ld:%02ld", (long)hour, (long)minute];
    
    return destStr;
}

+ (NSString *)getTimeStrWithString:(NSString *)dateStr FormatterStr:(NSString *)fStr
{
    NSDate *destDate = [QTXDataUtils getNSDateFromString:dateStr];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CCT"]];
    
    if (fStr)
    {
        [dateFormatter setDateFormat:fStr];
    }
    else
    {
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    }
    
    return [dateFormatter stringFromDate:destDate];
}

//返回时间所在日期当天的准确时间. (20:19)
+(NSString *)smallTimewithTimeStr:(NSString *)dateStr
{
    NSDate *destDate = [QTXDataUtils getNSDateFromString:dateStr];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CCT"]];
    [formatter setDateFormat:@"HH:mm"];
    NSString *str = [formatter stringFromDate:destDate];
    
    return str;
}

//判断两个日期是否是同一天
+(BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

+ (NSInteger)gapDayFromDate:(NSDate *)date1 toDate:(NSDate *)date2
{
    //    // 判断日期
    //    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    //
    //    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    //    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    //
    //    // 粗略计算间隔就足够了
    //    NSInteger gapDays = ([comp2 year]-[comp1 year])*365 + ([comp2 month]-[comp1 month])*30 + ([comp2 day]-[comp1 day])*1;
    
    NSTimeInterval tmpInterval = [date2 timeIntervalSinceDate:date1];
    
    int gapDay = tmpInterval/(60*60*24);
    
    NSInteger gapDays = 0;
    
    switch (gapDay)
    {
        case 0:
        {
            BOOL idSameDay = [self isSameDay:date1 date2:date2];
            
            if (idSameDay == YES)
            {
                gapDays = 0;
            }else{
                gapDays = 1;
            }
        }
            break;
        case 1:
            gapDays = 1;
            break;
        case 2:
            gapDays = 2;
            break;
        default:
            //            gapDays = 3;
            break;
    }
    
    return gapDays;
}

+ (NSString *)getCommentTimeStrWithString:(NSString *)dateStr
{
    NSString *timeStamp = nil;
    
    NSDate *destDate    = [QTXDataUtils getNSDateFromString:dateStr];
    NSDate *nowDate     = [NSDate date];
    
    NSString *timeStr = [self smallTimewithTimeStr:dateStr];
    NSInteger gapDay = [self gapDayFromDate:destDate toDate:nowDate];
    switch (gapDay)
    {
        case 0:
        {
            // 今天
            timeStamp = [NSString stringWithFormat:@"今天 %@", timeStr];
        }
            break;
        case 1:
        {
            // 昨天
            timeStamp = [NSString stringWithFormat:@"昨天 %@", timeStr];
        }
            break;
        case 2:
        {
            // 前天
            timeStamp = [NSString stringWithFormat:@"前天 %@", timeStr];
        }
            break;
        default:
        {
            // 其他日期
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
            NSDateComponents *comps = [calendar components:unitFlags fromDate:destDate];
            
            NSInteger year = [comps year];
            NSInteger month = [comps month];
            NSInteger day = [comps day];
            
            timeStamp = [NSString stringWithFormat:@"%ld-%02ld-%02ld", (long)year, (long)month, (long)day];
        }
            break;
    }
    return timeStamp;
}

//返回时间所在日期当天的准确时间（2014/06/09） (日期格式: 2014-01-02 03:22)
+ (NSString *)dateWithTimeStr:(NSString *)dateStr
{
    NSDate *destDate = [QTXDataUtils getNSDateFromString:dateStr];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CCT"]];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString *str = [formatter stringFromDate:destDate];
    
    return str;
}

// 根据日期返回时间表示 "日" (日期格式: 2014-01-02 03:22)
+ (NSString *)getDayStrWithString:(NSString *)dateStr
{
    NSDate *destDate = [QTXDataUtils getNSDateFromString:dateStr];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CCT"]];
    [formatter setDateFormat:@"dd"];
    NSString *str = [formatter stringFromDate:destDate];
    
    return str;
}

// 根据日期返回时间表示 "月:6月" (日期格式: 2014-01-02 03:22)
+ (NSString *)getMonthStrWithString:(NSString *)dateStr
{
    NSDate *destDate = [QTXDataUtils getNSDateFromString:dateStr];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CCT"]];
    [formatter setDateFormat:@"MM月"];
    NSString *str = [formatter stringFromDate:destDate];
    
    return str;
}

// 根据日期返回时间表示 "年:2014" (日期格式: 2014-01-02 03:22)
+ (NSString *)getYearStrWithString:(NSString *)dateStr
{
    NSDate *destDate = [QTXDataUtils getNSDateFromString:dateStr];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CCT"]];
    [formatter setDateFormat:@"yyyy"];
    NSString *str = [formatter stringFromDate:destDate];
    
    return str;
}

// 根据日期返回时间表示 "7-9 06:09" (日期格式: 2014-01-02 03:22)
+ (NSString *)getMonthAndDayWithDateString:(NSString *)dateStr
{
    NSDate *destDate = [QTXDataUtils getNSDateFromString:dateStr];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:destDate];
    
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    
    //时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CCT"]];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeStr = [formatter stringFromDate:destDate];
    
    
    NSString *destStr = [NSString stringWithFormat:@"%ld-%ld  %@", (long)month, (long)day, timeStr];
    
    return destStr;
}

+ (NSString *)getTimeStringForNow
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmssSSS"]; // 设置日期格式带毫秒的 20150204 163706 082
    NSString *destString = [dateFormat stringFromDate:[NSDate date]];
    
    return destString;
}

// 根据指定时间返回日差
+ (NSInteger)daysFromDate:(NSDate *)destDate
{
    NSTimeInterval timeInterval = [destDate timeIntervalSinceNow];
    NSInteger temp = timeInterval/60/60/24;
    return  temp;
}

+ (NSString *)getWeekStrForIndex:(NSInteger)weekIndex
{
    NSString *weekStr = @"";
    switch (weekIndex)
    {
        case 1:
        {
            weekStr = @"星期日";
        }
            break;
        case 2:
        {
            weekStr = @"星期一";
        }
            break;
        case 3:
        {
            weekStr = @"星期二";
        }
            break;
        case 4:
        {
            weekStr = @"星期三";
        }
            break;
        case 5:
        {
            weekStr = @"星期四";
        }
            break;
        case 6:
        {
            weekStr = @"星期五";
        }
            break;
        case 7:
        {
            weekStr = @"星期六";
        }
            break;
        default:
            break;
    }
    
    return weekStr;
}

+ (NSString *)getDateShowStringWithTimeDict:(NSDictionary *)timeDict
{
    /*
     {
     date = 30;
     day = 0;
     hours = 10;
     minutes = 0;
     month = 7;
     nanos = 337000000;
     seconds = 0;
     time = 1440900000337;
     timezoneOffset = "-480";
     year = 115;
     }
     */
    
    // 今天 09月30日  昨天 09月29日  星期日 08月30日
    
    // 星期或今天昨天
    NSTimeInterval dstInterval = [timeDict[@"time"] doubleValue]/1000;
    NSDate *dstDate = [NSDate dateWithTimeIntervalSince1970:dstInterval];  // 2015-08-30 02:00:00 +0000
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSDateComponents *aComponents = [calendar components:unitFlags fromDate:dstDate];
    
    // Weekday units are the numbers 1 through n, where n is the number of days in the week. For example, in the Gregorian calendar, n is 7 and Sunday is represented by 1.
    NSString *dayStr = [QTXDataUtils getWeekStrForIndex:aComponents.weekday];
    
    NSTimeInterval timeInterval = [dstDate timeIntervalSinceNow];
    NSInteger gapDay = timeInterval/60/60/24;
    if (gapDay == 0) { dayStr = @"今天"; }
    if (gapDay == 1) { dayStr = @"昨天"; }
    
    // 日期
    NSString *dateStr = [NSString stringWithFormat:@"%02ld月%02ld日",
                         aComponents.month,
                         aComponents.day];
    
    NSString *dstStr = [NSString stringWithFormat:@"%@ %@", dayStr, dateStr];
    return  dstStr;
}

+ (NSString *)getSimpleDateShowStringWithTimeDict:(NSDictionary *)timeDict
{
    /*
     {
     date = 30;
     day = 0;
     hours = 10;
     minutes = 0;
     month = 7;
     nanos = 337000000;
     seconds = 0;
     time = 1440900000337;
     timezoneOffset = "-480";
     year = 115;
     }
     */
    
    // 今天 09月30日  昨天 09月29日  星期日 08月30日
    
    // 星期或今天昨天
    NSTimeInterval dstInterval = [timeDict[@"time"] doubleValue]/1000;
    NSDate *dstDate = [NSDate dateWithTimeIntervalSince1970:dstInterval];  // 2015-08-30 02:00:00 +0000
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSDateComponents *aComponents = [calendar components:unitFlags fromDate:dstDate];
    // 日期
    NSString *dateStr = [NSString stringWithFormat:@"%02ld月%02ld日",
                         aComponents.month,
                         aComponents.day];
    
    return  dateStr;
}

// 23:25 08-25
+ (NSString *)getDetailDateShowStringWithTimeDict:(NSDictionary *)timeDict
{
    NSTimeInterval dstInterval = [timeDict[@"time"] doubleValue]/1000;
    NSDate *dstDate = [NSDate dateWithTimeIntervalSince1970:dstInterval];  // 2015-08-30 02:00:00 +0000
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *aComponents = [calendar components:unitFlags fromDate:dstDate];
    NSString *dateStr = [NSString stringWithFormat:@"%02ld:%02ld %02ld-%02ld",
                         aComponents.month,
                         aComponents.day,
                         aComponents.hour,
                         aComponents.minute
                         ];
    return  dateStr;
}

// 10.25 14:45
+ (NSString *)getDetailDateShowStringWithIntervalStr:(NSString *)intervalStr
{
    NSTimeInterval dstInterval = [intervalStr doubleValue];
    NSDate *dstDate = [NSDate dateWithTimeIntervalSince1970:dstInterval];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *aComponents = [calendar components:unitFlags fromDate:dstDate];
    NSString *dateStr = [NSString stringWithFormat:@"%02ld.%02ld %02ld:%02ld",
                         aComponents.month,
                         aComponents.day,
                         aComponents.hour,
                         aComponents.minute
                         ];
    return  dateStr;
}

// 12月20日 星期二
+ (NSString *)getVideoDateShowStringWithIntervalStr:(NSString *)intervalStr;
{
    NSTimeInterval dstInterval = [intervalStr doubleValue];
    NSDate *dstDate = [NSDate dateWithTimeIntervalSince1970:dstInterval];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSDateComponents *aComponents = [calendar components:unitFlags fromDate:dstDate];
    
    NSString *weekStr = @"";
    NSInteger week = aComponents.weekday;
    if(week==1)
    {
        weekStr=@"星期日";
    }else if(week==2){
        weekStr=@"星期一";
        
    }else if(week==3){
        weekStr=@"星期二";
        
    }else if(week==4){
        weekStr=@"星期三";
        
    }else if(week==5){
        weekStr=@"星期四";
        
    }else if(week==6){
        weekStr=@"星期五";
        
    }else if(week==7){
        weekStr=@"星期六";
    }
    
    NSString *dateStr = [NSString stringWithFormat:@"%02ld月%02ld日 %@",
                         aComponents.month,
                         aComponents.day,
                         weekStr
                         ];
    return  dateStr;
}

#pragma mark - check

// 判断 是否是ip地址
+ (BOOL)validateIPAddress:(NSString *)destStr
{
    NSString *aRegex = @"\\b(?:\\d{1,3}\\.){3}\\d{1,3}\\b";
    NSPredicate *aPred = [NSPredicate predicateWithFormat:@"self MATCHES %@", aRegex];
    return [aPred evaluateWithObject:destStr];
}

+ (BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"self MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

+ (BOOL)simpleValidateEmail:(NSString *)emailStr
{
    BOOL isIn = ([emailStr rangeOfString:@"@"].length > 0);
    return isIn;
}


+ (NSURL *)getImageStrWithImageUrlStr:(NSString *)ImageUrlStr width:(NSString *)width height:(NSString *)height
{
    NSString *tmp1Str = [ImageUrlStr substringWithRange:NSMakeRange(0, ImageUrlStr.length-4)];
    NSString *tmp2Str = [ImageUrlStr substringWithRange:NSMakeRange(ImageUrlStr.length-4, 4)];
    
    NSString *destStr = [NSString stringWithFormat:@"%@_%@x%@nw%@", tmp1Str, width, height,tmp2Str];
    
    NSURL *destURL = [NSURL URLWithString:destStr];
    
    return destURL;
}

+ (int)sinaCountWordForString:(NSString*)str
{
    int i,n = (int)[str length],l=0,a=0,b=0;
    
    unichar c;
    
    for(i=0;i<n;i++)
    {
        c = [str characterAtIndex:i];
        if(isblank(c))
        {
            b++;
        }
        else if(isascii(c))
        {
            a++;
        }
        else
        {
            l++;
        }
    }
    
    if(a==0 && l==0)
        return 0;
    
    int len = l+(int)ceilf((float)(a+b)/2.0);
    
    return len;
}

+ (NSString *)getSinaCountStringWithContent:(NSString *)contentStr count:(NSInteger)count
{
    NSString *destStr = nil;
    
    if ([contentStr length] > 90)
    {
        for (int i = 90; i < [contentStr length]; i++)
        {
            NSString *subStr = [contentStr substringToIndex:i];
            int countNum = [self sinaCountWordForString:subStr];
            
            if (countNum >= 90)
            {
                destStr = subStr;
                break;
            }
        }
    }
    else
    {
        destStr = contentStr;
    }
    
    return destStr;
}

// 根据字符串返回性别表示
+ (NSString *)getGenderDisplayStringWithString:(NSString *)sorStr
{
    NSString *displayStr = @"";
    int genderInt = [sorStr intValue];
    switch (genderInt)
    {
        case 0:
        {
            displayStr = @"未知";
        }
            break;
        case 1:
        {
            displayStr = @"男";
        }
            break;
        case 2:
        {
            displayStr =  @"女";
        }
            break;
        default:
            break;
    }
    
    return displayStr;
}

+ (NSString *)getGenderIntStringWithDisplayString:(NSString *)sorStr
{
    NSString *intStr = sorStr;
    
    if ( [sorStr isEqualToString:@""])
    {
        intStr = @"0";
    }
    
    if ( [sorStr isEqualToString:@"男"])
    {
        intStr = @"1";
    }
    
    if ( [sorStr isEqualToString:@"女"])
    {
        intStr = @"2";
    }
    
    return intStr;
}

#pragma mark - 数据解析

// 判断对象是否是正常的数据, 如果不是正常的, 有可能为 nsdictionary, nsarry.
+ (BOOL)isValidObject:(id)ufObject
{
    // NSDictionary 和 NSArray 都有一个count方法
    //    if ([ufObject count])
    //    {
    //        return YES;
    //    }
    
    // 判断字典
    if ([ufObject isKindOfClass:[NSDictionary class]])
    {
        //        if ([ufObject allKeys])
        {
            return YES;
        }
    }
    //
    //    // 判断字典
    //    if ([ufObject isKindOfClass:[NSArray class]])
    //    {
    //        if ([ufObject count])
    //        {
    //            return YES;
    //        }
    //    }
    
    return NO;
}

#pragma mark -  延时执行
/*
 https://developer.apple.com/library/ios/featuredarticles/Short_Practical_Guide_Blocks/
 
 The sections that follow describe each of these cases. But before we get to that, here is a quick overview on interpreting block declarations in framework methods. Consider the following method of the NSSet class:
 
 - (NSSet *)objectsPassingTest:(BOOL (^)(id obj, BOOL *stop))predicate
 The block declaration indicates that the method passes into the block (for each enumerated item) a dynamically typed object and a by-reference Boolean value; the block returns a Boolean value. (What these parameters and return value are actually for are covered in Enumeration.) When specifying your block, begin with a caret (^) and the parenthesized argument list; follow this with the block code itself, enclosed by braces.
 
 [mySet objectsPassingTest:^(id obj, BOOL *stop) {
 // Code goes here: Return YES if obj passes the test and NO if obj does not pass the test.
 }];
 */

//   block部分 :  返回值 + (^) + (参数) + 名称
//+ (void)doSomething:(void (^)(NSError *error))failure
//+ (void)doSomething:(void (^)(void))functions

+ (void)doSomething:(void (^)(void))functions
     afterDelayTime:(double)delayInSeconds
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       functions();
                   });
}

+ (void)doSomethingLater:(void (^)(void))functions
{
    [QTXDataUtils doSomething:functions
               afterDelayTime:0.8];
}

#pragma mark - 主线程执行

+ (void)doSomethingOnSubThread:(void (^)(void))functions
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        functions();
    });
}

+ (void)doSomethingOnMainThread:(void (^)(void))functions
{
    dispatch_async(dispatch_get_main_queue(), ^{
        functions();
    });
}

#pragma mark - image

+ (UIImage *)imageWithImgFileName:(NSString *)imgName
{
    UIImage *myImage = [UIImage imageNamed:imgName];
    return myImage;
}

+ (UIImage *)imageWithImgFileName:(NSString *)imgName
                           ofType:(NSString *)typeStr
{
    //    Instead of using -dataWithContentsOfFile:, I would suggest using -dataWithContentsOfFile:options:, and use the NSDataReadingMappedIfSafe, so that you don't have the overhead of copying around the file's data to user-space until UIImage reads it.
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:imgName ofType:typeStr];
    UIImage *myImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:fileName
                                                                     options:NSDataReadingMappedIfSafe
                                                                       error:nil]];
    return myImage;
}

#pragma mark - view转化为image

+ (UIImage *)captureScrollView:(UIScrollView *)scrollView
{
    UIImage* image = nil;
    
    UIGraphicsBeginImageContext(scrollView.contentSize);
    
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        //        [scrollView drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    
    UIGraphicsEndImageContext();
    if (image != nil)
    {
        return image;
    }
    
    return nil;
}

+ (UIImage *)newImageWithView:(UIView *)view
{
    /*
     https://developer.apple.com/library/ios/qa/qa1817/_index.html#//apple_ref/doc/uid/DTS40014134
     
     
     http://stackoverflow.com/questions/18956611/programmatically-screenshot-works-bad-on-ios-7/19662479#19662479
     
     New API has been added since iOS 7, that should provide efficient way of getting snapshot
     
     snapshotViewAfterScreenUpdates: renders the view into a UIView with unmodifiable content
     resizableSnapshotViewFromRect:afterScreenUpdates:withCapInsets : same thing, but with resizable insets
     drawViewHierarchyInRect:afterScreenUpdates: : same thing if you need all subviews to be drawn too (like labels, buttons...)
     
     You can use the UIView returned for any UI effect, or render in into an image like you did if you need to export.
     I don't know how good this new method performs VS the one you provided (although I remember Apple engineers saying this new API was more efficient)
     */
    /*
     UIGraphicsBeginImageContext
     创建一个基于位图的上下文（context）,并将其设置为当前上下文(context)。方法声明如下：
     void UIGraphicsBeginImageContext(CGSize size);
     参数size为新创建的位图上下文的大小。它同时是由UIGraphicsGetImageFromCurrentImageContext函数返回的图形大小。
     该函数的功能同UIGraphicsBeginImageContextWithOptions的功能相同，相当与UIGraphicsBeginImageContextWithOptions的opaque参数为NO,scale因子为1.0。
     UIGraphicsBeginImageContextWithOptions
     函数原型为：
     void UIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale);
     size——同UIGraphicsBeginImageContext
     opaque—透明开关，如果图形完全不用透明，设置为YES以优化位图的存储。
     scale—–缩放因子
     
     */
    // 这个是facebook的方法
    //    https://github.com/facebook/ios-snapshot-test-case/commit/8adeaf1f676355f8e284a1b849bc4ec7d657ca6d
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

//  renderInContext方法
+ (UIImage *)oldWayImageWithView:(UIView *)view   // iphone4用
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    
    // 由于贴纸的原因, 用了下面的方法.不知道为什么 drawViewHierarchyInRect 这有时绘制出错, 可能是内存的原因
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

+ (UIImage *)captureView:(UIImageView *)faceImageView andSubview:(UIView *)enclosingView
{
    float imageScale = sqrtf(powf(faceImageView.transform.a, 2.f) + powf(faceImageView.transform.c, 2.f));
    CGFloat widthScale = faceImageView.bounds.size.width / faceImageView.image.size.width;
    CGFloat heightScale = faceImageView.bounds.size.height / faceImageView.image.size.height;
    float contentScale = MIN(widthScale, heightScale);
    float effectiveScale = imageScale * contentScale;
    
    CGSize captureSize = CGSizeMake(enclosingView.bounds.size.width / effectiveScale,
                                    enclosingView.bounds.size.height / effectiveScale);
    
    
    UIGraphicsBeginImageContextWithOptions(captureSize, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextScaleCTM(context, 1/effectiveScale, 1/effectiveScale);
    
    [enclosingView.layer renderInContext:context];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

//#pragma mark - 处理数据
//
//+ (NSDictionary *)getProperDictWithData:(NSData *)jsonData
//{
//    if (![jsonData isKindOfClass:[NSData class]])
//    {
//        return nil;
//    }
//    
//    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                             options:NSJSONReadingMutableLeaves
//                                                               error:nil];
//    NSDictionary *cleanDict = [jsonDict dictionaryByReplacingNullsWithBlanks];
//    
//    return cleanDict;
//}

@end
