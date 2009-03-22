//
//  UIShould.h
//  UISpec
//
//  Created by Brian Knorr <brian.knorr@gmail.com>
//  Copyright(c) 2009 StarterStep, Inc., Some rights reserved.
//

@interface UIShould : NSObject {
	id query;
	BOOL isNot, exist, isHave;
	UIShould *not, *have;
}

@property(nonatomic, retain) id query;
@property(nonatomic, readonly) UIShould *not, *have;
@property(nonatomic, readonly) BOOL exist;

-(void)have:(BOOL)condition;

@end
