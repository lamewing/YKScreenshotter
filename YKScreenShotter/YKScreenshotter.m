//
//  YKScreenshotter.m
//  ScreenshotTest
//
//  Created by zhou on 15/4/16.
//  Copyright © 2016年 tapindata. All rights reserved.
//

#import "YKScreenshotter.h"

@interface YKScreenshotter ()

@property (nonatomic, strong) dispatch_queue_t screenImgQueue;

@end

@implementation YKScreenshotter

+ (instancetype)sharedInstance
{
    static YKScreenshotter *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YKScreenshotter alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.screenImgQueue = dispatch_queue_create("YKScreenshotter.queue", DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(self.screenImgQueue, dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    }
    return self;
}

- (void)getScreenImageWithCompletionBlock:(void (^)(UIImage *))completionBlock
{
    dispatch_async(self.screenImgQueue, ^{
    
        CGSize screenSize = [UIApplication sharedApplication].delegate.window.bounds.size;
        CGFloat screenScale = [UIScreen mainScreen].scale;
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

        CGContextRef bitmapContext = CGBitmapContextCreate(NULL, screenSize.width * screenScale, screenSize.height * screenScale, 8, screenSize.width * screenScale * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
        CGContextScaleCTM(bitmapContext, screenScale, screenScale);
        CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, screenSize.height);
        CGContextConcatCTM(bitmapContext, flipVertical);
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_main_queue(), ^{
    
            UIGraphicsPushContext(bitmapContext);
            
            for (UIWindow *window in [UIApplication sharedApplication].windows) {
                [window drawViewHierarchyInRect:CGRectMake(0.0, 0.0, screenSize.width, screenSize.height) afterScreenUpdates:NO];
            }
            
            UIGraphicsPopContext();
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
        CGImageRef imgRef = CGBitmapContextCreateImage(bitmapContext);
        UIImage *screenImage = [UIImage imageWithCGImage:imgRef];
        
        CGImageRelease(imgRef);
        CGContextRelease(bitmapContext);
        CGColorSpaceRelease(colorSpace);
        
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(screenImage);
            });
        }
    });
    
}

@end
