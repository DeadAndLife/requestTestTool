//
//  PortDetailsViewController.m
//  testHttp
//
//  Created by iOSDeveloper on 2017/9/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "PortDetailsViewController.h"
#import "ParameterTableViewCell.h"
#import "QYHTTPManager.h"
#import "Common.h"

@interface PortDetailsViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate>

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

//第一响应的视图
@property (nonatomic) UIView *firstResponder;

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

- (void)viewInit {
    if (self.plistData[kRequestURL]) {
        self.portURL.text = self.plistData[kRequestURL];
    }
    if (self.plistData[kRequestType]) {
        [self.requestType setSelectedSegmentIndex:(long)self.plistData[kRequestType]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [self.fileName stringByDeletingPathExtension];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多设置" style:UIBarButtonItemStylePlain target:self action:@selector(optionButtonClick:)];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRClick:)];
    tapGR.delegate = self;
    
    [self.view addGestureRecognizer:tapGR];
    
    [self.sendRequest addTarget:self action:@selector(sendRequest:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveParameter addTarget:self action:@selector(saveParameter:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveLog addTarget:self action:@selector(saveLog:) forControlEvents:UIControlEventTouchUpInside];
    
    [self dataInit];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self viewInit];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self saveParameter:self.saveParameter];
}

- (IBAction)tapGRClick:(UITapGestureRecognizer *)sender {
    
    if (self.firstResponder && sender.numberOfTouches == 1) {//单击
        [self.view endEditing:YES];
    }
    
}

- (IBAction)optionButtonClick:(UIBarButtonItem *)sender {
    
    NSLog(@"%s", __func__);
    
}

/**
 发送请求

 @param sender 发送按钮
 */
- (IBAction)sendRequest:(UIButton *)sender {
    if (self.firstResponder) {
        [self.firstResponder resignFirstResponder];
    }
    
    if (self.requestType.selectedSegmentIndex == 0) {//GET
        
        [[[QYHTTPManager alloc] init] GET:self.portURL.text
                               parameters:self.parameterDict
                         CompletionHandle:^(id responseObject, NSURLSessionTask *task, NSError *error) {
                             NSLog(@"%@",responseObject);
                             NSLog(@"%@",error);
                         }];
        
    } else {//POST
        [[[QYHTTPManager alloc] init] POST:self.portURL.text
                                parameters:self.parameterDict
                          CompletionHandle:^(id responseObject, NSURLSessionTask *task, NSError *error) {
                             
                              NSLog(@"%@",responseObject);
                              NSLog(@"%@",error);
                              
                          }];
    }
    
    NSLog(@"%s", __func__);
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
    
    if (!self.logView.text || [self.logView.text isEqual: @""]) {
        NSLog(@"为空不存储");
        return;
    }
    
    NSDate *date = [NSDate date];
    NSString *logFileName = [NSString stringWithFormat:@"%@%ld", self.title, (long)date.timeIntervalSince1970];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *folderPath = [path stringByAppendingPathComponent:self.folderName];
    NSString *logFilePath = [folderPath stringByAppendingPathComponent:logFileName];
    
    NSError *error;
    
    if ([self.logView.text writeToFile:logFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
        NSLog(@"存储成功");
    } else {
        NSLog(@"存储失败");
    }
    
}

//在界面上显示日志
- (void)showLogsWithString:(NSString *)str {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *newStr = [NSString stringWithFormat:@"\n%@",str];
        self.logView.text = [self.logView.text stringByAppendingString:newStr];
    });
}

#pragma mark-手势代理，解决和tableview点击发生的冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.firstResponder) {//判断如果存在第一响应
        return YES;//手势存在
    }//否则关闭手势
    return NO;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.firstResponder = textField;
    
    if (textField == self.portURL) {
        
    } else {
        NSInteger type = textField.tag % 10;
        NSInteger row = textField.tag / 10 % 100;
        NSInteger section = textField.tag / 1000 - 1;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        ParameterTableViewCell *cell = [self.parameterTableView cellForRowAtIndexPath:indexPath];
        
        if (type == 0) {//key
            cell.keyText.placeholder = cell.keyText.text;
        } else {//value
            cell.valueText.placeholder = cell.valueText.text;
        }
        
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (textField == self.portURL) {
    
    } else {
        NSInteger type = textField.tag % 10;
        NSInteger row = textField.tag / 10 % 100;
        NSInteger section = textField.tag / 1000 - 1;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        ParameterTableViewCell *cell = [self.parameterTableView cellForRowAtIndexPath:indexPath];
        
        if (section == 0) {//header
            if (type == 0) {//key
                [self.headerDict setObject:self.headerDict[cell.keyText.placeholder]  forKey:cell.keyText.text];
                [self.headerDict removeObjectForKey:cell.keyText.placeholder];
            } else {//value
                [self.headerDict setObject:cell.valueText.text forKey:cell.keyText.text];
            }
        } else {//参数
            if (type == 0) {//key
                [self.parameterDict setObject:self.parameterDict[cell.keyText.placeholder] forKey:cell.keyText.text];
                [self.parameterDict removeObjectForKey:cell.keyText.placeholder];
            } else {//value
                [self.parameterDict setObject:cell.valueText.text forKey:cell.keyText.text];
            }
        }
        
    }
    
    self.firstResponder = nil;
  
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:{
            return @"header设置";
        }
            break;
        case 1:{
            return @"参数设置";
        }
            break;
        default:{
            return nil;
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
            cell.valueText.text = [self.headerDict valueForKey:cell.keyText.text];
            
            cell.keyText.delegate = self;
            cell.keyText.tag = 1000 + indexPath.row * 10 + 0;
            cell.valueText.delegate = self;
            cell.valueText.tag = 1000 + indexPath.row * 10 + 1;
        }
    } else {//parameter
        if (indexPath.row == self.parameterDict.allKeys.count) {//最后一行
            cell = [[NSBundle mainBundle] loadNibNamed:@"ParameterTableViewCell" owner:self options:nil][1];
            cell.addLabel.text = @"增加一个请求参数";
        } else {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ParameterTableViewCell" owner:self options:nil][0];
            
            cell.keyText.text = self.parameterDict.allKeys[indexPath.row];
            cell.valueText.text = [self.parameterDict valueForKey:cell.keyText.text];
            
            cell.keyText.delegate = self;
            cell.keyText.tag = 2000 + indexPath.row * 10 + 0;
            cell.valueText.delegate = self;
            cell.valueText.tag = 2000 + indexPath.row * 10 + 1;
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

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//header
        if (indexPath.row == self.headerDict.allKeys.count) return NO;
    } else {//parameter
        if (indexPath.row == self.parameterDict.allKeys.count) return NO;
    }
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
    ParameterTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {//header
        
        [self.headerDict removeObjectForKey:cell.keyText.text];
        
    } else {//parameter
        
        [self.parameterDict removeObjectForKey:cell.keyText.text];
        
    }

    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationTop];
    
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
