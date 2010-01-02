
#import "UIQueryTabBar.h"

@implementation UIQueryTabBar

-(UIQuery *)selectTabWithTitle:(NSString *)tabTitle {
	[[[self.label text:tabTitle] parent] touch];
	return [UIQuery withViews:views className:className];
}

@end
