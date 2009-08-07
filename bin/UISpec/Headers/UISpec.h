//
//  UISpec.h
//  UISpec
//
//  Created by Brian Knorr <btknorr@gmail.com>
//  Copyright(c) 2009 StarterStep, Inc., Some rights reserved.
//
#import "ViewFilterSwizzler.h"
#import "UIQuery.h"
#import "UIFilter.h"
#import "UIExpectation.h"

@interface UISpec : NSObject {

}

+(void)runSpecsAfterDelay:(int)seconds;
+(void)runSpec:(NSString *)specName afterDelay:(int)seconds;
+(void)runSpec:(NSString *)specName example:(NSString *)exampleName afterDelay:(int)seconds;

@end

@protocol UISpec
@end

