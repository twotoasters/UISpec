
#import "DescribeTextFields.h"

@implementation DescribeTextFields

-(void)beforeAll {
	[super beforeAll];
	[[app.label.with text:@"TextFields"] flash].touch;
}

-(void)afterAll {
	[super afterAll];
	[[app.navigationItemButtonView flash] touch];
}

//-(void)itShouldSetAndClearText {
//	UITextField *textFieldNormal = [[app.textField placeholder:@"<enter text>"] flash];
//	[textFieldNormal becomeFirstResponder];
//	[expectThat(textFieldNormal.text) should:be(@"")];
//	[textFieldNormal setText:@"Hello"];
//	[expectThat(textFieldNormal.text) should:be(@"Hello")];
//	
//	app.pushButton.touch;
//	[expectThat(textFieldNormal.text) should:be(@"")];
//}

-(void)itShouldUseKeyboardToEnterText {
	UITextField *textFieldNormal = [[app.textField placeholder:@"<enter text>"] flash];
	[textFieldNormal becomeFirstResponder];
	[expectThat(textFieldNormal.text) should:be(@"")];
	
	[[app view:@"UIKBKeyView"].all setUserInteractionEnabled:YES];
	
	UIView *doneKey = [[app view:@"UIKBKeyView"] index:1].touch;
	//UIQuery *keyPlane = [app view:@"UIKeyboardImpl"];
	//app.imageView.all.show;
	//[keyPlane touchDownWithKey:[doneKey key] atPoint:CGPointMake(0, 0)];
	//[keyPlane toggleShift];
	[app wait:20];
}


@end
