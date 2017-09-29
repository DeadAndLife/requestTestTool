//
//  QYHTTPManager.h
//  Yueba
//
//  Created by qingyun on 16/7/14.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void(^QYHTTPSessionManagerCompletionHandle) (id responseObject, NSURLSessionTask *task, NSError *error);

@interface QYHTTPManager : AFHTTPSessionManager

//配置baseurl
//+(instancetype)qyManager;

//封装网络get请求,成功的block和失败的,合二为一
-(NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters CompletionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle;

//封装网络POST请求,成功的block和失败的,合二为一
-(NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters CompletionHandle:(QYHTTPSessionManagerCompletionHandle)completionHandle;

@end
