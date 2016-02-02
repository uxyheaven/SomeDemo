//
//  LinkMapAnalyer.h
//  XYLinkMapAnalyzer
//
//  Created by Heaven on 16/2/2.
//  Copyright © 2016年 Heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinkMapAnalyzer : NSObject

@property (nonatomic, copy, readonly) NSString *content;
@property (nonatomic, copy, readonly) NSString *result;

+ (instancetype)linkMapAnalyzerWithString:(NSString *)string;

- (BOOL)check;
- (void)analyse;
- (void)analyseWithFileKey:(NSString *)fileKey;



@end
