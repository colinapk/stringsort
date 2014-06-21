//
//  main.m
//  stringsort
//
//  Created by Colin on 14-6-11.
//  Copyright (c) 2014年 colin. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // insert code here...
        NSLog(@"\n Hello, World! \n");
        NSFileManager * fm = [NSFileManager defaultManager];
        NSString * mypath = [fm currentDirectoryPath];
        NSLog(@"currentDirectoryPath is %@",mypath);
        NSArray * files = [fm contentsOfDirectoryAtPath:mypath error:nil];
        NSLog(@"Found %lu files\n",(unsigned long)files.count);
        if (files.count>0) {

            for (NSString * filename in files) {
                NSLog(@"Deal with %@\n",filename);
                if ([filename hasSuffix:@".strings"] && ![filename hasPrefix:@"[sorted]"]) {
                    NSLog(@"Found string file %@\n",filename);

                    NSError * error;
                    NSString * content = [NSString stringWithContentsOfFile:filename encoding:NSUnicodeStringEncoding error:&error];
                    if (!content) {
                        NSLog(@"Read error %@\n",[error description]);
                    }
                    
                    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:filename];
                    NSArray * keys = dict.allKeys;
                    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                        return [obj1 compare:obj2];
                    }];

                    
                    
                    NSMutableString * newStrings = [[NSMutableString alloc]init];
                    for (NSString * key in sortedKeys) {
                        
                        NSString * value = [dict objectForKey:key];
                        [newStrings appendFormat:@"\"%@\" = \"%@\";",key,value];
                        if (![key isEqualToString:[sortedKeys lastObject]]) {
                            [newStrings appendString:@"\n"];
                        }
                    }
                    NSData * data = [newStrings dataUsingEncoding:NSUnicodeStringEncoding];
                    NSString * newName = [NSString stringWithFormat:@"%@",filename];
                    BOOL res = [fm createFileAtPath:newName contents:data attributes:[fm attributesOfItemAtPath:filename error:&error]];
                    if (res) {
                        NSLog(@"Create string file %@ success\n",newName);
                    } else {
                        NSLog(@"Create string file %@ fail:%@\n",newName,[error description]);
                    }
                }
            }
        }
        
        
    }
    return 0;
}

