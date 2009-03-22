//
//  UISpec.h
//  UISpec
//
//  Created by Brian Knorr <brian.knorr@gmail.com>
//  Copyright(c) 2009 StarterStep, Inc., Some rights reserved.
//

@interface UISpec : NSObject {

}

+(void)runSpecsAfterDelay:(int)seconds;
+(void)runSpec:(NSString *)specName afterDelay:(int)seconds;
+(void)runSpec:(NSString *)specName example:(NSString *)exampleName afterDelay:(int)seconds;

@end

@protocol UISpec
@end

