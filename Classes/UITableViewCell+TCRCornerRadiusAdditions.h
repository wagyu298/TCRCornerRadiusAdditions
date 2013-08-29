// This is free and unencumbered software released into the public domain.
// For more information, please refer to <http://unlicense.org/>

#import <UIKit/UIKit.h>
#import "TCRRoundRectCellBackgroundView.h"
#import "TCRRoundRectSelectedCellBackgroundView.h"

@interface UITableViewCell (TCRCornerRadiusAddtions)

@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat separatorHeight;
@property (nonatomic) UIColor *cellBackgroundColor;

- (void)configureCornerRadius;

- (void)setCornerRadius:(CGFloat)cornerRadius;
- (void)setSeparatorHeight:(CGFloat)separatorHeight;
- (void)setCellBackgroundColor:(UIColor *)cellBackgroundColor;

@end
