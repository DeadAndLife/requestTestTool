//
//  NSString+encryptString.h
//  testHttp
//
//  Created by iOSDeveloper on 2017/9/29.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (encryptString)

/**
 md5加密字符串

 @param input 输入
 @return 输出
 */
+ (NSString *) md5:(NSString *) input;

/**
 对象转为json字符串

 @param JSONObject 对象
 @return json字符串
 */
+ (NSString *)stringByJSONObject:(id)JSONObject;

/**
 根据文件路径转化为字典对象

 @param path 文件路径
 @return 字典对象
 */
+ (NSMutableDictionary *)returnDictionaryWithDataPath:(NSString *)path;

@end
