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
- (double)performOperation:(NSString *)operation usingVariableValue:(NSNumber *)value;
- (void)clear;
- (void)pushVariable:(NSString *)variable;
- (void)removeLastObject;

@property (readonly) id program;

+ (double)runProgram:(id)program usingVariableValue:(NSNumber *)value;
+ (NSSet *)variablesUsedInProgram:(id)program;
+ (BOOL) isVariable:(id)object;
+ (BOOL) isOperation:(id)object;
+ (NSString *)descriptionOfProgram:(id)program;

@end
