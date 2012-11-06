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
@synthesize origin = _origin;

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

- (CGPoint)origin
{
    if (!_origin.x || !_origin.y) {
        NSLog(@"%f, %f", self.bounds.origin.x, self.bounds.size.width);
        _origin.x = self.bounds.origin.x + self.bounds.size.width/2;
        _origin.y = self.bounds.origin.y + self.bounds.size.height/2;
    }
    return _origin;
//    }
}

-(void)setPointsPerUnit:(CGFloat)pointsPerUnit
{
    if (pointsPerUnit != _pointsPerUnit) {
        _pointsPerUnit = pointsPerUnit;
        [self setNeedsDisplay]; // any time our scale changes, call for redraw
    }
}

- (void)setOrigin:(CGPoint)origin
{
    NSLog(@"called set origin");
    if ((origin.x != _origin.x) || (origin.y != _origin.y)) {
        _origin = origin;
        [self setNeedsDisplay];
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

- (void)moveOrigin:(UITapGestureRecognizer *)gesture;
{
    CGPoint newOrigin = [gesture locationInView:self];
    NSLog(@"%f, %f", newOrigin.x, newOrigin.y);
    [self setOrigin:newOrigin];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //draw the axes
    CGContextSetLineWidth(context, 3.0);
    [[UIColor redColor]setStroke];
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.pointsPerUnit];


    CGPoint previous;
    for (float x_point = 0; x_point <= self.bounds.size.width; x_point++)
    {
        /*referred to http://ipadiphoneprogramming.blogspot.com/2012/04/assignment-3-part-1-stanford-university.html
        for help with scaling factors*/
        
        float x = x_point/self.pointsPerUnit - self.origin.x/self.pointsPerUnit;
        float y = [self.dataSource forGraphView:self findYForX:x]; 
        float y_point = (-y)*self.pointsPerUnit +  self.origin.y;

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
