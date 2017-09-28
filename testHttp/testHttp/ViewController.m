//
//  ViewController.m
//  testHttp
//
//  Created by iOSDeveloper on 2017/9/26.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "ViewController.h"
#import "PortListTableViewController.h"
#import "HomeTableViewCell.h"
#import "QYHTTPManager.h"
#import "Common.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//数据源
@property (nonatomic, strong) NSMutableArray *dateArray;

//第一响应的视图
@property (nonatomic) UIView *firstResponder;

@end

@implementation ViewController

//懒加载
- (NSMutableArray *)dateArray {

    if (_dateArray == nil) {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *FILEPATH = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray * tempFileList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:FILEPATH error:nil]];
        
        _dateArray = [NSMutableArray arrayWithArray:tempFileList];
        
    }
    
    return _dateArray;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.title = @"项目列表";
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAInterface:)];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRClick:)];
    tapGR.delegate = self;
    
    [self.view addGestureRecognizer:tapGR];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)addAInterface:(id)sender {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName;
    NSString *directryPath;
    
    int i = 0;
    do {
        fileName = [NSString stringWithFormat:@"项目名称%02d", i];
        directryPath = [path stringByAppendingPathComponent:fileName];
        ++i;
    } while ([fileManager fileExistsAtPath:directryPath]);
    
    [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    [self.dateArray addObject:fileName];
    [self.tableView reloadData];
    
}

- (IBAction)tapGRClick:(UITapGestureRecognizer *)sender {
    
    if ( self.firstResponder && sender.numberOfTouches == 1) {//单击
        [self.view endEditing:YES];
    }
    
}

#pragma mark-手势代理，解决和tableview点击发生的冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }//否则手势存在
    return YES;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.firstResponder = textField;
    textField.backgroundColor = [UIColor whiteColor];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag - 100 inSection:0];
    HomeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    textField.placeholder = cell.fileName.text;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    textField.backgroundColor = [UIColor clearColor];
    textField.placeholder = @"";
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag - 100 inSection:0];
    HomeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:cell.fileName.text];
    NSString *newPath = [path stringByAppendingPathComponent:textField.text];
    
    NSError *error;
    
    if (![textField.text  isEqual: @""] && ![filePath isEqualToString:newPath]) {
        if (![fileManager moveItemAtPath:filePath toPath:newPath error:&error]) {
            NSLog(@"%@", error);
        } else {
            [self.dateArray replaceObjectAtIndex:indexPath.row withObject:textField.text];
            
            cell.fileName.text = textField.text;
        }
    }
    
    self.firstResponder = nil;
    textField.text = @"";
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dateArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [[NSBundle mainBundle]loadNibNamed:@"HomeTableViewCell" owner:self options:nil][0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.fileName.text = self.dateArray[indexPath.row];
    cell.editFileName.delegate = self;
    cell.editFileName.tag = 100 + indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PortListTableViewController *portListVC = [[PortListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    portListVC.folderName = self.dateArray[indexPath.row];
    portListVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:portListVC animated:YES];
    
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
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
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *folderPath = [path stringByAppendingPathComponent:self.dateArray[indexPath.row]];
    
    NSError *error;
    
    if ([fileManager removeItemAtPath:folderPath error:&error]) {
        //删除数据，和删除动画
        [self.dateArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    } else {
        NSLog(@"%@", error);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
