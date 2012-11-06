//
//  CalculatorViewController.m
//  Calculator
//
//  Created by PSI SCOPE on 10/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"
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
    [self.brain performOperation:operation usingVariableValue:nil];
//    [self.brain performOperation:operation usingVariableValues:self.testVariableValues];
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


- (IBAction)clear {
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userIsInTheMiddleOfEnteringAFloat = NO;
    [self.brain clear];
    [self updateDisplays];
}

- (IBAction)undo:(id)sender {
    NSString *currentDisplay = self.display.text;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if ([currentDisplay hasSuffix:@"."]) self.userIsInTheMiddleOfEnteringAFloat = NO;
        
        self.display.text = [currentDisplay substringToIndex:[currentDisplay length] -1];
        
        if ([self.display.text isEqualToString:@""]) {
            [self updateDisplays];
            self.userIsInTheMiddleOfEnteringANumber = NO;
        } 
       
    } else {
        [self.brain removeLastObject];
        [self updateDisplays];
    }
}

- (void) updateDisplays {
    //program display
    self.brainDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    
    //result display
    double result = [CalculatorBrain runProgram:[self.brain program] usingVariableValue:nil];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToGraphView"]) {
        GraphViewController *newController = [segue destinationViewController];
        [newController setProgram:[self.brain program]];
    }
}

- (IBAction)showGraph
{
    [self performSegueWithIdentifier:@"segueToGraphView" sender:self];
}
@end
