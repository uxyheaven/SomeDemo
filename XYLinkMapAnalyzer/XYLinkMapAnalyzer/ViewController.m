//
//  ViewController.h
//  XYLinkMapAnalyzer
//
//  Created by Heaven on 16/2/1.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import "ViewController.h"
#import "FileVO.h"
#import "LinkMapAnalyzer.h"



@interface ViewController()<NSTableViewDelegate, NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextField *filePathTextField;//显示选择的文件路径
@property (weak) IBOutlet NSProgressIndicator *indicator;//指示器


@property (weak) IBOutlet NSScrollView *contentView;//分析的内容
@property (unsafe_unretained) IBOutlet NSTextView *contentTextView;

@property (nonatomic, strong) NSURL *linkMapFileURL;
@property (nonatomic, copy) NSString *linkMapContent;

@property (nonatomic, copy) NSString *result;//分析的结果
@property (nonatomic, strong) LinkMapAnalyzer *analyzer;


@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.indicator.hidden = YES;
   // self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}

- (IBAction)onChooseFile:(id)sender {
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseDirectories:NO];
    [panel setResolvesAliases:NO];
    [panel setCanChooseFiles:YES];
    
    [panel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSURL*  theDoc = [[panel URLs] objectAtIndex:0];
            NSLog(@"%@", theDoc);
            _filePathTextField.stringValue = [theDoc path];
            self.linkMapFileURL = theDoc;
        }
    }];
    
    
}
- (IBAction)onStartAnalyzer:(id)sender
{
    if (!_linkMapFileURL || ![[NSFileManager defaultManager] fileExistsAtPath:[_linkMapFileURL path] isDirectory:nil])
    {
        NSAlert *alert = [[NSAlert alloc]init];
        alert.messageText = @"没有找到该路径！";
        [alert addButtonWithTitle:@"是的"];
        [alert beginSheetModalForWindow:[NSApplication sharedApplication].windows[0] completionHandler:^(NSModalResponse returnCode) {
            
        }];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[_linkMapFileURL absoluteString] forKey:@"filePath"];
    
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
        
        [_analyzer analyse];

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
            [content appendString:@"/linkMap.txt"];
            NSLog(@"content=%@",content);
            [_result writeToFile:content atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }];
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return 10;
}

- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    return [NSString stringWithFormat:@"%@_%@", tableColumn.identifier, @(row)];
}

#pragma mark - NSTableViewDelegate
//- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
//{
//    NSView *view = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
//    return view;
//}
@end
