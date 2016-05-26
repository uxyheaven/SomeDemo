//
//  ViewController.m
//  WriteLeanPrograms
//
//  Created by XingYao on 15/10/16.
//  Copyright © 2015年 XingYao. All rights reserved.
//

#import "ViewController.h"
#import "Demo.h"
#import "Product.h"
#import "ProductSpec.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Demo *demo = [[Demo alloc] init];

    [demo test4];
    [demo test5];
    [demo test5_2];
    [demo test6];
    [demo test7];
    [demo test7_2];
    [demo test9];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
