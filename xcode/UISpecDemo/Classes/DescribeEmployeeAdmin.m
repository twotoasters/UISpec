#import "DescribeEmployeeAdmin.h"
#import "UIBug.h"

@implementation DescribeEmployeeAdmin

-(void)beforeAll {
	app = [[UIQuery withApplicaton] retain];
	[UIBug bugAtPoint:CGPointMake(0, 465)];
}

-(void)afterAll {
	[app release];
}

-(void)addTestUser {
	//app.navigationButton.touch;
	//[app run:@"navigationButton touch"];
	$(@"navigationButton touch");
	$(@"textField placeholder:'First Name' setText:'Brian'");
	//[[app.textField.with placeholder:@"First Name"] setText:@"Brian"];
	[[app.textField placeholder:@"Last Name"] setText:@"Knorr"];
	[[app.textField placeholder:@"Email"] setText:@"b@g.com"];
	[[app.textField placeholder:@"Username*"] setText:@"bkuser"];
	[[app.textField placeholder:@"Password*"] setText:@"test"];
	[[app.textField placeholder:@"Confirm*"] setText:@"test"];
	[[app.navigationButton.label text:@"Save"] touch];
}

-(void)deleteTestUser {
	[[[app.tableView.label text:@"Brian Knorr"] parent].tableViewCell delete];
}

-(void)itShouldShowListOfDefaultUsers {
	[[app.tableView.label text:@"Larry Stooge"] should].exist;
	[[app.tableView.label text:@"Curly Stooge"] should].exist;
	[[app.tableView.label text:@"Moe Stooge"] should].exist;
	
	UIQuery *tableView = app.tableView;
	int rows = [[tableView dataSource] tableView:tableView numberOfRowsInSection:0];
	[tableView.should have:(rows == 3)];
}

-(void)itShouldNotAddANewUserWithInvalidData {
	app.navigationButton.touch;
	[[app.navigationButton.label text:@"Save"] touch];
	app.alertView.should.exist;
	[[app view:@"UIThreePartButton"] touch];
	[[app view:@"UINavigationItemButtonView"] touch];
}

-(void)itShouldAddAndDeleteAUser {
	[self addTestUser];
	[app timeout:1].alertView.should.not.exist;
	[[app.tableView.label text:@"Brian Knorr"] should].exist;
	
	[self deleteTestUser];
	[[[app.tableView.label timeout:1] text:@"Brian Knorr"] should].not.exist;
}

-(void)itShouldUpdateUserProfile {
	[self addTestUser];
	[[app.label.with text:@"Brian Knorr"] touch];
	
	[[app.textField placeholder:@"First Name"] setText:@"Jake"];
	[[app.textField placeholder:@"Last Name"] setText:@"Dempsey"];
	[[app.navigationButton.label text:@"Save"] touch];
	[app timeout:1].alertView.should.not.exist;
	[[app.tableView.label text:@"Jake Dempsey"] should].exist;
	[[app.label text:@"Jake Dempsey"] touch];
	[[[app.textField placeholder:@"First Name"] should].have text:@"Jake"];
	[[[app.textField placeholder:@"Last Name"] should].have text:@"Dempsey"];
	
	[[app.textField placeholder:@"First Name"] setText:@"Brian"];
	[[app.textField placeholder:@"Last Name"] setText:@"Knorr"];
	[[app.navigationButton.label text:@"Save"] touch];
	[self deleteTestUser];
}

-(void)itShouldUpdateUserRoles {
	[self addTestUser];
	[[app.label.with text:@"Brian Knorr"] touch];
	[[app.label text:@"User Roles"] touch];

	[app.tableView scrollDown:4];

	[[app.label text:@"Returns"] touch];
	[[[app.label text:@"Returns"] parent].tableViewCell.should.be selected];
	$(@"label text:'Returns' parent tableViewCell should have accessoryType:%d", UITableViewCellAccessoryCheckmark);
	
	[[app.label text:@"Returns"] touch];
	[[[app.label text:@"Returns"] parent].tableViewCell.should.have accessoryType:UITableViewCellAccessoryNone];
	
	[[app view:@"UINavigationItemButtonView"] touch];
	[[app view:@"UINavigationItemButtonView"] touch];
	[self deleteTestUser];
}

@end
