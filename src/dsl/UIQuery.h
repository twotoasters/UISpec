//
//  UIQuery.h
//  UISpec
//
//  Created by Brian Knorr <btknorr@gmail.com>
//  Copyright(c) 2009 StarterStep, Inc., Some rights reserved.
//

#import "UIFilter.h"
#import "UIExpectation.h"
#import "CallCache.h"

@interface UIQuery : NSObject {
	CallCache *callCache;
	NSArray *previousViews;
	NSString *viewFilterApplied;
	NSMutableArray *views;
	BOOL parentsMode;
	BOOL allMode;
	int timeout;
	
	UIFilter *with;
	UIExpectation *should;
	UIQuery *touch, *parents, *first, *last, *all, *show, *flash;
	UIQuery *textField, *navigationBar, *label, *button, *navigationButton, *alertView, *textView, *tableView, *tableViewCell;
}

@property BOOL parentsMode, allMode;
@property int timeout;
@property(nonatomic, retain) CallCache *callCache;
@property(nonatomic, retain) NSString *viewFilterApplied;
@property(nonatomic, retain) NSArray *previousViews;
@property(nonatomic, retain) NSMutableArray *views;

@property(nonatomic, readonly) UIFilter *with;
@property(nonatomic, readonly) UIExpectation *should;
@property(nonatomic, readonly) UIQuery *touch, *parents, *first, *last, *all, *flash, *show;
@property(nonatomic, readonly) UIQuery *textField, *navigationBar, *label, *button, *navigationButton, *alertView, *textView, *tableView, *tableViewCell;

+(id)withApplicaton;

-(UIQuery *)view:(NSString *)className;
-(UIQuery *)index:(int)index;
-(UIQuery *)timeout:(int)seconds;
-(UIQuery *)wait:(double)seconds;

@end
