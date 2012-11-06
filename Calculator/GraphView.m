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
        _origin.x = self.bounds.origin.x + self.bounds.size.width/2;
        _origin.y = self.bounds.origin.y + self.bounds.size.height/2;
    }
    return _origin;
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
    if ((origin.x != _origin.x) || (origin.y != _origin.y)) {
        _origin = origin;
        [self setNeedsDisplay];
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        [self setPointsPerUnit:(self.pointsPerUnit *= gesture.scale)];
        gesture.scale = 1;
    }
}

- (void)jumpToNewOrigin:(UIGestureRecognizer *)gesture
{
    CGPoint newOrigin = [gesture locationInView:self];
    [self setOrigin:newOrigin];
}

- (void)panToNewOrigin:(UIPanGestureRecognizer *)gesture
{
    if((gesture.state == UIGestureRecognizerStateChanged) ||
       (gesture.state == UIGestureRecognizerStateEnded))
    {
        CGPoint translation = [gesture translationInView:self];
        
        CGPoint newOrigin;
        newOrigin.x = self.origin.x + translation.x;
        newOrigin.y = self.origin.y + translation.y;
        [gesture setTranslation:(CGPointMake(0.0, 0.0)) inView:self];
        [self setOrigin:newOrigin];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //draw the axes
    CGContextSetLineWidth(context, 3.0);
    [[UIColor redColor]setStroke];
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.pointsPerUnit];

    //draw the graph
    CGPoint previous;
    for (float x_point = 0; x_point <= self.bounds.size.width; x_point++)
    {
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
