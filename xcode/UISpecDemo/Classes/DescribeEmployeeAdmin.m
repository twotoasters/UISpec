#import "DescribeEmployeeAdmin.h"

@implementation DescribeEmployeeAdmin

-(void)beforeAll {
	app = [[UIQuery withApplicaton] retain];
}

-(void)afterAll {
	[app release];
}

-(void)addTestUser {
	app.navigationButton.touch;
	[[app.textField.with placeholder:@"First Name"] setText:@"Brian"];
	[[app.textField.with placeholder:@"Last Name"] setText:@"Knorr"];
	[[app.textField.with placeholder:@"Email"] setText:@"b@g.com"];
	[[app.textField.with placeholder:@"Username"] setText:@"bkuser"];
	[[app.textField.with placeholder:@"Password"] setText:@"test"];
	[[app.textField.with placeholder:@"Confirm"] setText:@"test"];
	[[app.navigationButton.label.with text:@"Save"] touch];
}

-(void)deleteTestUser {
	[[[app.tableView.label.with text:@"Brian Knorr"] parents].tableViewCell delete];
}

-(void)itShouldShowListOfDefaultUsers {
	[[app.tableView.label.with text:@"Larry Stooge"] should].exist;
	[[app.tableView.label.with text:@"Curly Stooge"] should].exist;
	[[app.tableView.label.with text:@"Moe Stooge"] should].exist;
	
	UIQuery *tableView = app.tableView;
	int rows = [[tableView dataSource] tableView:tableView numberOfRowsInSection:0];
	[tableView.should have:(rows == 3)];
}

-(void)itShouldNotAddANewUserWithInvalidData {
	app.navigationButton.touch;
	[[app.navigationButton.label.with text:@"Save"] touch];
	app.alertView.should.exist;
	[[app view:@"UIThreePartButton"] touch];
	[[app view:@"UINavigationItemButtonView"] touch];
}

-(void)itShouldAddAndDeleteAUser {
	[self addTestUser];
	[app timeout:1].alertView.should.not.exist;
	[[app.tableView.label.with text:@"Brian Knorr"] should].exist;
	
	[self deleteTestUser];
	[[[app.tableView.label timeout:1].with text:@"Brian Knorr"] should].not.exist;
}

-(void)itShouldUpdateUserProfile {
	[self addTestUser];
	[[app.label.with text:@"Brian Knorr"] touch];
	
	[[app.textField.with placeholder:@"First Name"] setText:@"Jake"];
	[[app.textField.with placeholder:@"Last Name"] setText:@"Dempsey"];
	[[app.navigationButton.label.with text:@"Save"] touch];
	[app timeout:1].alertView.should.not.exist;
	[[app.tableView.label.with text:@"Jake Dempsey"] should].exist;
	[[app.label.with text:@"Jake Dempsey"] touch];
	[[[app.textField.with placeholder:@"First Name"] should].have text:@"Jake"];
	[[[app.textField.with placeholder:@"Last Name"] should].have text:@"Dempsey"];
	
	[[app.textField.with placeholder:@"First Name"] setText:@"Brian"];
	[[app.textField.with placeholder:@"Last Name"] setText:@"Knorr"];
	[[app.navigationButton.label.with text:@"Save"] touch];
	[self deleteTestUser];
}

-(void)itShouldUpdateUserRoles {
	[self addTestUser];
	[[app.label.with text:@"Brian Knorr"] touch];
	[[app.label.with text:@"User Roles"] touch];
	
	[app.tableView scrollToBottom];
	[[app.label.with text:@"Returns"] touch];
	[[[app.label.with text:@"Returns"] parents].tableViewCell.should.have accessoryType:UITableViewCellAccessoryCheckmark];
	
	[[app.tableView.tableViewCell index:0] touch];
	[[app.tableView.tableViewCell index:0].should.have accessoryType:UITableViewCellAccessoryNone];
	
	[[app view:@"UINavigationItemButtonView"] touch];
	[[app view:@"UINavigationItemButtonView"] touch];
	[self deleteTestUser];
}

@end
