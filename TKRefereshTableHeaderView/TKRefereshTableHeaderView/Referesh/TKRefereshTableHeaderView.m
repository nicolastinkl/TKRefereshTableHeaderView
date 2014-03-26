//
//  TKRefereshTableHeaderView.m
//  TKRefereshTableHeaderView
//
//  Created by apple on 3/26/14.
//  Copyright (c) 2014 lifestyle. All rights reserved.
//

#import "TKRefereshTableHeaderView.h"
#import "TKCircleView.h"
#import <Foundation/Foundation.h>


#define FLIP_ANIMATION_DURATION 0.3f

@implementation TKRefereshTableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:15.0f];
		label.textColor = [UIColor colorWithWhite:0.384 alpha:1.000];
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
        
        TKCircleView *circleView = [[TKCircleView alloc] initWithFrame:CGRectMake(10, 5, 35, 35)];
        _circleView = circleView;
        [self addSubview:circleView];
        
        //set default status
        _circleView.progress = 0;
        [_circleView setNeedsDisplay]; // here why performSelector:view'setNeedsDisplay???
        //
        
    }
    return self;
}



- (void)setCurrentTKState:(TKPullState)aState{
	
  
	switch (aState) {
		case TKPulling:
			_statusLabel.text = @"";
			break;
		case TKNormal:
			if (_state != TKLoading) {
                _circleView.progress = 0;
                [_circleView setNeedsDisplay];
            }
			_statusLabel.text = @"下拉加载";
			break;
		case TKLoading:
			_statusLabel.text = @"加载中...";
            
            CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
            rotate.removedOnCompletion = FALSE;
            rotate.fillMode = kCAFillModeForwards;
            
            //Do a series of 5 quarter turns for a total of a 1.25 turns
            //(2PI is a full turn, so pi/2 is a quarter turn)
            [rotate setToValue: [NSNumber numberWithFloat: M_PI / 2]];
            rotate.repeatCount = 20;
            
            rotate.duration = 0.25;
            //            rotate.beginTime = start;
            rotate.cumulative = TRUE;
            rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            
            [_circleView.layer addAnimation:rotate forKey:@"rotateAnimation"];
			break;
	}
	
	_state = aState;
}

#pragma mark -
#pragma mark ScrollView Methods

- (void)TKRefreshScrollViewWillBeginScroll:(UIScrollView *)scrollView
{
    BOOL  _loading = [self.delegate TKLoadingDataSoureFromAnyWhere:self];
    if (!_loading) {
        [self setCurrentTKState:TKNormal];
    }

}

- (void)TKRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_state == TKLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
        
        _loading = [_delegate TKLoadingDataSoureFromAnyWhere:self];
        
		
		if (_state == TKPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setCurrentTKState:TKNormal];
		} else if (_state == TKNormal && scrollView.contentOffset.y < -15.0f && !_loading) {
            float moveY = fabsf(scrollView.contentOffset.y);
            if (moveY > 65)
                moveY = 65;
            _circleView.progress = (moveY-15) / (65-15);
            [_circleView setNeedsDisplay];
            
            if (scrollView.contentOffset.y < -65.0f) {
                [self setCurrentTKState:TKPulling];
            }
        }
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
}

- (void)TKRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
 	BOOL _loading = NO;
    
    _loading = [_delegate TKLoadingDataSoureFromAnyWhere:self];
    
	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		
			[_delegate TKDidTriggerRefresh:self];
		
		[self setCurrentTKState:TKPulling];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		
	}
}

- (void)TKRefreshScrollViewDataSourceDidLoading:(UIScrollView *)scrollView
{
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
    
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_circleView.layer removeAllAnimations];
    });

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
