
#import "UIChildren.h"


@implementation UIChildren

-(NSArray *)collect:(NSArray *)views {
	NSMutableArray *array = [NSMutableArray array];
	for (UIView *view in views) {
		for (UIView *subView in view.subviews) {
			[array addObject:subView];
		}
	}
	return array;
}

@end
