
#import "UIExpectation.h"
#import "UIQuery.h"

@implementation UIExpectation

@synthesize query;

+(id)withQuery:(UIQuery *)query {
	return [[[UIExpectation alloc] initWithQuery:query] autorelease];
}

-(id)initWithQuery:(UIQuery *)_query {
	if (self = [super init]) {
		self.query = _query;
	}
	return self;
}

-(UIExpectation *)not {
	isNot = YES;
	return self;
}

-(BOOL)exist {
	return [self exist:@""];
}

-(BOOL)exist:(NSString *)appendToFailureMessage {
	if ((([query views].count > 0) && isNot) || (([query views].count == 0) && !isNot)) {
		[NSException raise:nil format:@"%@ should %@ %@", [query className], (isNot ? @"not exist" : @"exist"), appendToFailureMessage];
	}
	return YES;
}

-(UIExpectation *)have {
	isHave = YES;
	isBe = NO;
	return self;
}

-(UIExpectation *)be {
	isBe = YES;
	isHave = NO;
	return self;
}

-(void)have:(BOOL)condition {
	if ((!condition && !isNot) || (condition && isNot)) {
		[NSException raise:nil format:@"%@ did not pass condition: [%@ have:YES]", [query className], (isNot ? @"should not" : @"should")];
	}
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	NSMutableString *selector = NSStringFromSelector(aSelector);
	if (isBe) {
		NSMethodSignature *sig = [query methodSignatureForSelector:aSelector];
		if ([@"(null)" isEqualToString:[NSString stringWithFormat:@"%@", sig]]) {
			sig = [query methodSignatureForSelector:NSSelectorFromString([NSString stringWithFormat:@"is%@", [selector stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[selector substringWithRange:NSMakeRange(0,1)] uppercaseString]]])];
		}
		return sig;
	}
	if (isHave) {
		if (isNot) {
			[NSException raise:nil format:@"not isn't supported yet for something like [should.not.have foo:1]"];
		}
		NSString *selector = NSStringFromSelector(aSelector);
		NSRange whereIsSet = [selector rangeOfString:@":"];
		if (whereIsSet.length != 0) {
			return [NSMethodSignature signatureWithObjCTypes:"@@:@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"];
		}
	}
	return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	NSMutableString *selector = [NSMutableString stringWithString:NSStringFromSelector([anInvocation selector])];
	if (isBe) {
		if (![query respondsToSelector:[anInvocation selector]]) {
			[anInvocation setSelector:NSSelectorFromString([NSString stringWithFormat:@"is%@", [selector stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[selector substringWithRange:NSMakeRange(0,1)] uppercaseString]]])];
		}
		[anInvocation setTarget:query];
		[anInvocation invoke];
		NSString *returnType = [NSString stringWithFormat:@"%s", [[anInvocation methodSignature] methodReturnType]];
		if (![returnType isEqualToString:@"c"]) {
			[NSException raise:nil format:@"[%@ %@ be %@] is invalid. 'be' only works against selectors that return BOOL (YES or NO)", [query className], (isNot ? @"should not" : @"should"), selector];
		}
		BOOL value;
		[anInvocation getReturnValue:&value];
		if ((value == YES && isNot) || (value == NO && !isNot)) {
			[NSException raise:nil format:@"%@ did not pass condition: [%@ be %@]", [query className], (isNot ? @"should not" : @"should"), selector];
		}
	} else if (isHave) {
		NSArray *selectors = [selector componentsSeparatedByString:@":"];
		NSMutableString *errorMessage = [NSMutableString string];
		BOOL foundErrors = NO;
		for (UIView *view in [query targetViews]) {
			NSMutableArray *errors = [NSMutableArray array];
			int i = 2;
			id value = nil;
			for (NSString *key in selectors) {
				if (![key isEqualToString:@""]) {
					SEL selector = NSSelectorFromString(key);
					if (![view respondsToSelector:selector]) {
						[errors addObject:[NSString stringWithFormat:@"%@ doesn't respond to %@", [view class], key]];
						foundErrors = YES;
						continue;
					}
					[anInvocation getArgument:&value atIndex:i];
					NSString *returnType = [NSString stringWithFormat:@"%s", [[view methodSignatureForSelector:selector] methodReturnType]];
					if ([returnType isEqualToString:@"@"]) {
						if ([value isKindOfClass:[NSString class]]) {
							if ([[view performSelector:selector] rangeOfString:value].length == 0) {
								[errors addObject:[NSString stringWithFormat:@"%@ : \"%@\" doesn't contain \"%@\"", key, [view performSelector:selector], value]];
								foundErrors = YES;
								continue;
							}
						} else if (![[view performSelector:selector] isEqual:value]) {
							[errors addObject:[NSString	 stringWithFormat:@"%@ : %@ is not equal to %@", key, [view performSelector:selector], value]];
							foundErrors = YES;
							continue;
						}
					} else {
						if ([view performSelector:selector] != value) {
							[errors addObject:[NSString	 stringWithFormat:@"%@ is not equal to value", key]];
							foundErrors = YES;
							continue;
						}
					}
				}
			}
			if (foundErrors) {
				[errorMessage appendFormat:@"%@ should have %@ but %@\n", [view class], selector, errors];
			}
		}
		if (foundErrors) {
			[NSException raise:nil format:errorMessage];
		}
	}
}


-(void)dealloc {
	self.query = nil;
	[super dealloc];
}

@end
