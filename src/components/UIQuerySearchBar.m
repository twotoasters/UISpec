//
//  UIQuerySearchBar.m
//  UISpec
//
//  Created by Cory Smith on 09-12-23.
//  Copyright 2009 Leading Lines Design. All rights reserved.
//

#import "UIQuerySearchBar.h"

@implementation UIQuerySearchBar

-(UIQuery *)searchWithText:(NSString *)searchText {
	UISearchBar *theSearchBar = self;
	[theSearchBar becomeFirstResponder];
	[theSearchBar setText:searchText];
	[theSearchBar.delegate searchBarSearchButtonClicked:theSearchBar];
	return [UIQuery withViews:views className:className];
}

@end
