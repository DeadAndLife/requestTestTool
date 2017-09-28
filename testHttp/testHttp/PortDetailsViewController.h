//
//  PortDetailsViewController.h
//  testHttp
//
//  Created by iOSDeveloper on 2017/9/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PortDetailsViewController : UIViewController

//文件夹名称，表示是那个项目的
@property (nonatomic, copy) NSString *folderName;

//文件名
@property (nonatomic, copy) NSString *fileName;

@end
