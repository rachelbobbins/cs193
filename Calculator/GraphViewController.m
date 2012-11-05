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
}

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    
    self.programLabel.text = [CalculatorBrain descriptionOfProgram:self.program];
    self.graphView.dataSource = self;
}

- (float)forGraphView:(GraphView *)sender findYForX:(float)x 
{
    return [CalculatorBrain runProgram:self.program usingVariableValue:[NSNumber numberWithFloat:x]];
}


//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
- (void)viewDidLoad
{
    [super viewDidLoad];

}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

@end
