//
//  UIRedoer.m
//  UISpec
//
//  Created by Brian Knorr <btknorr@gmail.com>
//  Copyright(c) 2009 StarterStep, Inc., Some rights reserved.
//
#import "UIRedoer.h"


@implementation UIRedoer

@synthesize redo;

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	[super forwardInvocation:anInvocation];
	self.play;
}

-(id)play {
	id value = super.play;
	if ([value isKindOfClass:[UIRedoer class]]) {
		if ([[value target] respondsToSelector:@selector(setRedoer:)]) {
			[[value target] setRedoer:self];
		}
	}
	return value;
}

-(id)redo {
	[target performSelector:@selector(redo)];
	return self;
}

@end
