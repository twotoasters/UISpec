//
//  UIExpection.h
//  UISpec
//
//  Created by Brian Knorr <btknorr@gmail.com>
//  Copyright(c) 2009 StarterStep, Inc., Some rights reserved.
//

@interface UIExpectation : NSObject {
	id query;
	BOOL isNot, exist, isHave;
	UIExpectation *not, *have;
}

@property(nonatomic, retain) id query;
@property(nonatomic, readonly) UIExpectation *not, *have;
@property(nonatomic, readonly) BOOL exist;

-(void)have:(BOOL)condition;

@end
