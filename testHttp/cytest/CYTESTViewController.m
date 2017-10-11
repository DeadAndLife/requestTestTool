//
//  CYTESTViewController.m
//  testHttp
//
//  Created by 张氏集团 Inc on 2017/10/10.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "CYTESTViewController.h"
#import "QYHTTPManager.h"
#import "Common.h"

@interface CYTESTViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImage *image;

@end

@implementation CYTESTViewController

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithArray:@[@"上传图片"]];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"接口名称";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, HeightSUBNavigationAndStatus(SCREEN_H)) style:UITableViewStylePlain];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getImageFromIpc {
    // 1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    // 2. 创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    /**
     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
     UIImagePickerControllerSourceTypePhotoLibrary, // 相册
     UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
     UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
     }
     */
    // 3. 设置打开照片相册类型(显示所有相簿)
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    // 照相机
    // ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 4.设置代理
    ipc.delegate = self;
    // 5.modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 设置图片
    NSLog(@"%@", info[UIImagePickerControllerOriginalImage]);
    self.image = info[UIImagePickerControllerOriginalImage];
    
    NSData *data = UIImageJPEGRepresentation(self.image, 1.0f);
    
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
//    NSString *base64String = [NSString stringWithFormat:@""];
    
    NSMutableDictionary *upDict = [NSMutableDictionary dictionary];
    [upDict setObject:@"image/png" forKey:@"type"];
    [upDict setObject:encodedImageStr forKey:@"content"];
    [upDict setObject:@(data.length) forKey:@"size"];
    
    NSMutableDictionary *baseDict = [NSMutableDictionary dictionary];
    [baseDict setObject:upDict forKey:@"up"];
    
    NSMutableString *baseString = [NSMutableString stringWithString:[NSString  stringByJSONObject:baseDict]];
    
//    NSString *character = nil;
//    for (int i = 0; i < baseString.length; i ++) {
//        character = [baseString substringWithRange:NSMakeRange(i, 1)];
//        if ([character isEqualToString:@"\n"]){
//            [baseString deleteCharactersInRange:NSMakeRange(i, 1)];
//        }
//    }

    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    [paraDict setObject:baseString forKey:@"base"];
    [paraDict setObject:[NSString md5:@"guanli20170925"] forKey:@"key"];
    
//    NSLog(@"%@", paraDict);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:@"http://guanli.zhaihongli.com/api/uploads/up_img"
       parameters:paraDict
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    [formData appendPartWithFileData:data name:@"file" fileName:@"123456" mimeType:@"image/png"];
} progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSDictionary * responseDict = (NSDictionary *)responseObject;
              UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"成功" message:responseDict.description preferredStyle:UIAlertControllerStyleAlert];
              
              UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                  [alertVC dismissViewControllerAnimated:YES completion:nil];
              }];
              
              [alertVC addAction:okAction];
              
              [self presentViewController:alertVC animated:YES completion:nil];
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"失败" message:error.description preferredStyle:UIAlertControllerStyleAlert];
              
              UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                  [alertVC dismissViewControllerAnimated:YES completion:nil];
              }];
              
              [alertVC addAction:okAction];
              
              [self presentViewController:alertVC animated:YES completion:nil];
          }];
    
    
//    [[QYHTTPManager alloc] POST:@"http://guanli.zhaihongli.com/api/uploads/up_img"
//                     parameters:paraDict
//               CompletionHandle:^(id responseObject, NSURLSessionTask *task, NSError *error) {
//
//                   if (responseObject && responseObject[@""]) {
//
//                   }
//
//                   NSLog(@"%@", responseObject);
//                   NSLog(@"%@", error);
//
//               }];
    
//    self.imageView.image = info[UIImagePickerControllerOriginalImage];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:{// 上传图片
            [self getImageFromIpc];
        }
            break;
            
        default:
            break;
    }
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
