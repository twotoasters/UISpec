//
//  UIQuerySegmentedControl.m
//  UISpec
//
//  Created by Cory Smith on 09-12-23.
//  Copyright 2009 Leading Lines Design. All rights reserved.
//

#import "UIQuerySegmentedControl.h"


@implementation UIQuerySegmentedControl

-(UIQuery *)selectSegmentWithText:(NSString *)text {
	[[self.label text:@"TV"] touch];
	return [UIQuery withViews:views className:className];
}

@end
