#import "UISpec.h"

@implementation main


int main(int argc, char *argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	[UISpec runSpecs];
    [pool release];
}


@end
