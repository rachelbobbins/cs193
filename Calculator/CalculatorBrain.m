//
//  CalculatorBrain.m
//  Calculator
//
//  Created by PSI SCOPE on 10/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain() 
@property (nonatomic, strong) NSMutableArray *programStack;
@property (nonatomic, strong) NSDictionary *variableValues;
@end

@implementation CalculatorBrain;

@synthesize programStack = _programStack;


- (NSMutableArray *)programStack
{
    if (_programStack == nil) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

-(void)pushOperand:(double)operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}

- (void)pushVariable:(NSString *)variable
{
    [self.programStack addObject:variable];
}


-(double)performOperation:(NSString *)operation usingVariableValues:(NSDictionary *)variableValues
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program usingVariableValues:variableValues];
    
}

-(void)removeLastObject
{
    [self.programStack removeLastObject];
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    NSString *result = @"";
    if ([program isKindOfClass:[NSArray class]]) {
       stack = [program mutableCopy];
    }
    
    while ([stack count] > 0) {
        result = [[self descriptionOfTopOfStack:stack] stringByAppendingString:result];
        if ([stack count] > 0) {
            result = [@", " stringByAppendingString:result];
        }
    }
    return result;
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack
{
    NSString *result;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    //1, a, or pi
    if ([topOfStack isKindOfClass:[NSNumber class]] || [CalculatorBrain isVariable:topOfStack] || [topOfStack isEqualToString:@"pi"]) {
        result = [NSString stringWithFormat:@"%@", topOfStack];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        
        //a + b
        if ([CalculatorBrain isOperation:topOfStack]) {
            NSString *op1 = [self descriptionOfTopOfStack:stack];
            NSString *op2 = [self descriptionOfTopOfStack:stack];
            
            if ([topOfStack isEqualToString:@"*"] || [topOfStack isEqualToString:@"/"]){
                result = [NSString stringWithFormat:@"%@ %@ %@", op2, topOfStack, op1];
            }else {
                result = [NSString stringWithFormat:@"(%@ %@ %@)", op2, topOfStack, op1];
            }
        }
        // sin(a)
        else {
            result = [NSString stringWithFormat:@"%@(%@)", topOfStack, [self descriptionOfTopOfStack:stack]];
        }

    }
    return result;
}


+ (double)popOperandOffStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
         if ([operation isEqualToString:@"+"]) {
             result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
         } else if ([@"*" isEqualToString:operation]) {
             result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
         } else if ([operation isEqualToString:@"-"]) {
             double subtrahend = [self popOperandOffStack:stack];
             result = [self popOperandOffStack:stack] - subtrahend;
         } else if ([operation isEqualToString:@"/"]) {
             double divisor = [self popOperandOffStack:stack];
             if (divisor) result = [self popOperandOffStack:stack] / divisor;
         } else if ([operation isEqualToString:@"sin"]) {
             result = sin([self popOperandOffStack:stack]);
         } else if ([operation isEqualToString:@"cos"]) {
             result = cos([self popOperandOffStack:stack]);
         } else if ([operation isEqualToString:@"sqrt"]) {
             result = sqrt([self popOperandOffStack:stack]);
         } else if ([operation isEqualToString:@"pi"]) {
             result = 3.14159;
         } 
    }
    
    return result;
}



+ (double) runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    for (int i=0; i<[stack count]; i++) {
        id key = [stack objectAtIndex:i];
        BOOL isVariable = [CalculatorBrain isVariable:key];

        id value = [variableValues objectForKey:key];

        if (isVariable && [value isKindOfClass:[NSNumber class]]) {
            [stack replaceObjectAtIndex:i withObject:value];
        } else if (isVariable && value == nil) {
            [stack replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
        }
    }
    
    return [self popOperandOffStack:stack];
}

+ (BOOL) isVariable:(id)object
{
    NSSet *ops = [NSSet setWithObjects:@"+", @"*", @"-", @"/", @"sin", @"cos", @"sqrt", @"pi", nil];
    return ([object isKindOfClass:[NSString class]] && ![ops containsObject:object]);
}

+ (BOOL) isOperation:(id)object
{
        NSSet *ops = [NSSet setWithObjects:@"+", @"*", @"-", @"/", nil];
        return ([ops containsObject:object]);
}


+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSMutableArray *vars = [[NSMutableArray alloc] init];

    for (int i=0; i<[program count]; i++) {
        id key = [program objectAtIndex:i];
        if ([CalculatorBrain isVariable:key]) {
            [vars addObject:key];
        }
    }
    return [NSSet setWithArray:vars];

}

-(void)clear
{
    [self.programStack removeAllObjects];
}

@end
