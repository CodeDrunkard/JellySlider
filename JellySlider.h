//
//  JellySlider.h
//  JellySlider
//
//  Created by JT Ma on 20/04/2018.
//  Copyright © 2018 JT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JellySlider : UIControl

@property (nonatomic) float value;                              // default 0.0. this value will be pinned to min/max
@property (nonatomic) float minimumValue;                       // default 0.0. the current value may change if outside new min value
@property (nonatomic) float maximumValue;                       // default 1.0. the current value may change if outside new max value

@property (nonatomic) float trackWidth;                         // default 4.0.

@property (nonatomic) float thumbRadius;                        // default 8.0.
@property (nonatomic) float thumbSelectedMultiplier;            // default 1.4.
@property (nonatomic) float thumbSelectedAnimationDuration;     // default 0.1s.

@property (nullable, nonatomic, strong) UIColor *minimumTrackTintColor;
@property (nullable, nonatomic, strong) UIColor *maximumTrackTintColor;
@property (nullable, nonatomic, strong) UIColor *thumbTintColor;

@end
