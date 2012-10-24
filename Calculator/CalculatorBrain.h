//
//  CalculatorBrain.h
//  Calculator
//
//  Created by PSI SCOPE on 10/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (void)setVariableValues:(NSDictionary *)variableValues;
- (void)clear;
- (void)pushVariable:(NSString *)variable;

@property (readonly) id program;

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (BOOL) isVariable:(id)object;
+ (NSString *)descriptionOfProgram:(id)program;

@end
