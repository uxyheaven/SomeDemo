//
//  FileViewController.m
//  XYLinkMapAnalyzer
//
//  Created by Heaven on 16/2/2.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import "FileViewController.h"
#import "LinkMapAnalyzer.h"

@interface FileViewController ()

@property (weak) IBOutlet NSTextField *fileKey;//显示选择的文件路径
@property (weak) IBOutlet NSProgressIndicator *indicator;//指示器

@property (weak) IBOutlet NSScrollView *contentView;//分析的内容
@property (unsafe_unretained) IBOutlet NSTextView *contentTextView;

@property (nonatomic, strong) NSURL *linkMapFileURL;
@property (nonatomic, copy) NSString *linkMapContent;

@property (nonatomic, copy) NSString *result;//分析的结果
@property (nonatomic, strong) LinkMapAnalyzer *analyzer;

@end

@implementation FileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)onStart:(id)sender
{
    NSString *fileURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"filePath"];
    _linkMapFileURL = [NSURL URLWithString:fileURL];
    
    if (!_linkMapFileURL || ![[NSFileManager defaultManager] fileExistsAtPath:[_linkMapFileURL path] isDirectory:nil])
    {
        NSAlert *alert = [[NSAlert alloc]init];
        alert.messageText = @"没有找到该路径！";
        [alert addButtonWithTitle:@"是的"];
        [alert beginSheetModalForWindow:[NSApplication sharedApplication].windows[0] completionHandler:^(NSModalResponse returnCode) {
            
        }];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSString *content = [NSString stringWithContentsOfURL:_linkMapFileURL encoding:NSMacOSRomanStringEncoding error:&error];
        _analyzer = [LinkMapAnalyzer linkMapAnalyzerWithString:content];
        if (![_analyzer check])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSAlert *alert = [[NSAlert alloc]init];
                alert.messageText = @"文件格式不正确";
                [alert addButtonWithTitle:@"是的"];
                [alert beginSheetModalForWindow:[NSApplication sharedApplication].windows[0] completionHandler:^(NSModalResponse returnCode) {
                    
                }];
                
            });
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.indicator.hidden = NO;
            [self.indicator startAnimation:self];
            
        });
        NSString *key = [self.fileKey.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [_analyzer analyseWithFileKey:key];
        
        self.result = _analyzer.result;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.contentTextView.string = _result;
            self.indicator.hidden = YES;
            [self.indicator stopAnimation:self];
        });
    });
}

- (IBAction)onInputFile:(id)sender
{
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseDirectories:YES];
    [panel setResolvesAliases:NO];
    [panel setCanChooseFiles:NO];
    
    [panel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton)
        {
            NSURL*  theDoc = [[panel URLs] objectAtIndex:0];
            NSLog(@"%@", theDoc);
            NSMutableString *content =[[NSMutableString alloc]initWithCapacity:0];
            [content appendString:[theDoc path]];
            [content appendString:@"/linkMap_file.txt"];
            NSLog(@"content=%@",content);
            [_result writeToFile:content atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }];
}

@end
