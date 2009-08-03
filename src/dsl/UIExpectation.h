//
//  UIExpection.h
//  UISpec
//
//  Created by Brian Knorr <btknorr@gmail.com>
//  Copyright(c) 2009 StarterStep, Inc., Some rights reserved.
//
@class UIQuery;

@interface UIExpectation : NSObject {
	UIQuery *query;
	BOOL isNot, exist, isHave;
	UIExpectation *not, *have;
}

@property(nonatomic, retain) UIQuery *query;
@property(nonatomic, readonly) UIExpectation *not, *have;
@property(nonatomic, readonly) BOOL exist;

-(void)have:(BOOL)condition;

+(id)withQuery:(UIQuery *)query;

@end
