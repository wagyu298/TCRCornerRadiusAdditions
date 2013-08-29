// This is free and unencumbered software released into the public domain.
// For more information, please refer to <http://unlicense.org/>

#import "TCRRoundRectSelectedCellBackgroundView.h"

@implementation TCRRoundRectSelectedCellBackgroundView

- (void)fillBackground:(CGContextRef)c
{
    static CGFloat blueComponents[] = {
        5.0f/255.0f, 140.0f/255.0f, 245.0f/255.0f, 1.0f,
        1.0f/255.0f, 94.0f/255.0f, 230.0f/255.0f, 1.0f,
    };
    static CGFloat grayComponents[] = {
        206.0f/255.0f, 206.0f/255.0f, 206.0f/255.0f, 1.0f,
        171.0f/255.0f, 171.0f/255.0f, 171.0f/255.0f, 1.0f,
    };
    
    UITableViewCell *cell = [self tableViewCell];
    if (cell.selectionStyle == UITableViewCellSelectionStyleNone) {
        [super fillBackground:c];
        return;
    }
    
    CGContextClip(c);
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, (cell.selectionStyle == UITableViewCellSelectionStyleBlue ? blueComponents : grayComponents), (CGFloat[]){0.0f, 1.0f}, 2);
    CGRect bounds = self.bounds;
    CGContextDrawLinearGradient(c, gradientRef, bounds.origin, CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height), kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradientRef);
    CGColorSpaceRelease(colorSpaceRef);
}

@end
