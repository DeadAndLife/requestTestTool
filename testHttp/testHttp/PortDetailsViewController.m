//
//  PortDetailsViewController.m
//  testHttp
//
//  Created by iOSDeveloper on 2017/9/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "PortDetailsViewController.h"

@interface PortDetailsViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextView *logView;

@property (weak, nonatomic) IBOutlet UITableView *parameterTableView;

@property (weak, nonatomic) IBOutlet UITextField *portURL;

@property (weak, nonatomic) IBOutlet UISegmentedControl *requestType;

@property (weak, nonatomic) IBOutlet UIButton *sendRequest;

@property (weak, nonatomic) IBOutlet UIButton *saveParameter;

@property (weak, nonatomic) IBOutlet UIButton *saveLog;

@end

@implementation PortDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多设置" style:UIBarButtonItemStylePlain target:self action:@selector(optionButtonClick:)];
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)optionButtonClick:(UIBarButtonItem *)sender {
    
    NSLog(@"%s", __func__);
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:{
            return 2;
        }
            break;
        case 1:{
            return 3;
        }
            break;
        default:{
            return 0;
        }
            break;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"item"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld组第%ld行", (long)indexPath.section, indexPath.row];
    
    return cell;
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
