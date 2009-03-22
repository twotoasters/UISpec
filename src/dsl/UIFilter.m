#import "UIFilter.h"
#import "UIQuery.h"

@implementation UIFilter

@synthesize query;

+(id)withQuery:(UIQuery *)query {
	return [[[UIFilter alloc] initWithQuery:query] autorelease];
}

-(id)initWithQuery:(UIQuery *)_query {
	if (self = [super init]) {
		self.query = _query;
	}
	return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	////NSLog(@"methodSignatureForSelector");
	NSString *selector = NSStringFromSelector(aSelector);
	NSRange whereIsSet = [selector rangeOfString:@":"];
	if (whereIsSet.length != 0) {
		return [NSMethodSignature signatureWithObjCTypes:"@@:@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"];
	} 
	else {
		return [super methodSignatureForSelector:aSelector];
	}
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	NSMutableString *selector = [NSMutableString stringWithString:NSStringFromSelector([anInvocation selector])];
	NSArray *selectors = [selector componentsSeparatedByString:@":"];
	
	//NSLog(@"type = %s", [[anInvocation methodSignature] getArgumentTypeAtIndex:2]);
	
	NSMutableArray *array = [NSMutableArray array];
	NSDate *start = [NSDate date];
	while ([start timeIntervalSinceNow] > (0 - [query timeout])) {
		for (UIView *view in [query views]) {
			BOOL matches = YES;
			int i = 2;
			id value = nil;
			for (NSString *key in selectors) {
				if (![key isEqualToString:@""]) {
					SEL selector = NSSelectorFromString(key);
					if (![view respondsToSelector:selector]) {
						matches = NO;
						continue;
					}
					[anInvocation getArgument:&value atIndex:i];
					NSString *returnType = [NSString stringWithFormat:@"%s", [[view methodSignatureForSelector:selector] methodReturnType]];
					if ([returnType isEqualToString:@"@"]) {
						if ([value isKindOfClass:[NSString class]]) {
							if ([[view performSelector:selector] rangeOfString:value].length == 0) {
								matches = NO;
								continue;
							}
						} else if (![[view performSelector:selector] isEqual:value]) {
							matches = NO;
							continue;
						}
					} else {
						//NSLog(@"yo %i %i", [view performSelector:selector], value);
						if (![view performSelector:selector] == value) {
							matches = NO;
							continue;
						}
					}
				}
			}
			if (matches) {
				[array addObject:view];
			}
		}
		if (array.count > 0) {
			break;
		} else {
			[query redo];
		}
	}
	id newQuery = [UIQuery withPreviousViews:[query previousViews] viewFilterApplied:[query viewFilterApplied] resultViews:array];
	[anInvocation setReturnValue:&newQuery];
}

-(void)dealloc {
	self.query = nil;
	[super dealloc];
}

@end
