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
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    self.brainDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}



- (IBAction)enterPressed { 
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self updateDisplays];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userIsInTheMiddleOfEnteringAFloat = NO;
}

- (IBAction)operationPressed:(id)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    
    [self.brain performOperation:operation usingVariableValues:self.testVariableValues];

    [self updateDisplays];
}


- (IBAction)variablePressed:(id)sender {
    NSString *var = [sender currentTitle];

    if (self.userIsInTheMiddleOfEnteringANumber) {
        return;
    }
    
    [self.brain pushVariable:var];
    [self updateDisplays];
    
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userIsInTheMiddleOfEnteringAFloat = NO;
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

    } else if ([test isEqualToString:@"Test 3"]) {
        self.testVariableValues = nil;
        self.varDisplay.text = @"No X/Y values set";
        return;
    } else {
       x = [NSNumber numberWithInt:0];
       y = [NSNumber numberWithInt:0];
    }
    
    NSArray *objs = [[NSArray alloc] initWithObjects:x, y, nil];

    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:objs forKeys:keys];
    self.testVariableValues = dict;
    [self updateDisplays];
}

- (IBAction)clear {
    [self testPressed:nil];
    
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userIsInTheMiddleOfEnteringAFloat = NO;
    [self.brain clear];
    [self updateDisplays];
}

- (IBAction)undo:(id)sender {
    NSString *currentDisplay = self.display.text;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        /*TODO: Figure out whether last digit entered is a decimal point.
         if yes, then after deleting it, user is no longer in the middle of entering a float*/
        
        
        self.display.text = [currentDisplay substringToIndex:[currentDisplay length] -1];
        
        if ([self.display.text isEqualToString:@""]) {
            [self updateDisplays];
            self.userIsInTheMiddleOfEnteringAFloat = NO;
            self.userIsInTheMiddleOfEnteringANumber = NO;
        } 
       
    } else {
        NSLog(@"program: %@", [self.brain program]);
        [self.brain removeLastObject];
        [self updateDisplays];
    }
}

- (void) updateDisplays {
    //program display
    self.brainDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    
    //variable display
    NSString *varDisp = @"";
    NSLog(@"vars used in program:%@", [CalculatorBrain variablesUsedInProgram:[self.brain program]]);
    
    /*TODO: Figure out why variables used in program isn't working*/
   for (NSString *var in [CalculatorBrain variablesUsedInProgram:[self.brain program]]) {
       NSLog(@"%@", varDisp);
       NSNumber *val = [self.testVariableValues objectForKey:var];
       varDisp = [varDisp stringByAppendingString:[NSString stringWithFormat:@"%@ = %@, ", var, val]];
   }
    
    self.varDisplay.text = varDisp;
    
    //result display
    double result = [CalculatorBrain runProgram:[self.brain program] usingVariableValues:self.testVariableValues];
    
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

@end
