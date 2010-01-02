//
//  UIQueryTabBar.m
//  UISpec
//
//  Created by Cory Smith on 09-12-23.
//  Copyright 2009 Leading Lines Design. All rights reserved.
//

#import "UIQueryTabBar.h"

@implementation UIQueryTabBar

-(UIQuery *)selectTabWithTitle:(NSString *)tabTitle {
	[[[self.label text:tabTitle] parent] touch];
	return [UIQuery withViews:views className:className];
}

@end
