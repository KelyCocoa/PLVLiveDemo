//
//  ViewController.m
//  PLVLiveDemo
//
//  Created by ftao on 2016/10/27.
//  Copyright © 2016年 easefun. All rights reserved.
//

#import "LoginViewController.h"
#import "SettingViewController.h"
#import <PolyvLiveAPI/PolyvLiveAPI.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *channelIdTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"version:%f, version string:%s",PolyvLiveAPIVersionNumber, PolyvLiveAPIVersionString);
}

- (IBAction)loginButtonClick:(id)sender {
    
    __weak typeof(self)weakSelf = self;
    [PolyvLiveLogin getRtmpUrlWithChannelId:self.channelIdTF.text password:self.passwordTF.text success:^(NSString *rtmpUrl) {

        SettingViewController *settingVC = [SettingViewController new];
        settingVC.rtmpUrl = rtmpUrl;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController pushViewController:settingVC animated:YES];
            //[self presentViewController:settingVC animated:YES completion:nil];
        });
    } failure:^(NSString *errName, NSString *errReason) {
        NSLog(@"login: errTitle:%@,errReason:%@",errName,errReason);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:errName message:errReason preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        });
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
