//
//  UIQuery.m
//  Trypn
//
//  Created by Brian Knorr on 3/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIQuery.h"
#import "objc/runtime.h"
#import "UIQueryTableViewCell.h"
#import "UIQueryTableView.h"

@implementation UIQuery

static BOOL swizzleFiltersCalled;

@synthesize views, previousViews, viewFilterApplied, callCache, parentsMode, timeout;


+(id)withApplicaton {
	return [self withPreviousViews:nil viewFilterApplied:nil resultViews:[NSMutableArray arrayWithObject:[UIApplication sharedApplication]]];
}

+(id)withPreviousViews:(NSArray *)previousViews viewFilterApplied:(NSString *)viewFilterApplied resultViews:(NSMutableArray *)resultViews {
	return [[[self alloc] inithWithPreviousViews:previousViews viewFilterApplied:viewFilterApplied resultViews:resultViews] autorelease];
}

-(id)inithWithPreviousViews:(NSArray *)_previousViews viewFilterApplied:(NSString *)_viewFilterApplied resultViews:(NSMutableArray *)resultViews {
	[UIQuery swizzleFilters];
	if (self = [super init]) {
		self.timeout = 10;
		self.parentsMode = NO;
		self.previousViews = _previousViews;
		self.viewFilterApplied = _viewFilterApplied;
		self.views = resultViews;
		self.callCache = [[[CallCache alloc] init] autorelease];
	}
	return self;
}

+(void)swizzleFilters {
	if (!swizzleFiltersCalled) {
		//NSLog(@"swizzling filters");
		swizzleFiltersCalled = YES;
		NSArray *excludeKeys = [NSArray arrayWithObjects:@"timeout", @"parentsMode", @"parents", @"views", @"with", @"touch", @"previousViews", @"viewFilterApplied", @"should", @"callCache", nil];
		int i, propertyCount = 0;
		objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
		for (i=0; i<propertyCount; i++) {
			objc_property_t *thisProperty = propertyList + i;
			const char* propertyName = property_getName(*thisProperty);
			NSString *key = [NSString stringWithFormat:@"%s", propertyName];
			if (![excludeKeys containsObject:key]) {
				//NSLog(@"swizzling key = %@", key);
				//Method method = class_getInstanceMethod([self class], NSSelectorFromString(key));
//				method_setImplementation(method, method_getImplementation(class_getInstanceMethod([self class], @selector(templateFilter))));
				class_addMethod([self class], NSSelectorFromString(key), method_getImplementation(class_getInstanceMethod([self class], @selector(templateFilter))), "@@:");
			}
		}
	}
}

-(void)clearCache {
	[callCache clear];
}
		
-(UIQuery *)find {
	NSMutableArray *array = [NSMutableArray array];
	for (UIView *view in views) {
		[self doFindOnView:view inToArray:array];
	}
	return [UIQuery withPreviousViews:views viewFilterApplied:nil resultViews:array];
}

-(void)doFindOnView:(UIView *)view inToArray:(NSMutableArray *)array {
	NSArray *subViews = ([view isKindOfClass:[UIApplication class]]) ? [view windows] : [view subviews];
	for (UIView * v in subViews) {
		[array addObject:v];
	}
	for (UIView * v in subViews) {
		[self doFindOnView:v inToArray:array];
	}
}

-(UIQuery *)parents {
	id cachedResult = [callCache getForSelector:_cmd];
	if(cachedResult != nil) return cachedResult;
	
	NSMutableArray *array = [NSMutableArray array];
	for (UIView *v in views) {
		UIView *sv = v.superview;
		while (sv != nil) {
			[array addObject:sv];
			sv = sv.superview;
		}
	}
	UIQuery *query = [UIQuery withPreviousViews:views viewFilterApplied:nil resultViews:array];
	query.parentsMode = YES;
	return [callCache set:query forSelector:_cmd];
}

-(UIShould *)should {
	id cachedResult = [callCache getForSelector:_cmd];
	if(cachedResult != nil) return cachedResult;
	
	//NSLog(@"calling should");
	return [callCache set:[UIShould withQuery:self] forSelector:_cmd];
}

-(UIFilter *)with {
	id cachedResult = [callCache getForSelector:_cmd];
	if(cachedResult != nil) return cachedResult;
	
	return [callCache set:[UIFilter withQuery:self] forSelector:_cmd];
}

-(UIQuery *)timeout:(int)seconds {
	id cachedResult = [callCache getForSelector:_cmd];
	if(cachedResult != nil) return cachedResult;
	
	UIQuery *copy = [UIQuery withPreviousViews:previousViews viewFilterApplied:viewFilterApplied resultViews:views];
	copy.parentsMode = parentsMode;
	copy.timeout = seconds;
	return [callCache set:copy forSelector:_cmd];
}

-(id)templateFilter {
	NSString *viewName = NSStringFromSelector(_cmd);
	//NSLog(@"template filtering by %@", viewName);
	return [self view:[NSString stringWithFormat:@"UI%@", [viewName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[viewName substringWithRange:NSMakeRange(0,1)] uppercaseString]]]];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	NSString *selector = NSStringFromSelector(aSelector);
	//NSLog(@"uiquery method missing selector = %@", selector);
	
	for (UIView *target in views) {
		//NSLog(@"target = %@", target);
		if ([target respondsToSelector:aSelector]) {
			//NSLog(@"target view %@ reponds to = %@", target, selector);
			return [target methodSignatureForSelector:aSelector];
		}
	}
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	[self clearCache];
	//NSLog(@"uiquery forwardInvocation");
	for (UIView *target in views) {
		if ([target respondsToSelector:[anInvocation selector]]) {
			[anInvocation invokeWithTarget:target];
		}
	}
}

-(void)redo {
	//NSLog(@"doing redo");
	UIQuery *temp = [UIQuery withPreviousViews:nil viewFilterApplied:nil resultViews:previousViews];
	temp = [temp view:viewFilterApplied];
	self.views = temp.views;
}

-(UIQuery *)index:(int)index {
	id cachedResult = [callCache get:[NSString stringWithFormat:@"%@", NSStringFromSelector(_cmd)]];
	if(cachedResult != nil) return cachedResult;
	
	if (index >= views.count) {
		[NSException raise:nil format:@"%@ was not found at index %i", viewFilterApplied, index];
	}
	UIQuery *result = [UIQuery withPreviousViews:views viewFilterApplied:nil resultViews:[NSArray arrayWithObject:[views objectAtIndex:index]]];
	return [callCache set:result for:[NSString stringWithFormat:@"%@", NSStringFromSelector(_cmd)]];
}

-(UIView *)view {
	if (views.count == 0) {
		[NSException raise:nil format:@"%@ was not found", viewFilterApplied];
	}
	return [views objectAtIndex:0];
}

-(UIQuery *)view:(NSString *)className {
	id cachedResult = [callCache get:[NSString stringWithFormat:@"%@ %@", NSStringFromSelector(_cmd), className]];
	if(cachedResult != nil) return cachedResult;
	
	Class class = NSClassFromString(className);
	NSMutableArray *array = [NSMutableArray array];
	if (parentsMode) {
		for (UIView * v in views) {
			if ([v isKindOfClass:class]) {
				//NSLog(@"adding view %@", v);
				[array addObject:v];
			} 
		}
		UIQuery *result;
		if ([className isEqualToString:@"UITableViewCell"]) {
			result = [UIQueryTableViewCell withPreviousViews:previousViews viewFilterApplied:className resultViews:array];
		} else if ([className isEqualToString:@"UITableView"]) {
			result = [UIQueryTableView withPreviousViews:previousViews viewFilterApplied:className resultViews:array];
		} else {
			result = [UIQuery withPreviousViews:previousViews viewFilterApplied:className resultViews:array];
		}
		[callCache set:result for:[NSString stringWithFormat:@"%@ %@", NSStringFromSelector(_cmd), className]];
		return result;
	}
	
	NSDate *start = [NSDate date];
	UIQuery *query = nil;
	//NSLog(@"***Start****");
	while ([start timeIntervalSinceNow] > (0 - timeout)) {
		//NSLog(@"***Do Find****");
		[self wait:1.0];
		query = [self find];
		for (UIView * v in query.views) {
			//NSLog(@"checking view %@", v);
			if ([v isKindOfClass:class]) {
				//NSLog(@"adding view %@", v);
				[array addObject:v];
			} 
		}
		if (array.count > 0) {
			break;
		}
	}
	//NSLog(@"view classname find = %@", array);
	UIQuery *result;
	if ([className isEqualToString:@"UITableViewCell"]) {
		result = [UIQueryTableViewCell withPreviousViews:query.views viewFilterApplied:className resultViews:array];
	} else if ([className isEqualToString:@"UITableView"]) {
		result = [UIQueryTableView withPreviousViews:previousViews viewFilterApplied:className resultViews:array];
	}else {
		result = [UIQuery withPreviousViews:query.views viewFilterApplied:className resultViews:array];
	}
	[callCache set:result for:[NSString stringWithFormat:@"%@ %@", NSStringFromSelector(_cmd), className]];
	return result;
}

-(UIQuery *)flash {
	for (UIView *view in views) {
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
	for (UIView *view in views) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		//NSLog(@"Class = %@", [view className]);
		int i, propertyCount = 0;
		objc_property_t *propertyList = class_copyPropertyList([view class], &propertyCount);
		for (i=0; i<propertyCount; i++) {
			objc_property_t *thisProperty = propertyList + i;
			const char* propertyName = property_getName(*thisProperty);
			const char* propertyAttributes = property_getAttributes(*thisProperty);
			NSString *key = [NSString stringWithFormat:@"%s", propertyName];
			NSString *keyAttributes = [NSString stringWithFormat:@"%s", propertyAttributes];
			//NSLog(@"key = %@", key);
			//NSLog(@"attributes = %@", keyAttributes);
			
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
				//NSLog(@"value = %@", value);
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
	[self clearCache];
	
	for (UIView *view in views) {
		UITouch *touch = [[UITouch alloc] initInView:view];
		UIEvent *eventDown = [[UIEvent alloc] initWithTouch:touch];
		NSSet *touches = [[NSMutableSet alloc] initWithObjects:&touch count:1];
		
		[touch.view touchesBegan:touches withEvent:eventDown];
		
		UIEvent *eventUp = [[UIEvent alloc] initWithTouch:touch];
		[touch setPhase:UITouchPhaseEnded];
		
		[touch.view touchesEnded:touches withEvent:eventDown];
		
		[eventDown release];
		[eventUp release];
		[touches release];
		[touch release];
	}
	return self;
}

-(UIQuery *)wait:(double)seconds {
	CFRunLoopRunInMode(kCFRunLoopDefaultMode, seconds, false);
	return self;
}

-(NSString *)description {
	return [views description];
}

-(void)dealloc {
	self.views = nil;
	self.previousViews = nil;
	self.viewFilterApplied = nil;
	self.callCache = nil;
	[super dealloc];
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
		
		//NSLog(@"hit test target = %@", target);
		
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

//
// GSEvent is an undeclared object. We don't need to use it ourselves but some
// Apple APIs (UIScrollView in particular) require the x and y fields to be present.
//
@interface GSEventProxy : NSObject
{
@public
	int ignored1[5];
	float x;
	float y;
	int ignored2[24];
}
@end
@implementation GSEventProxy
@end

//
// PublicEvent
//
// A dummy class used to gain access to UIEvent's private member variables.
// If UIEvent changes at all, this will break.
//
@interface PublicEvent : NSObject
{
@public
    GSEventProxy           *_event;
    NSTimeInterval          _timestamp;
    NSMutableSet           *_touches;
    CFMutableDictionaryRef  _keyedTouches;
}
@end

@implementation PublicEvent
@end

//
// UIEvent (Synthesize)
//
// A category to allow creation of a touch event.
//
@implementation UIEvent (Synthesize)

- (id)initWithTouch:(UITouch *)touch
{
	self = [super init];
	if (self != nil)
	{
		PublicEvent *publicEvent = (PublicEvent *)self;
		publicEvent->_touches = [[NSMutableSet alloc] initWithObjects:&touch count:1];
		publicEvent->_timestamp = [NSDate timeIntervalSinceReferenceDate];
		
		CGPoint location = [touch locationInView:touch.window];
		
		publicEvent->_event = [[GSEventProxy alloc] init];
		publicEvent->_event->x = location.x;
		publicEvent->_event->y = location.y;
		
		CFMutableDictionaryRef dict =
		CFDictionaryCreateMutable(
								  kCFAllocatorDefault,
								  0,
								  &kCFTypeDictionaryKeyCallBacks,
								  &kCFTypeDictionaryValueCallBacks);
		
		//NSLog(@"dict = %@", dict);
		//		NSLog(@"touch.view = %@", touch.view);
		//		NSLog(@"publicEvent->_touches = %@", publicEvent->_touches);
		CFDictionaryAddValue(dict, touch.view, publicEvent->_touches);
		CFDictionaryAddValue(dict, touch.window, publicEvent->_touches);
		
		publicEvent->_keyedTouches = dict;
	}
	return self;
}

@end
