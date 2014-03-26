//
//  TKRefereshTableHeaderView.h
//  TKRefereshTableHeaderView
//
//  Created by apple on 3/26/14.
//  Copyright (c) 2014 lifestyle. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{
	TKPulling = 0,
	TKNormal,
	TKLoading,
} TKPullState;

@class TKRefereshTableHeaderView;
@protocol TKRefereshTableHeaderViewDelegate
- (void)TKDidTriggerRefresh:(TKRefereshTableHeaderView*)view;
- (BOOL)TKLoadingDataSoureFromAnyWhere:(TKRefereshTableHeaderView*)view;
@end

/**
 *  TKRefereshTableHeaderView
 */
@class TKRefereshTableHeaderViewDelegate,TKCircleView;
@interface TKRefereshTableHeaderView : UIView
{ 
	TKPullState _state;
	UILabel *_statusLabel;
    TKCircleView *_circleView;
}

@property(nonatomic,assign) id <TKRefereshTableHeaderViewDelegate> delegate;

- (void)TKRefreshScrollViewWillBeginScroll:(UIScrollView *)scrollView;
- (void)TKRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)TKRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)TKRefreshScrollViewDataSourceDidLoading:(UIScrollView *)scrollView;

@end
