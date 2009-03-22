
#import "UIShould.h"
#import "UIQuery.h"
#import "CallCache.h"

@implementation UIShould

@synthesize query;

+(id)withQuery:(UIQuery *)query {
	return [[[UIShould alloc] initWithQuery:query] autorelease];
}

-(id)initWithQuery:(UIQuery *)_query {
	//NSLog(@"creating should");
	if (self = [super init]) {
		self.query = _query;
	}
	return self;
}

-(UIShould *)not {
	isNot = YES;
	return self;
}

-(BOOL)exist {
	[CallCache clear];
	//NSLog(@"exist isNot = %d query view count = %i", isNot, [query views].count);
	if ((([query views].count > 0) && isNot) || (([query views].count == 0) && !isNot)) {
		[NSException raise:nil format:@"%@ should %@", [query viewFilterApplied], (isNot ? @"not exist" : @"exist")];
	}
	return YES;
}

-(UIShould *)have {
	isHave = YES;
	return self;
}

-(void)have:(BOOL)condition {
	[CallCache clear];
	if ((!condition && !isNot) || (condition && isNot)) {
		[NSException raise:nil format:@"%@ did not pass condition: [%@ have:YES]", [[query view] class], (isNot ? @"should.not" : @"should")];
	}
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	if (!isHave) return [super methodSignatureForSelector:aSelector];
	if (isNot) {
		[NSException raise:nil format:@".not isn't supported yet for something like [should.not.have blah:1]"];
	}
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
	[CallCache clear];
	NSMutableString *selector = [NSMutableString stringWithString:NSStringFromSelector([anInvocation selector])];
	NSArray *selectors = [selector componentsSeparatedByString:@":"];
	
	//NSLog(@"type = %s", [[anInvocation methodSignature] getArgumentTypeAtIndex:2]);
	
	NSMutableArray *errors = [NSMutableArray array];
	UIView *view = [[query views] objectAtIndex:0];
	int i = 2;
	id value = nil;
	for (NSString *key in selectors) {
		if (![key isEqualToString:@""]) {
			SEL selector = NSSelectorFromString(key);
			if (![view respondsToSelector:selector]) {
				[errors addObject:[NSString stringWithFormat:@"%@ doesn't respond to %@", [view class], key]];
				continue;
			}
			[anInvocation getArgument:&value atIndex:i];
			NSString *returnType = [NSString stringWithFormat:@"%s", [[view methodSignatureForSelector:selector] methodReturnType]];
			if ([returnType isEqualToString:@"@"]) {
				if ([value isKindOfClass:[NSString class]]) {
					if ([[view performSelector:selector] rangeOfString:value].length == 0) {
						[errors addObject:[NSString stringWithFormat:@"%@ : \"%@\" doesn't contain \"%@\"", key, [view performSelector:selector], value]];
						continue;
					}
				} else if (![[view performSelector:selector] isEqual:value]) {
					[errors addObject:[NSString	 stringWithFormat:@"%@ : %@ is not equal to %@", key, [view performSelector:selector], value]];
					continue;
				}
			} else {
				//NSLog(@"yo %i %i", [view performSelector:selector], value);
				if ([view performSelector:selector] != value) {
					[errors addObject:[NSString	 stringWithFormat:@"%@ is not equal to value", key]];
					continue;
				}
			}
		}
	}
	if (errors.count > 0) {
		[NSException raise:nil format:@"%@ should have %@ but %@", [view class], selector, errors];
	}
}


-(void)dealloc {
	self.query = nil;
	[super dealloc];
}

@end
