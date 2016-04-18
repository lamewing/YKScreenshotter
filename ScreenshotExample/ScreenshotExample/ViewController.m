//
//  ViewController.m
//  ScreenshotTest
//
//  Created by zhou on 15/4/16.
//  Copyright © 2016年 tapindata. All rights reserved.
//

#import "ViewController.h"

#import <MapKit/MapKit.h>

#import "YKScreenshotter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:mapView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 100.0)];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"Click" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(getScreenImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)getScreenImage
{
    [[YKScreenshotter sharedInstance] getScreenImageWithCompletionBlock:^(UIImage *screenImage) {
       
        UIImageWriteToSavedPhotosAlbum(screenImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"Save success!");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
