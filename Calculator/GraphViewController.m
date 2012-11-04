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
@property (nonatomic) NSArray *program;
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@end

@implementation GraphViewController
@synthesize program = _program;
@synthesize graphView = _graphView;

-(void)setProgram:(NSArray *)program
{
    _program = program;
    
}

- (void)setGraphView:(GraphView *)graphView
{
    NSLog(@"setting graphView");
    _graphView = graphView;
}


/*You’ll need an IBOutlet in your new Controller to point to your graphing
 view for a variety of reasons. Your graphing view needs its data source
 delegate set, gesture recognizers added to it, and it needs to told that
 it needs to redraw itself when its data source delegate would provide
 different data if asked aga
*/

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

    self.programLabel.text = [CalculatorBrain descriptionOfProgram:self.program];
}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

@end
