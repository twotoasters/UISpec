//
//  UIQuery.h
//  UISpec
//
//  Created by Brian Knorr <brian.knorr@gmail.com>
//  Copyright(c) 2009 StarterStep, Inc., Some rights reserved.
//

#import "UIFilter.h"
#import "UIShould.h"
#import "CallCache.h"

@interface UIQuery : NSObject {
	CallCache *callCache;
	UIView *parentView, *view;
	NSString *viewFilterApplied;
	NSMutableArray *views;
	BOOL parentsMode;
	int timeout;
	
	UIFilter *with;
	UIShould *should;
	UIQuery *touch, *parents;
	UIQuery *textField, *navigationBar, *label, *button, *navigationButton, *alertView, *textView, *tableView, *tableViewCell;
}

@property BOOL parentsMode;
@property int timeout;
@property(nonatomic, retain) CallCache *callCache;
@property(nonatomic, retain) NSString *viewFilterApplied;
@property(nonatomic, retain) UIView *parentView;
@property(nonatomic, retain) NSMutableArray *views;

@property(nonatomic, readonly) UIView *view;
@property(nonatomic, readonly) UIFilter *with;
@property(nonatomic, readonly) UIShould *should;
@property(nonatomic, readonly) UIQuery *touch, *parents;
@property(nonatomic, readonly) UIQuery *textField, *navigationBar, *label, *button, *navigationButton, *alertView, *textView, *tableView, *tableViewCell;

+(id)withApplicaton;

-(UIQuery *)view:(NSString *)className;
-(UIQuery *)index:(int)index;
-(UIQuery *)timeout:(int)seconds;
-(UIQuery *)flash;
-(UIQuery *)show;
-(UIQuery *)showAll;
-(UIQuery *)wait:(double)seconds;

@end
