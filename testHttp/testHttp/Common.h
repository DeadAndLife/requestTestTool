//
//  Common.h
//  testHttp
//
//  Created by iOSDeveloper on 2017/9/26.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#ifndef Common_h
#define Common_h

//key

#define kRequestURL @"requestUrl"
#define kHeader @"header"
#define kParameter @"parameter"
#define kRequestType @"requestType"
#define kOption @"option"
#define kEncrypt @"encrypt"
#define kJsonString @"jsonString"
#define kLogPath @"logPath"

//bounds

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

//categroy
#import "NSString+encryptString.h"

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
