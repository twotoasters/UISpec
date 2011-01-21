
#import "DescribeControls.h"

@implementation DescribeControls


-(void)beforeAll {
	[super beforeAll];
	[[app.label.with text:@"Controls"] flash].touch;
}

-(void)afterAll {
	[super afterAll];
	[[app.navigationItemButtonView flash] touch];
}

-(void)itShouldToggleASwitch {
	UISwitch *aSwitch = app.Switch.flash;
	[expectThat(aSwitch.on) should:be(NO)];
	aSwitch.on = YES;
	[expectThat(aSwitch.on) should:be(YES)];
	aSwitch.on = NO;
	[expectThat(aSwitch.on) should:be(NO)];
}

-(void)itShouldMoveAStandardSlider {
	//We use index 1 because a UISwitch is actually a UISlider too
	[self moveSlider:[app.slider index:0].flash];	
}

-(void)itShouldMoveACustomizedSlider {
	//We use index 2 because a UISwitch is actually a UISlider too
	[self moveSlider:[app.slider index:1].flash];
}

-(void)moveSlider:(UISlider *)slider {
	[slider setValue:slider.maximumValue animated:YES];
	[app wait:.5];
	[expectThat(slider.value) should:be(slider.maximumValue)];
	
	[slider setValue:slider.minimumValue animated:YES];
	[app wait:.5];
	[expectThat(slider.value) should:be(slider.minimumValue)];
}

-(void)itShouldMoveAPageControl {
	[app.tableView scrollToBottom];
	[app wait:.5];
	UIPageControl *pageControl = app.pageControl.flash;
	int i = 1;
	while (i < pageControl.numberOfPages) {
		pageControl.currentPage = i;
		[app wait:.05];
		i++;
	}
	i--;
	while (i >= 0) {
		pageControl.currentPage = i;
		[app wait:.05];
		i--;
	}
}

-(void)itShouldStopAndStartActivityIndicator {
	[app.tableView scrollToBottom];
	[app wait:.5];
	UIActivityIndicatorView *activity = app.activityIndicatorView.flash;
	[expectThat([activity isAnimating]) should:be(YES)];
	[activity stopAnimating];
	[app wait:.5];
	[expectThat([activity isAnimating]) should:be(NO)];
	[activity startAnimating];
	[app wait:.5];
	[expectThat([activity isAnimating]) should:be(YES)];
}

-(void)itShouldMoveAProgressView {
	[app.tableView scrollToBottom];
	[app wait:.5];
	UIProgressView *progressView = app.progressView.flash;
	[expectThat(progressView.progress) should:be(0.5)];
	float i = 0.10;
	while (i < 1) {
		progressView.progress = i;
		[app wait:.05];
		i+=.10;
	}
	i-=.10;
	while (i >= 0.0) {
		progressView.progress = i;
		[app wait:.05];
		i-=.10;
	}
}

@end
