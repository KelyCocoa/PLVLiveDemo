//
//  SettingTableViewController.m
//  PolyvStreamerDemo
//
//  Created by FT on 16/3/25.
//  Copyright © 2016年 polyv. All rights reserved.
//

#import "SettingTableViewController.h"

@interface SettingTableViewController ()
{
    
    NSArray *_sizeArr;
    NSArray *_fpsArr;
    NSArray *_bpsArr;
    
    NSInteger _selectedSizeRow;
    NSInteger _selectedFpsRow;
    NSInteger _selectedBpdRow;
}
@end

@implementation SettingTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推流设置";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPress)];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //设置数据源
    NSValue *sizeVal1 = [NSValue valueWithCGSize:CGSizeMake(1280, 720)];
    NSValue *sizeVal2 = [NSValue valueWithCGSize:CGSizeMake(640, 360)];
    NSValue *sizeVal3 = [NSValue valueWithCGSize:CGSizeMake(480, 270)];
    
    NSNumber *fpsNum1 = [NSNumber numberWithInt:15];
    NSNumber *fpsNum2 = [NSNumber numberWithInt:20];
    NSNumber *fpsNum3 = [NSNumber numberWithInt:25];
    
    NSNumber *bpsNum1 = [NSNumber numberWithInt:256*1024];
    NSNumber *bpsNum2 = [NSNumber numberWithInt:512*1024];
    NSNumber *bpsNum3 = [NSNumber numberWithInt:600*1024];
    
    _fpsArr = @[fpsNum1, fpsNum2, fpsNum3];
    _bpsArr = @[bpsNum1, bpsNum2, bpsNum3];
    _sizeArr = @[sizeVal1, sizeVal2, sizeVal3];
    
    
    //设置初始选中值
    NSValue *sizeValue = [NSValue valueWithCGSize:self.videoSize];
    NSNumber *fpsNum = [NSNumber numberWithInt:self.frameRate];
    NSNumber *bpsNum = [NSNumber numberWithInt:self.bitrate];
    
    _selectedSizeRow = [_sizeArr indexOfObject:sizeValue];
    _selectedFpsRow = [_fpsArr indexOfObject:fpsNum];
    _selectedBpdRow = [_bpsArr indexOfObject:bpsNum];
    
    
    //注册重用单元格
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"identifier"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0) {
        return _fpsArr.count;
    }else if(section==1){
        return _bpsArr.count;
    }else {
        return _sizeArr.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0: {
            cell.textLabel.text = [NSString stringWithFormat:@"%@",_fpsArr[indexPath.row]];
            if (indexPath.row == _selectedFpsRow) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }else {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
        }
            break;
        case 1: {
            cell.textLabel.text = [NSString stringWithFormat:@"%@",_bpsArr[indexPath.row]];
            if (indexPath.row == _selectedBpdRow) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }else {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
        }
            break;
            
        default: {
            cell.textLabel.text = [NSString stringWithFormat:@"%@",_sizeArr[indexPath.row]];
            if (indexPath.row == _selectedSizeRow) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }else {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
        }
            break;
    }
    
    return cell;
}

#pragma mark - UItableViewDelegate代理事件

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];  //取消选中状态
    
    NSIndexPath *lastIndexPath;
    
    if (indexPath.section==0) {
        lastIndexPath = [NSIndexPath indexPathForRow:_selectedFpsRow inSection:0];
        _selectedFpsRow = indexPath.row;
    }else if (indexPath.section==1) {
        lastIndexPath = [NSIndexPath indexPathForRow:_selectedBpdRow inSection:1];
        _selectedBpdRow = indexPath.row;
    }else {
        lastIndexPath = [NSIndexPath indexPathForRow:_selectedSizeRow inSection:2];
        _selectedSizeRow = indexPath.row;
    }
    
    
    //NSLog(@"seleted indexPath:%@",indexPath);
    // 取消本组上一次选中的
    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastIndexPath];
    lastCell.accessoryType = UITableViewCellAccessoryNone;
    
    // 选中操作
    UITableViewCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *headView = [UITableViewHeaderFooterView new];
    
    if (section==0) {
        headView.textLabel.text = @"帧率";
    }else if(section==1){
        headView.textLabel.text = @"码率";
    }else {
        headView.textLabel.text = @"分辨率";
    }
    
    return headView;
}

#pragma mark - 点击完成按钮事件

- (void)doneButtonPress {
    
    CGSize videoSize = [_sizeArr[_selectedSizeRow] CGSizeValue];
    int frameRate = [_fpsArr[_selectedFpsRow] intValue];
    int bitRate = [_bpsArr[_selectedBpdRow] intValue];
    
    //回调传值
    self.settingBlock(videoSize , frameRate, bitRate);
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
