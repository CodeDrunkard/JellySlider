//
//  ViewController.m
//  JellySlider
//
//  Created by JT Ma on 20/04/2018.
//  Copyright © 2018 JT. All rights reserved.
//

#import "ViewController.h"
#import "JellySlider.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    JellySlider *slider = [[JellySlider alloc] init];
    [self.view addSubview:slider];
    slider.frame = CGRectMake(0, 80, self.view.bounds.size.width, 40);
    slider.backgroundColor = [UIColor darkGrayColor];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(sliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    [slider addTarget:self action:@selector(sliderTouchEnded:) forControlEvents:UIControlEventTouchUpOutside];
    [slider addTarget:self action:@selector(sliderTouchEnded:) forControlEvents:UIControlEventTouchCancel];
}

- (void)sliderTouchBegan:(JellySlider *)sender {
    NSLog(@"begin");
}

- (void)sliderTouchEnded:(JellySlider *)sender {
    NSLog(@"end");
}

- (void)sliderValueChanged:(JellySlider *)sender {
    NSLog(@"change: %f", sender.value);
}

@end
