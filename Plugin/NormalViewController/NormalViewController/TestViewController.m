//
//  TestViewController.m
//  NormalViewController
//
//  Created by Heaven on 15/12/31.
//  Copyright © 2015年 Heaven. All rights reserved.
//

#import "TestViewController.h"
#import "NormalViewController.h"
#import <LibA.h>

@interface TestViewController ()

@end

@implementation TestViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *ver = FrameworkVer;
        self.title = ver;
        NSLog(@"%s, %@", __FUNCTION__, ver);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%s", __FUNCTION__);
    
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 100, 30)];
    title.tintColor = [UIColor redColor];
    title.text = self.title;
    [self.view addSubview:title];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 100, 30)];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setTitle:@"back" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 150, 100, 30)];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setTitle:@"LibA" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onLibA) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    NSString *bundlefile = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/NormalViewController.framework"];
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:bundlefile];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 150, 30)];
    label.text = @"Bundle";
    label.tintColor = [UIColor redColor];
    [self.view addSubview:label];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[frameworkBundle pathForResource:@"pic" ofType:@"png"]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 200, 50, 50)];
    imageView.backgroundColor = [UIColor lightGrayColor];
    imageView.image = image;
    [self.view addSubview:imageView];
    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, 150, 30)];
    label.text = @"file";
    label.tintColor = [UIColor redColor];
    [self.view addSubview:label];
    image = [[UIImage alloc] initWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/pic.png"]];
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 250, 50, 50)];
    imageView.backgroundColor = [UIColor lightGrayColor];
    imageView.image = image;
    [self.view addSubview:imageView];
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

- (void)log
{
    NSLog(@"%s", __FUNCTION__);
}
#pragma mark -
- (void)onBack
{
    NSLog(@"%s", __FUNCTION__);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onLibA
{
    [LibA show];
}
@end
