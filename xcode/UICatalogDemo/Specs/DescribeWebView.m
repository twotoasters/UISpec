#import "DescribeWebView.h"
#import "UIExpectation.h"

@implementation DescribeWebView


-(void)beforeAll {
	[super beforeAll];
	[[app.label.with text:@"Web"] flash].touch;
	[app wait: 2];
}

-(void)afterAll {
	[super afterAll];
	[[app.navigationItemButtonView flash] touch];
}

-(void)itShouldSetValue {
	[app.webView setValue:@"UISpec" forElementWithId:@"query"];
}

-(void)itShouldClickButton {
	[app.webView clickElementWithId:@"b"];
}

@end
