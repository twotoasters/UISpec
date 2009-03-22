#import "UISpec.h"
#import "objc/runtime.h"

@implementation UISpec

+(void)runSpecsAfterDelay:(int)seconds {
	[NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(runSpecs) userInfo:nil repeats:NO];
}

+(void)runSpec:(NSString *)specName afterDelay:(int)seconds {
	[NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(runSpec:) userInfo:specName repeats:NO];
}

+(void)runSpec:(NSString *)specName example:(NSString *)exampleName afterDelay:(int)seconds {
	[NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(runSpecExample:) userInfo:[NSArray arrayWithObjects:specName, exampleName, nil] repeats:NO];
}

+(void)runSpecs {
	NSArray *specClasses = [self specClasses];
	[self runSpecClasses:specClasses];
}

+(void)runSpec:(NSTimer *)timer {
	Class *class = NSClassFromString(timer.userInfo);
	[self runSpecClasses:[NSArray arrayWithObject:class]];
}

+(void)runSpecExample:(NSTimer *)timer {
	Class *class = NSClassFromString([timer.userInfo objectAtIndex:0]);
	NSString *exampleName = [timer.userInfo objectAtIndex:1];
	NSMutableArray *errors = [NSMutableArray array];
	NSDate *start = [NSDate date];
	[self runExamples:[NSArray arrayWithObject:exampleName] onSpec:class errors:errors];
	[self logSpec:errors finishTime:[NSString stringWithFormat:@"%f", fabsf([start timeIntervalSinceNow])] examplesCount:@"1"];
}

+(void)runSpecClasses:(NSArray *)specClasses {
	//NSLog(@"specClasses = %@", specClasses);
	if (specClasses.count == 0) return;
	
	NSMutableArray *errors = [NSMutableArray array];
	
	NSDate *start = [NSDate date];
	int examplesCount = 0;
	for (Class *class in specClasses) {
		NSArray *examples = [self examplesForSpecClass:class];
		//NSLog(@"examples = %@", examples);
		if (examples.count == 0) continue;
		examplesCount = examplesCount + examples.count;
		[self runExamples:examples onSpec:class errors:errors];
	}
	[self logSpec:errors finishTime:[NSString stringWithFormat:@"%f", fabsf([start timeIntervalSinceNow])] examplesCount:[NSString stringWithFormat:@"%i", examplesCount]];
}

+(void)logSpec:(NSArray *)errors finishTime:(NSString *)finishTime examplesCount:(NSString *)examplesCount {
	NSMutableString *log = [NSMutableString string];
	if (errors.count > 0) {
		int count = 0;
		for (NSString *error in errors) {
			[log appendFormat:@"\n\n%i)", ++count];
			[log appendFormat:@"\n%@", error];
		}
	}
	[log appendFormat:@"\n\nFinished in %@ seconds", finishTime];
	
	[log appendFormat:@"\n\n%@ examples %i failures", examplesCount, errors.count];
	NSLog(log);
}

+(void)runExamples:(NSArray *)examples onSpec:(Class *)class errors:(NSMutableArray *)errors {
	
	UISpec *spec = [[[class alloc] init] autorelease];
	if ([spec respondsToSelector:@selector(beforeAll)]) {
		@try {
			[spec beforeAll];
		} @catch (NSException *exception) {
			NSString *error = [NSString stringWithFormat:@"%@ in %@ beforeAll \n %@", exception.name, class, exception.reason];
			[errors addObject:error];
		}
	}
	for (NSString *exampleName in examples) {
		if ([spec respondsToSelector:@selector(before)]) {
			@try {
				[spec before];
			} @catch (NSException *exception) {
				NSString *error = [NSString stringWithFormat:@"%@ in %@ before %@ \n %@", exception.name, class, exampleName, exception.reason];
				[errors addObject:error];
			}
		}
		@try {
			[spec performSelector:NSSelectorFromString(exampleName)];
		} @catch (NSException *exception) {
			NSString *error = [NSString stringWithFormat:@"%@ %@ FAILED \n%@", class, exampleName, exception.reason];
			[errors addObject:error];
		}
		if ([spec respondsToSelector:@selector(after)]) {
			@try {
				[spec after];
			} @catch (NSException *exception) {
				NSString *error = [NSString stringWithFormat:@"%@ in %@ after %@ \n %@", exception.name, class, exampleName, exception.reason];
				[errors addObject:error];
			}
		}
	}
	if ([spec respondsToSelector:@selector(afterAll)]) {
		@try {
			[spec afterAll];
		} @catch (NSException *exception) {
			NSString *error = [NSString stringWithFormat:@"%@ in %@ afterAll \n %@", exception.name, class, exception.reason];
			[errors addObject:error];
		}
	}
}

+(NSArray *)examplesForSpecClass:(Class *)specClass {
	NSMutableArray *array = [NSMutableArray array];
	unsigned int methodCount;
	Method *methods = class_copyMethodList(specClass, &methodCount);
	for (size_t i = 0; i < methodCount; ++i) {
		Method method = methods[i];
		SEL selector = method_getName(method);
		NSString *selectorName = NSStringFromSelector(selector);
		if ([selectorName hasPrefix:@"it"]) {
			[array addObject:selectorName];
		}
	}
	return array;
}

+(BOOL)isASpec:(Class)class {
	//Class spec = NSClassFromString(@"UISpec");
	while (class) {
		if (class_conformsToProtocol(class, NSProtocolFromString(@"UISpec"))) {
			return YES;
		}
		class = class_getSuperclass(class);
	}
	return NO;
}


+(NSArray*)specClasses {
	NSMutableArray *array = [NSMutableArray array];
    int numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0) {
        Class *classes = malloc(sizeof(Class) * numClasses);
        (void) objc_getClassList (classes, numClasses);
        int i;
        for (i = 0; i < numClasses; i++) {
            Class *c = classes[i];
			if ([self isASpec:c]) {
				[array addObject:c];
			}
        }
        free(classes);
    }
	return array;
}

//-(void)swizzleUIKit {	
//	class_addMethod([UIView class], @selector(methodSignatureForSelector:), method_getImplementation(class_getInstanceMethod([UISpec class], @selector(methodSignatureForSelector:))), "@@:@");
//	class_addMethod([UIView class], @selector(forwardInvocation:), method_getImplementation(class_getInstanceMethod([UISpec class], @selector(forwardInvocation:))), "v@:@");
//	class_addMethod([UIView class], @selector(traverse:class:properties:), method_getImplementation(class_getInstanceMethod([UISpec class], @selector(traverse:class:properties:))), "@@:@@@");
//	class_addMethod([UIView class], @selector(touch), method_getImplementation(class_getInstanceMethod([UISpec class], @selector(touch))), "v@:");
//	class_addMethod([UIApplication class], @selector(methodSignatureForSelector:), method_getImplementation(class_getInstanceMethod([UISpec class], @selector(methodSignatureForSelector:))), "@@:@");
//	class_addMethod([UIApplication class], @selector(forwardInvocation:), method_getImplementation(class_getInstanceMethod([UISpec class], @selector(forwardInvocation:))), "v@:@");
//	class_addMethod([UIApplication class], @selector(traverse:class:properties:), method_getImplementation(class_getInstanceMethod([UISpec class], @selector(traverse:class:properties:))), "@@:@@@");
//}

+(void)swizzleMethodOnClass:(Class)targetClass originalSelector:(SEL)originalSelector fromClass:(Class)fromClass alternateSelector:(SEL)alternateSelector {
    Method originalMethod = nil, alternateMethod = nil;
	
    // First, look for the methods
    originalMethod = class_getInstanceMethod(targetClass, originalSelector);
    alternateMethod = class_getInstanceMethod(fromClass, alternateSelector);
    
    // If both are found, swizzle them
    if (originalMethod != nil && alternateMethod != nil) {
		IMP originalImplementation = method_getImplementation(originalMethod);
		IMP alternateImplementation = method_getImplementation(alternateMethod);
		method_setImplementation(originalMethod, alternateImplementation);
		method_setImplementation(alternateMethod, originalImplementation);
	}
}

@end