
#import "UIParents.h"


@implementation UIParents

-(NSArray *)collect:(NSArray *)views {
	NSMutableArray *array = [NSMutableArray array];
	for (UIView *v in views) {
		UIView *sv = v.superview;
		while (sv != nil) {
			[array addObject:sv];
			sv = sv.superview;
		}
	}
	return array;
}

@end
