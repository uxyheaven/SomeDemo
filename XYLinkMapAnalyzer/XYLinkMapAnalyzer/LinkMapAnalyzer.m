//
//  LinkMapAnalyzer.m
//  XYLinkMapAnalyzer
//
//  Created by Heaven on 16/2/2.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import "LinkMapAnalyzer.h"
#import "FileVO.h"

@interface LinkMapAnalyzer ()

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *result;
@end

@implementation LinkMapAnalyzer

+ (instancetype)linkMapAnalyzerWithString:(NSString *)string
{
    LinkMapAnalyzer *analyzer = [[LinkMapAnalyzer alloc] init];
    analyzer.content = string;
    
    return analyzer;
}

- (BOOL)check
{
    NSRange objsFileTagRange = [_content rangeOfString:@"# Object files:"];
    NSString *subObjsFileSymbolStr = [_content substringFromIndex:objsFileTagRange.location + objsFileTagRange.length];
    NSRange symbolsRange = [subObjsFileSymbolStr rangeOfString:@"# Symbols:"];
    if ([_content rangeOfString:@"# Path:"].length <= 0 || objsFileTagRange.location == NSNotFound || symbolsRange.location == NSNotFound)
    {
        return NO;
    }
    
    return YES;
}

- (void)analyse
{
    NSMutableDictionary *sizeMap = [@{} mutableCopy];
    
    // 符号文件列表
    NSArray *lines = [_content componentsSeparatedByString:@"\n"];
    
    BOOL reachFiles = NO;
    BOOL reachSymbols = NO;
    BOOL reachSections = NO;
    BOOL isStop = NO;
    
    for(NSString *line in lines)
    {
        if ([line hasPrefix:@"#"])   //注释行
        {
            if([line hasPrefix:@"# Object files:"])
                reachFiles = YES;
            else if ([line hasPrefix:@"# Sections:"])
                reachSections = YES;
            else if ([line hasPrefix:@"# Symbols:"])
                reachSymbols = YES;
            
            continue;
        }
        
        if (isStop)
        {
            break;
        }
        
        if(reachFiles == YES && reachSections == NO && reachSymbols == NO)
        {
            NSRange range = [line rangeOfString:@"]"];
            if(range.location != NSNotFound)
            {
                NSString *key = [line substringToIndex:range.location+1];
                
                FileVO *fileVO = [[FileVO alloc] init];
                fileVO.filePath = [line substringFromIndex:range.location + 1];
                sizeMap[key] = fileVO;
            }
            
            continue;
        }
        
        if (reachFiles == YES &&reachSections == YES && reachSymbols == NO)
        {
            continue;
        }
        
        if (reachFiles == YES && reachSections == YES && reachSymbols == YES)
        {
            NSArray *array = [line componentsSeparatedByString:@"\t"];
            if(array.count != 3)
            {
                continue;
            }
            //Address Size File Name
            NSString *fileKeyAndName = array[2];
            NSUInteger size = strtoul([array[1] UTF8String], nil, 16);
            
            NSRange range = [fileKeyAndName rangeOfString:@"]"];
            if(range.location == NSNotFound)
            {
                continue;
            }
            
            NSString *key = [fileKeyAndName substringToIndex:range.location + 1];
            FileVO *fileVO = sizeMap[key];
            fileVO.size += size;
            fileVO.key = key;
            
            continue;
        }
    }
    
    NSArray *symbols = [sizeMap allValues];
    NSArray *sorted = [symbols sortedArrayUsingComparator:^NSComparisonResult(FileVO *  _Nonnull obj1, FileVO *  _Nonnull obj2) {
        if(obj1.size > obj2.size)
            return NSOrderedAscending;
        else if (obj1.size < obj2.size)
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    }];
    
    self.result = @"";
    
    NSMutableString *composite = [@"" mutableCopy];
    NSMutableString *details = [@"" mutableCopy];
    NSUInteger totalSize = 0;
    
    for(FileVO *fileVO in sorted)
    {
        NSString *name = [[fileVO.filePath componentsSeparatedByString:@"/"] lastObject];
        name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [details appendFormat:@"%@   %.3fK   %@\n", fileVO.key, (fileVO.size / 1024.0), name];
        totalSize += fileVO.size;
    }
    
    [composite appendFormat:@"总体积: %.3fK\n", (totalSize / 1024.0)];
    [composite appendFormat:@"各模块体积大小\n%@", details];
    
    self.result = [NSString stringWithFormat:@"%@%@", composite, details];
}

- (void)analyseWithFileKey:(NSString *)fileKey
{
    // 符号文件列表
    NSArray *lines = [_content componentsSeparatedByString:@"\n"];
    
    BOOL reachFiles = NO;
    BOOL reachSymbols = NO;
    BOOL reachSections = NO;
    BOOL isStop = NO;
    
    NSMutableString *composite = [@"" mutableCopy];
    NSMutableString *details = [@"" mutableCopy];
    NSUInteger totalSize = 0;
    
    for(NSString *line in lines)
    {
        if ([line hasPrefix:@"#"])   //注释行
        {
            if([line hasPrefix:@"# Object files:"])
                reachFiles = YES;
            else if ([line hasPrefix:@"# Sections:"])
                reachSections = YES;
            else if ([line hasPrefix:@"# Symbols:"])
                reachSymbols = YES;
            
            continue;
        }
        
        if (isStop)
        {
            break;
        }
        
        if(reachFiles == YES && reachSections == NO && reachSymbols == NO)
        {
            continue;
        }
        
        if (reachFiles == YES &&reachSections == YES && reachSymbols == NO)
        {
            continue;
        }
        
        if (reachFiles == YES && reachSections == YES && reachSymbols == YES)
        {
            NSArray *array = [line componentsSeparatedByString:@"\t"];
            if(array.count != 3)
            {
                continue;
            }
            //Address Size File Name
            NSString *fileKeyAndName = array[2];
            
            NSRange range = [fileKeyAndName rangeOfString:@"]"];
            if(range.location == NSNotFound)
            {
                continue;
            }
            
            NSString *key = [fileKeyAndName substringToIndex:range.location + 1];
            
            if ([key isEqualToString:fileKey])
            {
                NSUInteger size = strtoul([array[1] UTF8String], nil, 16);
                totalSize += size;
                [details appendFormat:@"%.3fk   %@\n", size / 1024.0, fileKeyAndName];
            }
            continue;
        }
    }
    
    [composite appendFormat:@"总体积: %.3fK\n", (totalSize / 1024.0)];
    [composite appendFormat:@"各部分体积大小\n%@", details];
    
    self.result = [NSString stringWithFormat:@"%@%@", composite, details];
}
@end
