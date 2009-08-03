
#import "UIQueryTableView.h"


@implementation UIQueryTableView

-(UIQuery *)scrollToBottom {
	UITableView *table = self;
	int numberOfSections = [table numberOfSections];
	int numberOfRowsInSection = [table numberOfRowsInSection:numberOfSections-1];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberOfRowsInSection-1 inSection:numberOfSections-1];
	[table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	return [UIQuery withViews:views className:className];
}

@end
