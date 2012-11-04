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

//- (float)convertFromGraphCoordinateToPixel:(double)x
//{
//    
//}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 3.0);
    [[UIColor redColor]setStroke];
    
    CGFloat scale = 1;
    CGPoint origin;
    origin.x = self.bounds.origin.x + self.bounds.size.width/2;
    origin.y = self.bounds.origin.y + self.bounds.size.height/2;
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:origin scale:scale];

    CGPoint previous;
    previous.x = 0;
    previous.y = 0;
    
    CGContextBeginPath(context);
    
    for (float X = 0; X <= self.bounds.size.width; X++)
    {

        CGContextMoveToPoint(context, previous.x, previous.y);
        CGPoint point;
        point.x = X;
        

        /*
        convert X to graph coordinates (from pixel coordinates)
         */
        
        float Y = [self.dataSource forGraphView:self findYForX:X ];
        /*
         convert Y to pixel coordinates (from graph coordinates)
         */
        
        point.y = Y;
       //draw the line from previous point to new point
        CGContextAddLineToPoint(context, point.x, point.y);

        //reset previous to current point
        previous.x = point.x;
        previous.y = point.y;
    }
    
    
    CGContextSetLineWidth(context, 3.0);
    [[UIColor blueColor]setStroke];
    CGContextStrokePath(context);
}


@end
