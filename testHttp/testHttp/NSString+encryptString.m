//
//  NSString+encryptString.m
//  testHttp
//
//  Created by iOSDeveloper on 2017/9/29.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "NSString+encryptString.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (encryptString)

+ (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+ (NSString *)stringByJSONObject:(id)JSONObject {
    
    NSString *JSONString = nil;
    
    if ([NSJSONSerialization isValidJSONObject:JSONObject]) {
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:JSONObject options:NSJSONWritingPrettyPrinted error:nil];
        JSONString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
    }else {
        
        NSLog(@"Error! Not is valid JSONObject.");
        
    }
    
    return JSONString;
    
}

//路径文件转dictonary
+ (NSMutableDictionary *)returnDictionaryWithDataPath:(NSString *)path {
    NSData * data = [[NSMutableData alloc] initWithContentsOfFile:path];
    NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSMutableDictionary * myDictionary = [unarchiver decodeObjectForKey:@"talkData"];
    [unarchiver finishDecoding];
    
    return myDictionary;
}

@end
