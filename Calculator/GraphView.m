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

    //beginning of line
    CGPoint previous;
    previous.x = self.bounds.size.width/2.0 - origin.x;
    previous.y = -1 * [self.dataSource forGraphView:self findYForX:0.0] + self.bounds.size.height /2.0;
    
    CGContextBeginPath(context);
    
    for (float x_point = 1; x_point <= self.bounds.size.width; x_point++)
    {

        CGContextMoveToPoint(context, previous.x, previous.y);
        
        //convert x_point (in pixel coordinates) to graph coordinates, find y, convert to pixel system
        float x = x_point/self.pointsPerUnit - self.bounds.size.width/(2.0 * self.pointsPerUnit);
        float y = [self.dataSource forGraphView:self findYForX:x]; //y in graph coordinates
        float y_point = -y/self.pointsPerUnit + self.bounds.size.height/(2.0 * self.pointsPerUnit);
        
       //draw the line from previous point to new point
        CGContextAddLineToPoint(context, x_point, y_point);

        //reset previous to current point
        previous.x = x_point;
        previous.y = y_point;
    }
    
    
    CGContextSetLineWidth(context, 3.0);
    [[UIColor blueColor]setStroke];
    CGContextStrokePath(context);
}


@end
