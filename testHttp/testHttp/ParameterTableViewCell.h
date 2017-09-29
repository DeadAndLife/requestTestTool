//
//  ParameterTableViewCell.h
//  testHttp
//
//  Created by iOSDeveloper on 2017/9/28.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParameterTableViewCell : UITableViewCell

/**
 键文本
 */
@property (weak, nonatomic) IBOutlet UITextField *keyText;

/**
 0层时为空，其他为⌞
 */
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

/**
 左边界，用于区分层级
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyLeadingConstraint;

/**
 值文本
 */
@property (weak, nonatomic) IBOutlet UITextField *valueText;

/**
 增加一个参数文本
 */
@property (weak, nonatomic) IBOutlet UILabel *addLabel;

@end
