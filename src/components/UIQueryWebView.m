//
//  UIQueryWebView.m
//  UISpec
//
//  Created by Cory Smith on 09-12-30.
//  Copyright 2009 Leading Lines Design. All rights reserved.
//

#import "UIQueryWebView.h"

@implementation UIQueryWebView

-(UIQuery *)setValue:(NSString *)value forElementWithId:(NSString *)elementId {
	UIWebView *webView = self;
	NSString *javascript;
	
	if([self jQuerySupported])
		javascript = [NSString stringWithFormat:@"document.getElementById('%@').value = '%@';", elementId, value];
	else 
		javascript = [NSString stringWithFormat:@"$('#%@').val('%@');", elementId, value];	

	[self stringByEvaluatingJavaScriptFromString:javascript];
	return [UIQuery withViews:views className:className];
}

-(UIQuery *)clickElementWithId:(NSString *)elementId {
	UIWebView *theWebView = self;
	
	NSString *javascript;
	if([self jQuerySupported]) 
		javascript = [NSString stringWithFormat:@"$(#'%@').click();", elementId];
	else 
		javascript = [NSString stringWithFormat:@"document.getElementById('%@').click();", elementId];
	[theWebView stringByEvaluatingJavaScriptFromString:javascript];
	return [UIQuery withViews:views className:className];
}

-(BOOL) jQuerySupported {
	
	UIWebView *theWebView = self;
	NSString *html = [theWebView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
	
	//NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @".jquery."];
	//return [regextest evaluateWithObject:html];
	NSLog([NSString stringWithFormat:@"jQuery Supported : %d", [html rangeOfString:@"jquery"].location != NSNotFound]);
	return [html rangeOfString:@"jquery"].location != NSNotFound;
}

@end
