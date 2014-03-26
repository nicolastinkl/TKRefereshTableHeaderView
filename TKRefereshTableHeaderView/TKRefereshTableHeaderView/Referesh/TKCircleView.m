//
//  TKCircleView.m
//  TKRefereshTableHeaderView
//
//  Created by apple on 3/26/14.
//  Copyright (c) 2014 lifestyle. All rights reserved.
//

#import "TKCircleView.h"

@implementation TKCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.268 green:0.673 blue:1.000 alpha:1.000].CGColor);
    CGFloat startAngle = -M_PI/3;
    CGFloat step = 11*M_PI/6 * self.progress;
    CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.height/2, self.bounds.size.width/2-3, startAngle, startAngle+step, 0);
    CGContextStrokePath(context);
}
@end
