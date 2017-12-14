//
//  main.m
//  XML2JSON
//
//  Created by HuanFeng on 2017/12/5.
//  Copyright © 2017年 com.tm0755.app. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLReader.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
    }
    NSFileManager *manager= [NSFileManager defaultManager];
    NSArray *subPaths = [manager subpathsOfDirectoryAtPath:@"./" error:nil];
    NSMutableArray *mArr=[NSMutableArray array];
    for (NSString *str in subPaths) {
        NSString *heCheng=[NSString stringWithFormat:@"%@/%@",[manager currentDirectoryPath],str];
        
        if ([heCheng hasSuffix:@".xml"]) {
            [mArr addObject:heCheng];
        }
    }
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSError *error ;
    NSString *content = [NSString stringWithContentsOfFile:mArr.firstObject encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSLog(@"%@",error);
    }else{
        NSLog(@"content --%@",content);
    }

    
    NSError *error2 ;
    NSDictionary *dic=[XMLReader dictionaryForXMLString:content error:&error2];
    NSDictionary *subDic=dic[@"resources"];
    NSArray *stringArr=subDic[@"string"];
    NSMutableString *textFileString=[NSMutableString string];
    for (NSDictionary *dicccc in stringArr) {
        NSString *textKey=dicccc[@"name"];
        NSString *text=dicccc[@"text"];
        [textFileString appendString:[NSString stringWithFormat:@"\"%@\"=\"%@\";\n",textKey,text]];
    }
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *sjc=[NSString stringWithFormat:@"%f",interval];
    NSString *outPutPath=[NSString stringWithFormat:@"%@/%@.txt",[manager currentDirectoryPath],sjc];
    NSError *error3;
    [textFileString writeToFile:outPutPath atomically:YES encoding:NSUTF8StringEncoding error:&error3];
    if (!error3) {
        NSLog(@"文件写入成功 路径为%@",outPutPath);
    }
    return 0;
}
