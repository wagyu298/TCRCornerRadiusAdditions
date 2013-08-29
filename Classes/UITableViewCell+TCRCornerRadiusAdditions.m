// This is free and unencumbered software released into the public domain.
// For more information, please refer to <http://unlicense.org/>

#import "UITableViewCell+TCRCornerRadiusAdditions.h"

@implementation UITableViewCell (TCRCornerRadiusAddtions)

@dynamic cornerRadius;
@dynamic separatorHeight;
@dynamic cellBackgroundColor;

- (void)configureCornerRadius
{
    TCRRoundRectCellBackgroundView *backgroundView = [[TCRRoundRectCellBackgroundView alloc] init];
    self.backgroundView = backgroundView;
    
    backgroundView = [[TCRRoundRectSelectedCellBackgroundView alloc] init];
    self.selectedBackgroundView = backgroundView;
    
    self.textLabel.backgroundColor = [UIColor clearColor];
    if ([self respondsToSelector:@selector(detailTextLabel)]) {
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if ([self.backgroundView isKindOfClass:[TCRRoundRectCellBackgroundView class]]) {
        [(TCRRoundRectCellBackgroundView *)self.backgroundView setCornerRadius:cornerRadius];
    }
    if ([self.selectedBackgroundView isKindOfClass:[TCRRoundRectCellBackgroundView class]]) {
        [(TCRRoundRectCellBackgroundView *)self.selectedBackgroundView setCornerRadius:cornerRadius];
    }
}

- (void)setSeparatorHeight:(CGFloat)separatorHeight
{
    if ([self.backgroundView isKindOfClass:[TCRRoundRectCellBackgroundView class]]) {
        [(TCRRoundRectCellBackgroundView *)self.backgroundView setSeparatorHeight:separatorHeight];
    }
    if ([self.selectedBackgroundView isKindOfClass:[TCRRoundRectCellBackgroundView class]]) {
        [(TCRRoundRectCellBackgroundView *)self.selectedBackgroundView setSeparatorHeight:separatorHeight];
    }
}

- (void)setCellBackgroundColor:(UIColor *)cellBackgroundColor
{
    if ([self.backgroundView isKindOfClass:[TCRRoundRectCellBackgroundView class]]) {
        [(TCRRoundRectCellBackgroundView *)self.backgroundView setCellBackgroundColor:cellBackgroundColor];
    }
    if ([self.selectedBackgroundView isKindOfClass:[TCRRoundRectCellBackgroundView class]]) {
        [(TCRRoundRectCellBackgroundView *)self.selectedBackgroundView setCellBackgroundColor:cellBackgroundColor];
    }
}

@end
