
#import "UISpec.h"

int main(int argc, char *argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	[UISpec runSpecsAfterDelay:3];
    
	int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
