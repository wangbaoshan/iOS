//
//  RegistBaseViewController.m
//  Sharp Time
//
//  Created by power on 2017/5/7.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "RegistBaseViewController.h"

@interface RegistBaseViewController ()

@end

@implementation RegistBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"existed" style:UIBarButtonItemStylePlain target:self action:@selector(exitSelf)];
}

- (void)exitSelf
{
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
