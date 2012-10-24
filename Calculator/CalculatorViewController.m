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
@end

@implementation CalculatorViewController

@synthesize display;
@synthesize brainDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize userIsInTheMiddleOfEnteringAFloat;
@synthesize brain = _brain;

int brainDisplayLength = 0;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    
    NSString *digit = [sender currentTitle];
    
    // if user enters a decimal for first time
    if ([digit isEqualToString:@"."] && !self.userIsInTheMiddleOfEnteringAFloat) {
        self.userIsInTheMiddleOfEnteringAFloat = YES;
    } 
    
    // user can't add another decimal point
    else if ([digit isEqualToString:@"."] && self.userIsInTheMiddleOfEnteringAFloat) {
        return;
    }
    
    // append digit to current text
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
        
        // limit brainDisplay to 30 characters
        if (brainDisplayLength < 30) {
            self.brainDisplay.text = [self.brainDisplay.text stringByAppendingString:digit];
            brainDisplayLength += [digit length];
        }

    } 
    
    // current digit replaces current text
    else {
        self.display.text = digit;
        
        // limit brainDisplay to 30 characters
        if (brainDisplayLength < 30) {
            self.brainDisplay.text = [self.brainDisplay.text stringByAppendingString:digit];
            brainDisplayLength += [digit length];
        }

        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}



- (IBAction)enterPressed {
    // add a space after each digit is entered
    if (brainDisplayLength < 30) {
        self.brainDisplay.text = [self.brainDisplay.text stringByAppendingString:@" "];
        brainDisplayLength += 1;
    }
    
    // pressing Enter after pi puts it on the stack twice b/c it's an operation
//    if ([NSNumberFormatterNoStyle numberFromString:self.display.text])
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userIsInTheMiddleOfEnteringAFloat = NO;
}

- (IBAction)operationPressed:(id)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    
    double result = [self.brain performOperation:operation];
    
    // limit brainDisplay to 30 characters
    if (brainDisplayLength < 30) {
        self.brainDisplay.text = [self.brainDisplay.text stringByAppendingString:operation];
        brainDisplayLength += [operation length];
    }
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    // add a space after each operation is entered
    if (brainDisplayLength < 30) {
        self.brainDisplay.text = [self.brainDisplay.text stringByAppendingString:@" "];
        brainDisplayLength += 1;
    }

}


- (IBAction)variablePressed:(id)sender {
    NSString *var = [sender currentTitle];
    
    // append digit to current text
    if (self.userIsInTheMiddleOfEnteringANumber) {
        return;
        
    } 
    
    // current digit replaces current text
    else {
        self.display.text = var;
        
        // limit brainDisplay to 30 characters
        if (brainDisplayLength < 30) {
            self.brainDisplay.text = [self.brainDisplay.text stringByAppendingString:var];
            self.brainDisplay.text = [self.brainDisplay.text stringByAppendingString:@" "];
            brainDisplayLength += [var length];
        }

        [self.brain pushVariable:var];
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
    NSLog(@"getting passed to set variables: %@", dict);
    [self.brain setVariableValues:dict];
}

- (IBAction)clear {
    self.display.text = @"0";
    self.brainDisplay.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userIsInTheMiddleOfEnteringAFloat = NO;
    brainDisplayLength = 0;
    [self.brain clear];
}

@end
