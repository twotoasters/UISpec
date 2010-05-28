#import "DescribeButtons.h"

@implementation DescribeButtons

-(void)beforeAll {
	[super beforeAll];
	[[app.label.with text:@"Buttons"] flash].touch;
}

-(void)afterAll {
	[super afterAll];
	[[app.navigationItemButtonView flash] touch];
}

-(void)itShouldBeTouchableByLabel {
	[[app.label text:@"Gray"] flash].touch;
}

-(void)itShouldBeTouchableByImage {
	[[app.button.imageView image:[UIImage imageNamed:@"UIButton_custom.png"]] flash].touch;
}

-(void)itShouldTouchAButtonByTitle {
	[[app.button.label text:@"Rounded"] flash].touch;
}

-(void)itShouldBeTouchableByIndex {
	[[app.button index:0] flash].touch;
	[[app.button index:1] flash].touch;
	[[app.button index:2] flash].touch;
}

//This example fails due to a known bug in the sdk
//UIButton.buttonType always returns UIButtonTypeCustom
-(void)itShouldBeTouchableByType {
	[app.tableView scrollDown:6];
	[app wait:1];
	UIButton *detailDisclosureButton = [[app.button timeout:1] buttonType:UIButtonTypeDetailDisclosure];
	[expectThat(detailDisclosureButton.exists) should:be(YES)];
	
	[[app.button buttonType:UIButtonTypeDetailDisclosure] flash].touch;
	[[app.button buttonType:UIButtonTypeInfoLight] flash].touch;
	[[app.button buttonType:UIButtonTypeInfoDark] flash].touch;
	[app.tableView scrollToBottom];
	[app wait:1];
	[[app.button buttonType:UIButtonTypeContactAdd] flash].touch;
}


@end
