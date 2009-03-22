
#import "UIQueryTableViewCell.h"


@implementation UIQueryTableViewCell

-(void)delete {
	[[self target] setEditing:YES animated:YES];
	[[self view:@"UIRemoveControlMinusButton"] touch];
	[[self view:@"_UITableViewCellRemoveControl"] _doRemove:nil];
	[[self target] setEditing:NO animated:YES];
}

@end
