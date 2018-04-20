//
//  JellySlider.m
//  JellySlider
//
//  Created by JT Ma on 20/04/2018.
//  Copyright © 2018 JT. All rights reserved.
//

#import "JellySlider.h"

@interface JellySlider ()

@property (nonatomic, strong) CALayer *maximumTrack;
@property (nonatomic, strong) CALayer *minimumTrack;
@property (nonatomic, strong) CALayer *thumb;

@end

@implementation JellySlider

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _value = 0.0;
    _minimumValue = 0.0;
    _maximumValue = 1.0;
    
    _trackWidth = 4.0;
    _thumbRadius = 8.0;
    _thumbSelectedMultiplier = 1.4;
    _thumbSelectedAnimationDuration = 0.1;
    
    _minimumTrackTintColor = [UIColor whiteColor];
    _maximumTrackTintColor = [UIColor lightGrayColor];
    self.tintColor = [UIColor whiteColor];
    
    [self setupUI];
    [self thumbUpdate];
}

- (void)setupUI {
    self.maximumTrack = [CALayer layer];
    self.maximumTrack.backgroundColor = _maximumTrackTintColor.CGColor;
    self.maximumTrack.frame = CGRectMake(0, 0, 0, _trackWidth);
    [self.layer addSublayer:self.maximumTrack];
    
    self.minimumTrack = [CALayer layer];
    self.minimumTrack.backgroundColor = _minimumTrackTintColor.CGColor;
    self.minimumTrack.frame = CGRectMake(0, 0, 0, _trackWidth);
    [self.layer addSublayer:self.minimumTrack];
    
    self.thumb = [CALayer layer];
    self.thumb.backgroundColor = self.tintColor.CGColor;
    self.thumb.frame = CGRectMake(0, 0, _thumbRadius * 2, _thumbRadius * 2);
    self.thumb.cornerRadius = _thumbRadius;
    [self.layer addSublayer:self.thumb];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    float sidePadding = _thumbRadius;
    CGFloat w = self.bounds.size.width - sidePadding * 2.0;
    CGFloat h = _trackWidth;
    CGFloat x = sidePadding;
    CGFloat y = (self.bounds.size.height - h) / 2.0;
    
    self.maximumTrack.frame = CGRectMake(x, y, w, h);
    self.maximumTrack.cornerRadius = h / 2.0;
    
    self.thumb.position = CGPointMake([self thumbOriginXWithValue:_value], CGRectGetMidY(self.maximumTrack.frame));
    
    self.minimumTrack.frame = CGRectMake(x, y, self.thumb.position.x, h);
    self.minimumTrack.cornerRadius = h / 2.0;
}

#pragma mark - Tracking Event

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    self.value = [self valueWithTouch:touch];
    [self animateWithThumb:self.thumb isSelected:YES];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    self.value = [self valueWithTouch:touch];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self animateWithThumb:self.thumb isSelected:NO];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [self animateWithThumb:self.thumb isSelected:NO];
}

- (float)valueWithTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self];
    float percentage = point.x / self.bounds.size.width;
    float range = _maximumValue - _minimumValue;
    float value = percentage * range;
    return value;
}

#pragma mark - Update

- (void)thumbUpdate {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    CGRect frame = self.thumb.frame;
    frame.origin.x = [self thumbOriginXWithValue:_value];
    self.thumb.frame = frame;
    
    frame = self.minimumTrack.frame;
    frame.size.width = [self thumbOriginXWithValue:_value];
    self.minimumTrack.frame = frame;
    
    [CATransaction commit];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (float)thumbOriginXWithValue:(float)value {
    float percentage = [self thumbPercentageWithValue:value];
    float offset = percentage * self.maximumTrack.bounds.size.width;
    float originX = CGRectGetMinX(self.maximumTrack.frame) + offset;
    return originX;
}

- (float)thumbPercentageWithValue:(float)value {
    if (_minimumValue == _maximumValue) return 0;
    float range = _maximumValue - _minimumValue;
    float minimumRange = value - _minimumValue;
    float percentage = minimumRange / range;
    return percentage;
}

#pragma mark - Animation

- (void)animateWithThumb:(CALayer *)layer isSelected:(BOOL)selected {
    if (_thumbSelectedMultiplier == 1.0) return;
    if (selected) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:_thumbSelectedAnimationDuration];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        layer.transform = CATransform3DMakeScale(_thumbSelectedMultiplier, _thumbSelectedMultiplier, 1);
        [CATransaction commit];
    } else {
        [CATransaction begin];
        [CATransaction setAnimationDuration:_thumbSelectedAnimationDuration];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        layer.transform = CATransform3DIdentity;
        [CATransaction commit];
    }
}

#pragma mark - Properties

- (void)setValue:(float)value {
    value = MAX(value, _minimumValue);
    value = MIN(value, _maximumValue);
    _value = value;
    [self thumbUpdate];
}

-(void)setTintColor:(UIColor *)tintColor{
    [super setTintColor:tintColor];
    self.thumb.backgroundColor = tintColor.CGColor;
}

-(void)setThumbTintColor:(UIColor *)thumbColor{
    _thumbTintColor = thumbColor;
    self.thumb.backgroundColor = thumbColor.CGColor;
}

-(void)setThumbRadius:(float)thumbRadius{
    _thumbRadius = thumbRadius;
    self.thumb.cornerRadius = thumbRadius;
    self.thumb.frame = CGRectMake(0, 0, _thumbRadius * 2, _thumbRadius * 2);
}

- (void)setTrackWidth:(float)trackWidth {
    _trackWidth = trackWidth;
    self.maximumTrack.frame = CGRectMake(0, 0, 0, _trackWidth);
    self.minimumTrack.frame = CGRectMake(0, 0, 0, _trackWidth);
}

@end
