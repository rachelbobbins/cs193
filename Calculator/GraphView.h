//
//  GraphView.h
//  Calculator
//
//  Created by Rachel Bobbins on 11/3/12.
//
//

#import <UIKit/UIKit.h>
@class GraphView;

@protocol GraphViewDataSource
- (float)forGraphView:(GraphView *)sender findYForX:(float)x;
@end

@interface GraphView : UIView

@property (nonatomic) CGPoint origin;
@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;

@end
