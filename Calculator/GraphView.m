//
//  GraphView.m
//  Calculator
//
//  Created by Rachel Bobbins on 11/3/12.
//
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize dataSource = _dataSource;
@synthesize pointsPerUnit = _pointsPerUnit;

#define DEFAULT_POINTSPERUNIT 1;
- (void)setup
{
    self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)awakeFromNib
{
    [self setup];
}

- (CGFloat)pointsPerUnit
{
    if (!_pointsPerUnit) {
        return DEFAULT_POINTSPERUNIT;
    } else {
        return _pointsPerUnit;
    }
}

-(void)setPointsPerUnit:(CGFloat)pointsPerUnit
{
    if (pointsPerUnit != _pointsPerUnit) {
        _pointsPerUnit = pointsPerUnit;
        [self setNeedsDisplay]; // any time our scale changes, call for redraw
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture;
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        [self setPointsPerUnit:(self.pointsPerUnit *= gesture.scale)]; // adjust our scale
        gesture.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //draw the axes
    CGContextSetLineWidth(context, 3.0);
    [[UIColor redColor]setStroke];
    
    CGPoint origin;
    origin.x = self.bounds.origin.x + self.bounds.size.width/2;
    origin.y = self.bounds.origin.y + self.bounds.size.height/2;
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:origin scale:self.pointsPerUnit];


    CGPoint previous;
    for (float x_point = 0; x_point <= self.bounds.size.width; x_point++)
    {
        /*referred to http://ipadiphoneprogramming.blogspot.com/2012/04/assignment-3-part-1-stanford-university.html
        for help with scaling factors*/
        
        float x = x_point/self.pointsPerUnit - self.bounds.size.width/(2.0 * self.pointsPerUnit);
        float y = [self.dataSource forGraphView:self findYForX:x]; 
        float y_point = -y*self.pointsPerUnit + self.bounds.size.height/(2.0);

        if (x_point == 0) {
            CGContextBeginPath(context);
        } else {
            CGContextMoveToPoint(context, previous.x, previous.y);
            CGContextAddLineToPoint(context, x_point, y_point);
        }
        
        //reset previous to current point
        previous.x = x_point;
        previous.y = y_point;
    }
    
    
    CGContextSetLineWidth(context, 2.0);
    [[UIColor blueColor]setStroke];
    CGContextStrokePath(context);
}


@end
