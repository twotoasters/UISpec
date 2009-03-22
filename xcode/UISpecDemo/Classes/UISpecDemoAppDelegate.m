
#import "UISpecDemoAppDelegate.h"
#import "ApplicationFacade.h"
#import "EmployeeAdmin.h"

@implementation UISpecDemoAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

	EmployeeAdmin *employeeAdmin = [[[EmployeeAdmin alloc] initWithFrame:[window frame]] autorelease];
	[[ApplicationFacade getInstance] startup:employeeAdmin];
	[window addSubview:employeeAdmin];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
