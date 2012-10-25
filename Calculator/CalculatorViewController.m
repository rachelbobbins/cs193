//
//  CalculatorViewController.m
//  Calculator
//
//  Created by PSI SCOPE on 10/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h" 

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringAFloat;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic) NSDictionary *testVariableValues;
@end

@implementation CalculatorViewController

@synthesize display;
@synthesize brainDisplay;
@synthesize varDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize userIsInTheMiddleOfEnteringAFloat;
@synthesize testVariableValues;
@synthesize brain = _brain;

int brainDisplayLength = 0;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    
    NSString *digit = [sender currentTitle];
    
    // can only have 1 decimal point per number; no ip addresses
    if ([digit isEqualToString:@"."] && !self.userIsInTheMiddleOfEnteringAFloat) {
        self.userIsInTheMiddleOfEnteringAFloat = YES;
    } else if ([digit isEqualToString:@"."] && self.userIsInTheMiddleOfEnteringAFloat)
    {
        return;
    }
    
    // append digit to current text
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } 
    
    // current digit replaces current text
    else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    self.brainDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}



- (IBAction)enterPressed { 
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.brainDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userIsInTheMiddleOfEnteringAFloat = NO;
}

- (IBAction)operationPressed:(id)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    
    [self.brain pushVariableValues: [self testVariableValues]];
    double result = [self.brain performOperation:operation];


    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.brainDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];

}


- (IBAction)variablePressed:(id)sender {
    NSString *var = [sender currentTitle];
    
    // do nothing
    if (self.userIsInTheMiddleOfEnteringANumber) {
        return;
    } 
    
    // current digit replaces current text
    else {
        self.display.text = var;
        
        [self.brain pushVariable:var];
        self.brainDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
        self.userIsInTheMiddleOfEnteringANumber = NO;
        self.userIsInTheMiddleOfEnteringAFloat = NO;
    }
    
}

- (IBAction)testPressed:(id)sender {
    NSString *test = [sender currentTitle];
    
    NSArray *keys = [[NSArray alloc] initWithObjects:@"X", @"Y", nil];
    NSNumber *x;
    NSNumber *y;
    
    if ([test isEqualToString:@"Test 1"]) {
        x = [NSNumber numberWithInt:5];
        y = [NSNumber numberWithInt:3];

    } else if ([test isEqualToString:@"Test 2"]) {
       x = [NSNumber numberWithInt:-6];
       y = [NSNumber numberWithInt:4];

    } else {
       x = [NSNumber numberWithInt:0];
       y = [NSNumber numberWithInt:0];
    }
    NSArray *objs = [[NSArray alloc] initWithObjects:x, y, nil];

    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:objs forKeys:keys];
    
    self.varDisplay.text = [NSString stringWithFormat:@"X = %@, Y = %@", x, y];
    self.testVariableValues = dict;
}

- (IBAction)clear {
    self.display.text = @"0";
    self.brainDisplay.text = @"";
    
    [self testPressed:nil];
    
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userIsInTheMiddleOfEnteringAFloat = NO;
    brainDisplayLength = 0;
    [self.brain clear];
}

@end
