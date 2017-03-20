//
//  XJCycleProgressView.m
//  SimulateQQVoiceRecord
//
//  Created by trq on 17/3/16.
//  Copyright © 2017年 Jean. All rights reserved.
//

#import "XJCycleProgressView.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface XJCycleProgressView ()
@property (nonatomic, assign) CGPoint myCenter;
@property (nonatomic, assign) CGFloat sideLength;
@end

@implementation XJCycleProgressView

+ (instancetype)createCycleProgressViewWithCenter:(CGPoint)center sideLength:(CGFloat)length {
    
    return [[self alloc] initWithCenter:center sideLength:length];
}

- (instancetype)initWithCenter:(CGPoint)center sideLength:(CGFloat)length {
    
    if (self = [super init]) {
//        self.myCenter = CGPointMake(center.x/2, center.y/2);
        self.backgroundColor = [UIColor clearColor];
        self.myCenter = center;
        self.sideLength = length;
        self.lineWidth = 10;
        
        self.center = center;
        self.bounds = CGRectMake(0, 0, length, length);
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGPoint center = self.myCenter;
    CGFloat radius = self.sideLength/2-self.lineWidth/2.0-0.1;
    CGFloat startA = -M_PI_2;
    CGFloat endA = -M_PI_2 + M_PI*2*self.progress;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:startA
                                                      endAngle:endA
                                                     clockwise:YES];
    CGContextSetLineWidth(ctx, self.lineWidth);
    [kCircleColor setStroke];
    
    CGContextAddPath(ctx, path.CGPath);
    
    CGContextStrokePath(ctx);
    
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

@end
