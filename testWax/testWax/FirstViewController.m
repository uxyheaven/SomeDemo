//
//  FirstViewController.m
//  testWax
//
//  Created by Heaven on 15/12/22.
//  Copyright © 2015年 Heaven. All rights reserved.
//
#import <wax/wax.h>
#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setup];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 100, 40)];
    [btn setTitle:@"download" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onDownload) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, 100, 40)];
    [btn setTitle:@"clean" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onClean) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, 100, 40)];
    [btn setTitle:@"hotFix" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onHotFix) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
}

- (void)onDownload
{
    BOOL a = [self downloadLuaFileWithUrl:@"https://raw.githubusercontent.com/uxyheaven/SomeDemo/master/luaScripts/init.lua" path:@"init.lua"];
    BOOL b = [self downloadLuaFileWithUrl:@"https://raw.githubusercontent.com/uxyheaven/SomeDemo/master/luaScripts/SecondViewController.lua" path:@"SecondViewController.lua"];
    
    if (a && b)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下载成功" message:@"开始hotfix" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下载失败" message:@"开始hotfix" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)onClean
{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *file = [doc stringByAppendingPathComponent:@"init.lua"];
    [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
    
    file = [doc stringByAppendingPathComponent:@"SecondViewController.lua"];
    [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
}


- (void)onHotFix
{
    wax_start("init.lua", nil);
}

#pragma mark-
- (BOOL)downloadLuaFileWithUrl:(NSString *)urlPath path:(NSString *)path
{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *directory = [doc stringByAppendingPathComponent:path];
    NSURL *url=[NSURL URLWithString:urlPath];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    NSError *error=nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if([data length]>0)
    {
        NSLog(@"下载成功");
        if([data writeToFile:directory atomically:YES])
        {
            NSLog(@"保存成功");
            return YES;
        }else {
            NSLog(@"保存失败");
        }
    } else {
        NSLog(@"下载失败，失败原因：%@",error);
    }
    
    return NO;
}


@end
