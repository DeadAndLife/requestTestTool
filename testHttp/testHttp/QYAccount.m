//
//  QYAccount.m
//  testHttp
//
//  Created by iOSDeveloper on 2017/9/26.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "QYAccount.h"

@implementation QYAccount

+(instancetype)shareAccount{
    static QYAccount *account;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        account = [[QYAccount alloc] init];
        //给对象赋值
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        //取出保存在沙盒的值
        account.telephone = [userDef objectForKey:@"telephone"];
        account.userId = [userDef objectForKey:@"userId"];
        account.name = [userDef objectForKey:@"name"];
        account.gender = [userDef objectForKey:@"gender"];
    });
    return account;
}



//save
-(void)saveLogin:(NSDictionary *)info{
    //取出信息,保存在本地和内存
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *telephone  = info[@"telephone"];
    if (telephone) {
        self.telephone = telephone;
        [userDef setObject:telephone forKey:@"telephone"];
    }
    
    NSString *uid = [info[@"userId"] stringValue];
    if (uid) {
        self.userId = uid;
        [userDef setObject:uid forKey:@"userId"];
    }
    
    NSString *name = info[@"name"];
    if (name) {
        self.name = name;
        [userDef setObject:name forKey:@"name"];
    }
    
    NSString *gender = info[@"gender"];
    if (gender) {
        self.gender = gender;
        [userDef setObject:gender forKey:@"gender"];
    }
    
    //同步到物理文件
    [userDef synchronize];
}

//uid
-(NSString *)uid{
    return _userId;
}

-(BOOL)isLogin{
    if (self.userId) {
        return YES;
    }else{
        return NO;
    }
}

@end
