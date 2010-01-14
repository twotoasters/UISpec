
#import "DescribeUIExpectation.h"
#import "UIExpectation.h"

@implementation DescribeUIExpectation

-(void)itShouldbe {
	[expectThat(0.000000) should:be(0.0)];
	[expectThat(2.11f) should:be(2.11f)];
	[expectThat(@"Hello") should:be(@"Hello")];
	[expectThat(123) should:be(123)];
	[expectThat(123.43243) should:be(123.43243)];
	[expectThat(YES) should:be(YES)];
	[expectThat(NO) should:be(NO)];
	[expectThat(nil) should:be(nil)];
	[expectThat(UITableViewCellAccessoryCheckmark) should:be(UITableViewCellAccessoryCheckmark)];
}

-(void)itShouldNotbe {
	[expectThat(2.11f) shouldNot:be(2.2f)];
	[expectThat(@"Hello") shouldNot:be(@"Hello there")];
	[expectThat(123) shouldNot:be(321)];
	[expectThat(123.43243) shouldNot:be(123.8977)];
	[expectThat(YES) shouldNot:be(NO)];
	[expectThat(NO) shouldNot:be(YES)];
	[expectThat(nil) shouldNot:be(@"nil")];
	[expectThat(@"nil") shouldNot:be(nil)];
	[expectThat(UITableViewCellAccessoryCheckmark) shouldNot:be(UITableViewCellAccessoryDisclosureIndicator)];
}

-(void)itShouldFail {
	[expectFailureWhen(2.11f) should:be(2.2f)];
	[expectFailureWhen(@"Hello") should:be(@"Hello there")];
	[expectFailureWhen(123) should:be(321)];
	[expectFailureWhen(123.43243) should:be(123.8977)];
	[expectFailureWhen(YES) should:be(NO)];
	[expectFailureWhen(NO) should:be(YES)];
	[expectFailureWhen(nil) should:be(@"nil")];
	[expectFailureWhen(@"nil") should:be(nil)];
	[expectFailureWhen(UITableViewCellAccessoryCheckmark) should:be(UITableViewCellAccessoryDisclosureIndicator)];
	
	[expectFailureWhen(2.11f) shouldNot:be(2.11f)];
	[expectFailureWhen(@"Hello") shouldNot:be(@"Hello")];
	[expectFailureWhen(123) shouldNot:be(123)];
	[expectFailureWhen(123.43243) shouldNot:be(123.43243)];
	[expectFailureWhen(YES) shouldNot:be(YES)];
	[expectFailureWhen(NO) shouldNot:be(NO)];
	[expectFailureWhen(nil) shouldNot:be(nil)];
	[expectFailureWhen(UITableViewCellAccessoryCheckmark) shouldNot:be(UITableViewCellAccessoryCheckmark)];
}


@end
