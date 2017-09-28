//
//  QYHTTPManager.m
//  Yueba
//
//  Created by qingyun on 16/7/14.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "QYHTTPManager.h"
#import "Common.h"
#import "QYAccount.h"
#import<CommonCrypto/CommonDigest.h>

@implementation QYHTTPManager

+(instancetype)qyManager{
    QYHTTPManager *manager = [[QYHTTPManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    return manager;
}

- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

-(NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters CompletionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle{
    
    return [self GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandle(responseObject, task, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandle(nil, task, error);
    }];
    
}

-(NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters CompletionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle{
    return [self POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandle(responseObject, task, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandle(nil, task, error);
    }];
}

- (NSURLSessionDataTask *)loginAccount:(NSString *)phoneNumber
                              password:(NSString *)password
                                 isMd5:(bool)isMd5
                      completionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (isMd5) {
        
        NSMutableDictionary *wDic = [NSMutableDictionary dictionary];
        [wDic setObject:phoneNumber forKey:@"username"];
        [wDic setObject:password forKey:@"password"];
        NSMutableDictionary *base = [NSMutableDictionary dictionary];
        [base setObject:wDic forKey:@"w"];
        
        NSString *baseString = [self stringByJSONObject:base];
        
        NSString *md5Str = [self md5:@"guanli20170925"];
        
        [params setObject:baseString forKey:@"base"];
        [params setObject:md5Str forKey:@"key"];
        
    } else {
        params = [NSMutableDictionary dictionaryWithDictionary:@{@"username":phoneNumber, @"password":password}];
    }
    
    NSLog(@"%@", params);
    
    return [self POST:kLoginAPI parameters:params CompletionHandle:completionHandle];
    
}

- (NSString *)stringByJSONObject:(id)JSONObject {
    
    NSString *JSONString = nil;
    
    if ([NSJSONSerialization isValidJSONObject:JSONObject]) {
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:JSONObject options:NSJSONWritingPrettyPrinted error:nil];
        JSONString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
    }else {
        
        NSLog(@"Error! Not is valid JSONObject.");
        
    }
    
    return JSONString;
    
}

#pragma mark - 废弃的方法
//-(NSURLSessionDataTask *)sendSMSCode:(NSString *)phoneNumber CompletionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle{
//
//    //构造参数
//    NSDictionary *params = @{@"telephone":phoneNumber};
//
//    return [self POST:kSMSCodeAPI parameters:params CompletionHandle:completionHandle];
//}
//
//-(NSURLSessionDataTask *)CreatedAccount:(NSString *)phoneNumber SMSCode:(NSString *)code Pwd:(NSString *)pwd CompletionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle{
//
//    //构造参数
//    NSDictionary *params = @{@"telephone":phoneNumber, @"smsCode":code, @"password":pwd};
//
//    return [self POST:kCreatedAccountAPI parameters:params CompletionHandle:completionHandle];
//}
//
//-(NSURLSessionDataTask *)loginAccount:(NSString *)phoneNumber Pwd:(NSString *)pwd CompletionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle{
//    //构造参数字典
//    NSDictionary *params = @{@"telephone":phoneNumber, @"password":pwd};
//
//    return [self POST:kLoginAPI parameters:params CompletionHandle:completionHandle];
//}
//
//-(NSURLSessionDataTask *)uploadUserInfo:(NSDictionary *)userInfo CompletionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle{
//
//    return [self POST:kUploaduserInfoAPI parameters:userInfo CompletionHandle:completionHandle];
//}
//
//-(NSURLSessionDataTask *)getUserInfoWithUserIds:(NSArray *)userIds Gender:(NSString *)gender CompletionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle{
//
//    //把userid用逗号,拼接成字符串
//    NSString *userIdsStr = [userIds componentsJoinedByString:@","];
//
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"userIds":userIdsStr}];
//    if (gender) {
//        [params setObject:gender forKey:@"gender"];
//    }
//    return [self POST:kOtherUserInfosAPI parameters:params CompletionHandle:completionHandle];
//}
//
//
//-(NSURLSessionDataTask *)addFriendId:(NSString *)friendId Like:(BOOL)like CompletionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle{
//
//    NSString *userId = [QYAccount shareAccount].userId;
//
////    NSDictionary *params = @{@"userId":userId, @"friendId":friendId, @"like":@(like)};
//
//    NSDictionary *params = @{@"userId":@"19", @"friendId":@"18", @"like":@(like)};
//    return [self POST:kAddFriendAPI parameters:params CompletionHandle:completionHandle];
//}
//
//
//-(NSURLSessionDataTask *)friendList:(NSString *)userId CompletionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle{
//
//    NSDictionary *params = @{@"userId":userId};
//
//    return [self POST:kFriendListAPI parameters:params CompletionHandle:completionHandle];
//}

@end
