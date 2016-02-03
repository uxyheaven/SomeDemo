//
//  FirstViewController.m
//  MainBody
//
//  Created by Heaven on 15/12/31.
//  Copyright © 2015年 Heaven. All rights reserved.
//

#import "FirstViewController.h"
#import "SSZipArchive.h"
#import "AFNetworking.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 100, 30)];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setTitle:@"download" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onDownload) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setTitle:@"unzip" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onZip) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 150, 100, 30)];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setTitle:@"load" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onLoad) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - event
- (void)onDownload
{
    /*
    BOOL a = [self downloadLuaFileWithUrl:@"https://raw.githubusercontent.com/uxyheaven/SomeDemo/master/luaScripts/init.lua" path:@"init.lua"];
    BOOL b = [self downloadLuaFileWithUrl:@"https://raw.githubusercontent.com/uxyheaven/SomeDemo/master/luaScripts/SecondViewController.lua" path:@"SecondViewController.lua"];
    
    if (a && b)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下载成功" message:nil delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下载失败" message:nil delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil];
        [alert show];
    }
     */
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"https://raw.githubusercontent.com/uxyheaven/SomeDemo/master/framework/NormalViewController.framework.zip"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *URL = [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        return URL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        if (error)
        {
            NSString *str = [NSString stringWithFormat:@"%@", error];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下载失败" message:str delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下载成功" message:nil delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil];
            [alert show];
        }

    }];
    [downloadTask resume];
}

- (void)onZip
{
    NSString *atPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/NormalViewController.framework.zip"];
    NSString *toPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSError *err = nil;
    [SSZipArchive unzipFileAtPath:atPath toDestination:toPath overwrite:YES password:nil error:&err];
    if (err)
    {
        NSString *str = [NSString stringWithFormat:@"%@", err];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"解压失败" message:str delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"解压成功" message:nil delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil];
        [alert show];
    }
}


- (void)onLoad
{
    NSString *bundlefile = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/NormalViewController.framework"];
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:bundlefile];
    
    NSError *err;
    
    [frameworkBundle loadAndReturnError:&err];
    
    if (err)
    {
        NSLog(@"%s, %@", __func__, err);
        NSString *str = [NSString stringWithFormat:@"%@", err];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"解压失败" message:str delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    else
    {
        NSString *str = @"bundle load framework success.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"解压成功" message:str delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil];
        [alert show];
    }
    
    Class pacteraClass = NSClassFromString(@"TestViewController");
    if (!pacteraClass)
    {
        NSString *str = @"bundle load framework success.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"加载失败" message:str delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    UIViewController *vc = [[pacteraClass alloc] init];
    
    [vc performSelector:@selector(log) withObject:nil];
    
    [self presentViewController:vc animated:YES completion:nil];

    [frameworkBundle unload];
}

#pragma mark - 
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
