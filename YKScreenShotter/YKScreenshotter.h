//
//  YKScreenshotter.h
//  ScreenshotTest
//
//  Created by zhou on 15/4/16.
//  Copyright © 2016年 tapindata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YKScreenshotter : NSObject

+ (instancetype)sharedInstance;

- (void)getScreenImageWithCompletionBlock:(void(^)(UIImage *screenImage))completionBlock;

@end
