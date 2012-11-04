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

@end

@interface GraphView : UIView

@property (nonatomic) CGPoint origin;

@end
