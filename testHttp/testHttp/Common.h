//
//  Common.h
//  testHttp
//
//  Created by iOSDeveloper on 2017/9/26.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#ifndef Common_h
#define Common_h

//url

#define kBaseURL @"http://guanli.zhaihongli.com/"
#define kLoginAPI @"api/login/dologin"
#define kNewsCategory @"api/xinwen/get_category_ss"
#define kNewsList @"api/xinwen/get_news_s"
#define kDutyList @"api/lzjzs/get_lzjz_ss"
#define kAddDuty @"api/lzjzs/set_lzjz"

//bounds

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

///**
// *自定义格式输出
// */
//#ifdef DEBUG
//#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//#else
//#define NSLog(...)
//#endif


//#define DEBUG 1

//#ifdef DEBUG
//#define DMLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__,[NSString stringWithFormat:__VA_ARGS__])
//#else
//#define DMLog(...) do{}while(0)

//#define CUSTOM 1

#endif /* Common_h */
