//
//  GraphViewController.h
//  Calculator
//
//  Created by Rachel Bobbins on 11/3/12.
//
//

#import <UIKit/UIKit.h>

@interface GraphViewController : UIViewController
@property (nonatomic) NSArray *program;
@property (weak, nonatomic) IBOutlet UILabel *programLabel;
- (void)setProgram:(NSArray *)program;
@end
