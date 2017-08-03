//
//  ViewController.m
//  Player
//
//  Created by wbs on 16/12/27.
//  Copyright © 2016年 xiaomaolv. All rights reserved.
//

#import "ViewController.h"

#import "PlayerVIewController.h"


@interface ViewController () 
@property (nonatomic, weak) UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   
    UILabel *label = [[UILabel alloc] init];
    label.userInteractionEnabled = YES;
    label.text = @"点我";
    label.frame = CGRectMake(100, 100, 100, 100);
    label.backgroundColor = [UIColor greenColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [label addGestureRecognizer:tap];
    [self.view addSubview:label];
    self.label = label;
    
}



- (void)tap
{
    PlayerVIewController *newVC = [[PlayerVIewController alloc] init];
    [self.navigationController pushViewController:newVC animated:YES];
//    [self presentViewController:newVC animated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
