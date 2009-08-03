
#import "UIQuery.h"
#import "objc/runtime.h"
#import "UIDescendants.h"
#import "UIChildren.h"
#import "UIParents.h"
#import "WaitUntilIdle.h"
#import "UIRedoer.h"

@implementation UIQuery

+(id)withApplicaton {
	return [self withViews:[NSMutableArray arrayWithObject:[UIApplication sharedApplication]] className:NSStringFromClass([UIApplication class])];
}

-(UITraversal *)find {
	return [self descendants];
}

-(UITraversal *)descendant {
	return [UIDescendants withViews:views className:className];
}

-(UITraversal *)child {
	return [UIChildren withViews:views className:className];
}

-(UITraversal *)parent {
	return [UIParents withViews:views className:className];
}

-(UIExpectation *)should {
	return [UIExpectation withQuery:self];
}

-(UIFilter *)with {
	return [UIFilter withQuery:self];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	if ([self respondsToSelector:aSelector]) {
		return [super methodSignatureForSelector:aSelector];
	}
	
	[self.should exist:[NSString stringWithFormat:@"before you can call %@", NSStringFromSelector(aSelector)]];
	NSString *selector = NSStringFromSelector(aSelector);
	
	//Check if any view responds directly to selector
	for (UIView *target in [self targetViews]) {
		if ([target respondsToSelector:aSelector]) {
			return [target methodSignatureForSelector:aSelector];
		}
	}
	
	//Check if any view responds as a property match
	NSArray *selectors = [selector componentsSeparatedByString:@":"];
	if (selectors.count == 2) {
		return [[self with] methodSignatureForSelector:aSelector];
	}
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	BOOL isDirect = NO;
	for (UIView *target in [self targetViews]) {
		if ([target respondsToSelector:[anInvocation selector]]) {
			[anInvocation invokeWithTarget:target];
			isDirect = YES;
		}
	}
	
	if (!isDirect) {
		[[self with] forwardInvocation:anInvocation];
	}
}

-(UIQuery *)flash {
	[self.should exist:@"before you can flash it"];
	for (UIView *view in [self targetViews]) {
		UIColor *tempColor = view.backgroundColor;
		for (int i=0; i<5; i++) {
			view.backgroundColor = [UIColor yellowColor];
			CFRunLoopRunInMode(kCFRunLoopDefaultMode, .05, false);
			view.backgroundColor = [UIColor blueColor];
			CFRunLoopRunInMode(kCFRunLoopDefaultMode, .05, false);
		}
		view.backgroundColor = tempColor;
	}
	return self;
}

-(UIQuery *)show {
	[self.should exist:@"before you can show it"];
	for (UIView *view in [self targetViews]) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		NSLog(@"Class = %@", [view class]);
		int i, propertyCount = 0;
		objc_property_t *propertyList = class_copyPropertyList([view class], &propertyCount);
		for (i=0; i<propertyCount; i++) {
			objc_property_t *thisProperty = propertyList + i;
			const char* propertyName = property_getName(*thisProperty);
			const char* propertyAttributes = property_getAttributes(*thisProperty);
			NSString *key = [NSString stringWithFormat:@"%s", propertyName];
			NSString *keyAttributes = [NSString stringWithFormat:@"%s", propertyAttributes];
			
			if ([view respondsToSelector:NSSelectorFromString(key)]) {
				id value = nil;
				if ([keyAttributes rangeOfString:@"T@"].length != 0) {
					value = [view performSelector:NSSelectorFromString(key)];
				} else {
					value = @"Need to get value for this key";
				}
				if (value == nil) {
					value = @"nil";
				}
				[dict setObject:value forKey:key];
			}
		}
		if ([dict allKeys].count > 0) {
			NSLog([dict description]);
		}
	}
	return self;
}

- (UIQuery *)touch {
	[self.should exist:@"before you can touch it"];
	
	for (UIView *view in [self targetViews]) {
		UITouch *touch = [[UITouch alloc] initInView:view];
		UIEvent *eventDown = [[NSClassFromString(@"UITouchesEvent") alloc] initWithTouch:touch];
		NSSet *touches = [[NSMutableSet alloc] initWithObjects:&touch count:1];
		
		[touch.view touchesBegan:touches withEvent:eventDown];
		
		UIEvent *eventUp = [[NSClassFromString(@"UITouchesEvent") alloc] initWithTouch:touch];
		[touch setPhase:UITouchPhaseEnded];
		
		[touch.view touchesEnded:touches withEvent:eventDown];
		
		[eventDown release];
		[eventUp release];
		[touches release];
		[touch release];
		[self wait:.25];
	}
	return [UIQuery withViews:views className:className];
}

-(NSString *)description {
	return [views description];
}

@end


@implementation UITouch (UIQuery)
//
// initInView:phase:
//
// Creats a UITouch, centered on the specified view, in the view's window.
// Sets the phase as specified.
//
- (id)initInView:(UIView *)view
{
	self = [super init];
	if (self != nil)
	{
		CGRect frameInWindow;
		if ([view isKindOfClass:[UIWindow class]])
		{
			frameInWindow = view.frame;
		}
		else
		{
			frameInWindow =
			[view.window convertRect:view.frame fromView:view.superview];
		}
		
		_tapCount = 1;
		_locationInWindow =
		CGPointMake(
					frameInWindow.origin.x + 0.5 * frameInWindow.size.width,
					frameInWindow.origin.y + 0.5 * frameInWindow.size.height);
		_previousLocationInWindow = _locationInWindow;
		
		UIView *target = [view.window hitTest:_locationInWindow withEvent:nil];
		
		_window = [view.window retain];
		_view = [target retain];
		_phase = UITouchPhaseBegan;
		_touchFlags._firstTouchForView = 1;
		_touchFlags._isTap = 1;
		_timestamp = [NSDate timeIntervalSinceReferenceDate];
	}
	return self;
}

//
// setPhase:
//
// Setter to allow access to the _phase member.
//
- (void)setPhase:(UITouchPhase)phase
{
	_phase = phase;
	_timestamp = [NSDate timeIntervalSinceReferenceDate];
}

//
// setPhase:
//
// Setter to allow access to the _locationInWindow member.
//
- (void)setLocationInWindow:(CGPoint)location
{
	_previousLocationInWindow = _locationInWindow;
	_locationInWindow = location;
	_timestamp = [NSDate timeIntervalSinceReferenceDate];
}

@end



@end
