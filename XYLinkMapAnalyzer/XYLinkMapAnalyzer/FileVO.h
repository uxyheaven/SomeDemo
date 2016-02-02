//
//  FileVO.h
//  XYLinkMapAnalyzer
//
//  Created by Heaven on 16/2/1.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileVO : NSObject

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) NSUInteger size;

@end
