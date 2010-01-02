//
//  UIQueryWebView.h
//  UISpec
//
//  Created by Cory Smith on 09-12-30.
//  Copyright 2009 Leading Lines Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIQuery.h"

@interface UIQueryWebView : UIQuery {
	
}
-(UIQuery *)setValue:(NSString *)value forElementWithId:(NSString *)elementId;
-(UIQuery *)clickElementWithId:(NSString *)elementId;

@end
