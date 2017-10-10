//
//  PortListTableViewController.m
//  testHttp
//
//  Created by iOSDeveloper on 2017/9/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "PortListTableViewController.h"
#import "PortDetailsViewController.h"
#import "HomeTableViewCell.h"
#import "Common.h"

@interface PortListTableViewController ()<UITextFieldDelegate, UIGestureRecognizerDelegate>

//数据源
@property (nonatomic, strong) NSMutableArray *dateArray;

//第一响应的视图
@property (nonatomic) UIView *firstResponder;

@end

@implementation PortListTableViewController

- (NSMutableArray *)dateArray {
    if (_dateArray == nil) {
        _dateArray = [NSMutableArray array];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *folderPath = [documentPath stringByAppendingPathComponent:self.folderName];
        
        NSDirectoryEnumerator *myDirectoryEnumerator = [fileManager enumeratorAtPath:folderPath];
        NSString *file;
        while((file = [myDirectoryEnumerator nextObject]))     //遍历当前目录
        {
            if([[file pathExtension] isEqualToString:@"plist"])   //取得后缀名为.plist的文件
            {
                [_dateArray addObject:file]; //存到数组
            }
        }
        //        NSArray * tempFileList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:folderPath error:nil]];
    }
    
    return _dateArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.title = @"接口列表";
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPort:)];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRClick:)];
    tapGR.delegate = self;
    
    [self.view addGestureRecognizer:tapGR];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)addPort:(id)sender {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *folderPath = [path stringByAppendingPathComponent:self.folderName];
    NSString *fileName;
    NSString *directryPath;
    
    int i = 0;
    do {
        fileName = [NSString stringWithFormat:@"接口%02d.plist", i];
        directryPath = [folderPath stringByAppendingPathComponent:fileName];
        ++i;
    } while ([fileManager fileExistsAtPath:directryPath]);
    
    [fileManager createFileAtPath:directryPath contents:nil attributes:nil];
    
    [self.dateArray addObject:fileName];
    [self.tableView reloadData];
    
}
    
- (IBAction)tapGRClick:(UITapGestureRecognizer *)sender {
    
    if (self.firstResponder && sender.numberOfTouches == 1) {//单击
        [self.view endEditing:YES];
    }
    
}

#pragma mark - keyboard
//键盘显示时调用
- (void)keyboardWillShow:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - height);
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
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
    NSString *folderPath = [path stringByAppendingPathComponent:self.folderName];
    NSString *filePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", cell.fileName.text]];
    NSString *newPath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", textField.text]];
    
    NSError *error;
    
    if (![textField.text  isEqual: @""] && ![filePath isEqualToString:newPath]) {
        if (![fileManager moveItemAtPath:filePath toPath:newPath error:&error]) {
            NSLog(@"%@", error);
        } else {
            [self.dateArray replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%@.plist", textField.text]];
            
            cell.fileName.text = textField.text;
        }
    }
    
    self.firstResponder = nil;
    textField.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dateArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil][0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.fileName.text = [self.dateArray[indexPath.row] stringByDeletingPathExtension];
    cell.editFileName.delegate = self;
    cell.editFileName.tag = 100 + indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PortDetailsViewController *portDetailsVC = [[PortDetailsViewController alloc] init];
    portDetailsVC.folderName = self.folderName;
    portDetailsVC.fileName = self.dateArray[indexPath.row];
    portDetailsVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:portDetailsVC animated:YES];
    
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
    
    NSString *folderPath = [path stringByAppendingPathComponent:self.folderName];
    NSString *filePath = [folderPath stringByAppendingPathComponent:self.dateArray[indexPath.row]];
    
    NSError *error;
    
    if ([fileManager removeItemAtPath:filePath error:&error]) {
        //删除数据，和删除动画
        [self.dateArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    } else {
        NSLog(@"%@", error);
    }
    
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
