//
//  PortDetailsViewController.m
//  testHttp
//
//  Created by iOSDeveloper on 2017/9/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "PortDetailsViewController.h"
#import "ParameterTableViewCell.h"
#import "Common.h"

@interface PortDetailsViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextView *logView;

@property (weak, nonatomic) IBOutlet UITableView *parameterTableView;

@property (weak, nonatomic) IBOutlet UITextField *portURL;

@property (weak, nonatomic) IBOutlet UISegmentedControl *requestType;

@property (weak, nonatomic) IBOutlet UIButton *sendRequest;

@property (weak, nonatomic) IBOutlet UIButton *saveParameter;

@property (weak, nonatomic) IBOutlet UIButton *saveLog;

//数据源
@property (nonatomic, strong) NSMutableDictionary *plistData;

//请求header的字典
@property (nonatomic, strong) NSMutableDictionary *headerDict;

//请求参数字典
@property (nonatomic, strong) NSMutableDictionary *parameterDict;

//请求选项的字典
@property (nonatomic, strong) NSMutableDictionary *optionDict;

@end

@implementation PortDetailsViewController

- (void)plistInit {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *folderPath = [path stringByAppendingPathComponent:self.folderName];
    NSString *filePath = [folderPath stringByAppendingPathComponent:self.fileName];

    self.plistData = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    
    if (self.plistData == nil) {
        self.plistData = [NSMutableDictionary dictionary];
    }
    
}

- (void)headerInit {
    
    if (!(self.headerDict = self.plistData[kHeader])) {
        self.headerDict = [NSMutableDictionary dictionary];
    }
}

- (void)parameterInit {
    
    if (!(self.parameterDict = self.plistData[kParameter])) {
        self.parameterDict = [NSMutableDictionary dictionary];
    }
}

- (void)optionInit {
    
    if (!(self.optionDict = self.plistData[kOption])) {
        self.optionDict = [NSMutableDictionary dictionary];
    }
}

- (void)dataInit {
    //数据源
    [self plistInit];
    //请求header的字典
    [self headerInit];
    //请求参数字典
    [self parameterInit];
    //请求选项的字典
    [self optionInit];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多设置" style:UIBarButtonItemStylePlain target:self action:@selector(optionButtonClick:)];
    
    [self.sendRequest addTarget:self action:@selector(sendRequest:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveParameter addTarget:self action:@selector(saveParameter:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveLog addTarget:self action:@selector(saveLog:) forControlEvents:UIControlEventTouchUpInside];
    
    [self dataInit];
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)optionButtonClick:(UIBarButtonItem *)sender {
    
    NSLog(@"%s", __func__);
    
}

/**
 发送请求

 @param sender 发送按钮
 */
- (IBAction)sendRequest:(UIButton *)sender {
    
}

/**
 保存参数

 @param sender 保存参数按钮
 */
- (IBAction)saveParameter:(UIButton *)sender {
    
    //请求的url
    if (self.portURL.text) {
        [self.plistData setValue:self.portURL.text forKey:kRequestURL];
    }
    //请求头设置
    if (self.headerDict && ![self.headerDict  isEqual:@{}]) {
        [self.plistData setValue:self.headerDict forKey:kHeader];
    }
    //请求参数设置
    if (self.parameterDict && ![self.parameterDict isEqual:@{}]) {
        [self.plistData setValue:self.parameterDict forKey:kParameter];
    }
    //请求类型GET、POST
    [self.plistData setValue:@(self.requestType.selectedSegmentIndex) forKey:kRequestType];
    //请求其他设置（加密或转换）
    if (self.optionDict && ![self.optionDict isEqual:@{}]) {
        [self.plistData setObject:self.optionDict forKey:kOption];
    }
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *folderPath = [path stringByAppendingPathComponent:self.folderName];
    NSString *filePath = [folderPath stringByAppendingPathComponent:self.fileName];
    
    if ([self.plistData writeToFile:filePath atomically:YES]) {
        NSLog(@"保存成功");
    } else {
        NSLog(@"保存失败");
    }
    
}

/**
 保存返回log

 @param sender 保存log按钮
 */
-(IBAction)saveLog:(UIButton *)sender {
    
}

//在界面上显示日志
- (void)showLogsWithString:(NSString *)str {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *newStr = [NSString stringWithFormat:@"\n%@",str];
        self.logView.text = [self.logView.text stringByAppendingString:newStr];
    });
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:{
            return self.headerDict.allKeys.count + 1;
        }
            break;
        case 1:{
            return self.parameterDict.allKeys.count + 1;
        }
            break;
        default:{
            return 0;
        }
            break;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ParameterTableViewCell *cell;
    
    if (indexPath.section == 0) {//header
        if (indexPath.row == self.headerDict.allKeys.count) {//最后一行
            cell = [[NSBundle mainBundle] loadNibNamed:@"ParameterTableViewCell" owner:self options:nil][1];
            cell.addLabel.text = @"增加一个header参数";
        } else {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ParameterTableViewCell" owner:self options:nil][0];
            
            cell.keyText.text = self.headerDict.allKeys[indexPath.row];
            if ([self.headerDict valueForKey:cell.keyText.text] && ![[self.headerDict valueForKey:cell.keyText.text] isEqual:NULL] ) {
                cell.valueText.text = [self.headerDict valueForKey:cell.keyText.text];
            } else {
                
            }
            
        }
    } else {//parameter
        if (indexPath.row == self.parameterDict.allKeys.count) {//最后一行
            cell = [[NSBundle mainBundle] loadNibNamed:@"ParameterTableViewCell" owner:self options:nil][1];
            cell.addLabel.text = @"增加一个请求参数";
        } else {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ParameterTableViewCell" owner:self options:nil][0];
            
            cell.keyText.text = self.parameterDict.allKeys[indexPath.row];
            cell.valueText.text = [self.parameterDict valueForKey:cell.keyText.text] ? : @"";
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {//header
        if (indexPath.row == self.headerDict.allKeys.count) {//最后一行
            NSString *key;
            int i = 0;
            do {
                key = [NSString stringWithFormat:@"key%02d", i];
                ++i;
            } while ([self.headerDict.allKeys containsObject:key]);
            [self.headerDict setValue:[NSString stringWithFormat:@"value%02d", i] forKey:key];
        }
    } else {//parameter
        if (indexPath.row == self.parameterDict.allKeys.count) {//最后一行
            NSString *key;
            int i = 0;
            do {
                key = [NSString stringWithFormat:@"key%02d", i];
                ++i;
            } while ([self.parameterDict.allKeys containsObject:key]);
            [self.parameterDict setValue:[NSString stringWithFormat:@"value%02d", i] forKey:key];
        }
    }
    
    [self.parameterTableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.row;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
