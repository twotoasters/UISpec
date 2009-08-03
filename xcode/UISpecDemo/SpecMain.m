
#import "UISpec.h"

int main(int argc, char *argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	[UISpec runSpecsAfterDelay:3];
    //[UISpec runSpec:@"DescribeEmployeeAdmin" example:@"itShouldUpdateUserRoles" afterDelay:1];
	
	int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
