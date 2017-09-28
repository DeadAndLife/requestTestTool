//
//  QYAccount.h
//  testHttp
//
//  Created by iOSDeveloper on 2017/9/26.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYAccount : NSObject

@property (nonatomic, strong)NSString *userId;
@property (nonatomic, strong)NSString *telephone;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *gender;

//管理登录账户的单例对象
+(instancetype)shareAccount;

//保存信息
-(void)saveLogin:(NSDictionary *)info;

//读取信息
-(NSString *)uid;

//是否登录判断
-(BOOL)isLogin;

//退出登录
//-(void)logout;

@end
