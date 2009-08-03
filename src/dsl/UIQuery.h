//
//  UIQuery.h
//  UISpec
//
//  Created by Brian Knorr <btknorr@gmail.com>
//  Copyright(c) 2009 StarterStep, Inc., Some rights reserved.
//

#import "UIFilter.h"
#import "UIExpectation.h"
#import "Recordable.h"
#import "UITraversal.h"

@interface UIQuery : UITraversal {
	UIFilter *with;
	UIExpectation *should;
	UITraversal *parent, *child, *descendant, *find;
	UIQuery *touch, *show, *flash;
}

@property(nonatomic, readonly) UIFilter *with;
@property(nonatomic, readonly) UIExpectation *should;
@property(nonatomic, readonly) UITraversal *parent, *child, *descendant, *find;
@property(nonatomic, readonly) UIQuery *touch, *flash, *show;

+(id)withApplicaton;

@end

