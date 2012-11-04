//
//  GraphView.m
//  Calculator
//
//  Created by Rachel Bobbins on 11/3/12.
//
//

#import "GraphView.h"
#import "AxesDrawer.h"

@interface GraphView()
//@property (nonatomic, weak) IBOutlet FaceView *faceView;
@end


@implementation GraphView
- (void)setup
{
    self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
    NSLog(@"setting up graph view");
}

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"initializing graph view");
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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 5.0);
    [[UIColor blueColor]setStroke];
    
    CGFloat scale = 1;
    CGPoint origin;
    origin.x = self.bounds.origin.x + self.bounds.size.width/2;
    origin.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:origin scale:scale];
}


@end
