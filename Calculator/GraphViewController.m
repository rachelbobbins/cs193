//
//  GraphViewController.m
//  Calculator
//
//  Created by Rachel Bobbins on 11/3/12.
//
//
#import "CalculatorBrain.h"
#import "GraphViewController.h"
#import "GraphView.h"

@interface GraphViewController () <GraphViewDataSource>
@property (nonatomic, weak) IBOutlet GraphView *graphView;
@end

@implementation GraphViewController
@synthesize program = _program;
@synthesize graphView = _graphView;

-(void)setProgram:(NSArray *)program
{
    _program = program;
    [self.graphView setNeedsDisplay];
    self.programLabel.text = [CalculatorBrain descriptionOfProgram:self.program];
}

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;

    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(jumpToNewOrigin:)];
    [doubleTap setNumberOfTapsRequired:2];
    
    [self.graphView addGestureRecognizer:doubleTap];
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(panToNewOrigin:)]];
    
    self.graphView.dataSource = self;
    self.programLabel.text = [CalculatorBrain descriptionOfProgram:self.program];
}

- (float)forGraphView:(GraphView *)sender findYForX:(float)x 
{
    return [CalculatorBrain runProgram:self.program usingVariableValue:[NSNumber numberWithFloat:x]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.programLabel.text = [CalculatorBrain descriptionOfProgram:self.program];

}
@end
