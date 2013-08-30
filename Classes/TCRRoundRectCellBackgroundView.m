// This is free and unencumbered software released into the public domain.
// For more information, please refer to <http://unlicense.org/>

#import "TCRRoundRectCellBackgroundView.h"

typedef enum  {
    OrphanCell,
    HeaddingCell,
    MiddleCell,
    BottomCell,
} CellType;

static BOOL
colorToRGBA(UIColor *color, CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a)
{
    if ([color getRed:r green:g blue:b alpha:a]) {
        return YES;
    }
    
    CGFloat h;
    CGFloat s;
    CGFloat v;
    if ([color getHue:&h saturation:&s brightness:&v alpha:a]) {
        int inn = floorf(h / 60.0f);
        if (inn < 0) {
            inn *= -1;
        }
        
        CGFloat fl = (h  / 60.0f) - inn;
        CGFloat p = v * (1 - s);
        CGFloat q = v * (1 - s * fl);
        CGFloat t = v * (1 - (1 - fl) * s);
        
        switch (inn) {
            case 0:
                *r = v;
                *g = t;
                *b = p;
                break;
            case 1:
                *r = q;
                *g = v;
                *b = p;
                break;
            case 2:
                *r = p;
                *g = v;
                *b = q;
                break;
            case 3:
                *r = p;
                *g = q;
                *b = v;
                break;
            case 4:
                *r = t;
                *g = p;
                *b = v;
                break;
            case 5:
                *r = v;
                *g = p;
                *b = q;
                break;
        }
        
        return YES;
    }
    
    if (CGColorGetNumberOfComponents(color.CGColor) == 2) {
        const float *components = CGColorGetComponents(color.CGColor);
        *r = components[0];
        *g = components[0];
        *b = components[0];
        *a = components[1];
    }
    
    return NO;
}

@interface TCRRoundRectCellBackgroundView ()

@property (nonatomic, readonly) UIColor *separatorColor;
@property (nonatomic) CellType cellType;

@end

@implementation TCRRoundRectCellBackgroundView

+ (void)initialize
{
    if (self == [TCRRoundRectCellBackgroundView class]) {
        TCRRoundRectCellBackgroundView *appearance = [self appearance];
        [appearance setCornerRadius:5.0f];
        [appearance setSeparatorHeight:1.0f];
        [appearance setCellBackgroundColor:[UIColor whiteColor]];
    }
}

- (BOOL)isOpaque
{
    return NO;
}

- (UITableView *)tableView
{
    for (UIResponder *nextResponder = self; nextResponder; ) {
        nextResponder = nextResponder.nextResponder;
        if ([nextResponder isMemberOfClass:[UITableView class]]) {
            return (UITableView *)nextResponder;
        }
    }
    return nil;
}

- (UITableViewCell *)tableViewCell
{
    for (UIResponder *nextResponder = self; nextResponder; ) {
        nextResponder = nextResponder.nextResponder;
        if ([nextResponder isMemberOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)nextResponder;
        }
    }
    return nil;
}

- (UIColor *)shadowColor
{
    return [UIColor colorWithWhite:1.0f alpha:1.0f];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UITableView *tableView = nil;
    UITableViewCell *tableViewCell = nil;
    for (UIResponder *nextResponder = self; nextResponder; ) {
        if (tableView && tableViewCell) {
            break;
        }
        nextResponder = nextResponder.nextResponder;
        if (!tableView && [nextResponder isMemberOfClass:[UITableView class]]) {
            tableView = (UITableView *)nextResponder;
        } else if (!tableViewCell && [nextResponder isMemberOfClass:[UITableViewCell class]]) {
            tableViewCell = (UITableViewCell *)nextResponder;
        }
    }
    
    NSIndexPath *indexPath = [tableView indexPathForCell:tableViewCell];
    if ([tableView numberOfRowsInSection:indexPath.section] == 1) {
        self.cellType = OrphanCell;
    } else if (indexPath.row == 0) {
        self.cellType = HeaddingCell;
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
        self.cellType = BottomCell;
    } else {
        self.cellType = MiddleCell;
    }
    
    [self setNeedsDisplay];
}

- (void)fillBackground:(CGContextRef)c
{
    UITableView *tableView = [self tableView];
    
    if (tableView.separatorStyle == UITableViewCellSeparatorStyleSingleLineEtched && (_cellType == HeaddingCell || _cellType == OrphanCell)) {
        CGFloat bgR = 1.0f, bgG = 1.0f, bgB = 1.0f, bgA = 1.0f;
        colorToRGBA(_cellBackgroundColor, &bgR, &bgG, &bgB, &bgA);
        
        CGFloat spR = 171.0f/255.0f, spG = 171.0f/255.0f, spB = 171.0f/255.0f, spA = 0.8f;
#if 0
        if (colorToRGBA(tableView.separatorColor, &spR, &spG, &spB, &spA)) {
            spR = MAX(spR / 2.0f, 0.0f);
            spG = MAX(spG / 2.0f, 0.0f);
            spB = MAX(spB / 2.0f, 0.0f);
        }
#endif
        
        const CGFloat components[] = {
            spR, spG, spB, spA,
            bgR, bgG, bgB, bgA,
            bgR, bgG, bgB, bgA,
        };
        
        CGContextClip(c);
        
        CGRect bounds = self.bounds;
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, components, (CGFloat[]){0.0f, 2.0f / bounds.size.height, 1.0f}, 3);
        CGContextDrawLinearGradient(c, gradientRef, bounds.origin, CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height), kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradientRef);
        CGColorSpaceRelease(colorSpaceRef);
        
    } else {
        CGContextSetFillColorWithColor(c, [_cellBackgroundColor CGColor]);
        CGContextFillPath(c);
    }
}

- (void)drawOrphanCellWithContext:(CGContextRef)c
{
    CGRect bounds = [self bounds];
    UITableView *tableView = [self tableView];
    UITableViewCellSeparatorStyle separatorStyle = tableView.separatorStyle;
    
    CGFloat minX = CGRectGetMinX(bounds);
    CGFloat midX = CGRectGetMidX(bounds);
    CGFloat maxX = CGRectGetMaxX(bounds);
    CGFloat minY = CGRectGetMinY(bounds);
    CGFloat midY = CGRectGetMidY(bounds);
    CGFloat maxY = CGRectGetMaxY(bounds);
    
    if (separatorStyle == UITableViewCellSeparatorStyleSingleLineEtched) {
        maxY -= _separatorHeight;
    } else {
        maxY -= _separatorHeight / 2.0f;
    }
    
    minX += _separatorHeight / 2.0f;
    maxX -= _separatorHeight / 2.0f;
    minY += _separatorHeight / 2.0f;
    maxY -= _separatorHeight / 2.0f;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, minX, midY);
    CGPathAddArcToPoint(path, NULL, minX, minY, midX, minY, _cornerRadius);
    CGPathAddArcToPoint(path, NULL, maxX, minY, maxX, midY, _cornerRadius);
    CGPathAddArcToPoint(path, NULL, maxX, maxY, midX, maxY, _cornerRadius);
    CGPathAddArcToPoint(path, NULL, minX, maxY, minX, midY, _cornerRadius);
    CGPathCloseSubpath(path);
    
    CGContextSaveGState(c);
    CGContextAddPath(c, path);
    [self fillBackground:c];
    CGContextRestoreGState(c);
    
    if (separatorStyle == UITableViewCellSeparatorStyleSingleLineEtched) {
        CGPathRelease(path);
        
        // Stroke bottom half with shadow
        path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, minX, midY);
        CGPathAddArcToPoint(path, NULL, minX, maxY, midX, maxY, _cornerRadius);
        CGPathAddArcToPoint(path, NULL, maxX, maxY, maxX, midY, _cornerRadius);
        
        CGContextSaveGState(c);
        CGContextAddPath(c, path);
        CGContextSetStrokeColorWithColor(c, [tableView.separatorColor CGColor]);
        if (separatorStyle == UITableViewCellSeparatorStyleSingleLineEtched) {
            CGContextSetShadowWithColor(c, CGSizeMake(0.0f, _separatorHeight / 2.0f), _separatorHeight / 2.0f, [self.shadowColor CGColor]);
        }
        CGContextSetLineWidth(c, _separatorHeight);
        CGContextStrokePath(c);
        CGContextRestoreGState(c);
        
        CGPathRelease(path);
        
        // Stroke top half without shadow
        path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, minX, midY);
        CGPathAddArcToPoint(path, NULL, minX, minY, midX, minY, _cornerRadius);
        CGPathAddArcToPoint(path, NULL, maxX, minY, maxX, midY, _cornerRadius);
        
        CGContextSaveGState(c);
        CGContextAddPath(c, path);
        CGContextSetStrokeColorWithColor(c, [tableView.separatorColor CGColor]);
        CGContextSetLineWidth(c, _separatorHeight);
        CGContextStrokePath(c);
        CGContextRestoreGState(c);
        
        CGPathRelease(path);

    } else {
        CGContextSaveGState(c);
        CGContextAddPath(c, path);
        CGContextSetStrokeColorWithColor(c, [tableView.separatorColor CGColor]);
        CGContextSetLineWidth(c, _separatorHeight);
        CGContextStrokePath(c);
        CGContextRestoreGState(c);
        
        CGPathRelease(path);
    }
}

- (void)drawHeaddingCellWithContext:(CGContextRef)c
{
    CGRect bounds = [self bounds];
    UITableView *tableView = [self tableView];
    //UITableViewCellSeparatorStyle separatorStyle = tableView.separatorStyle;
    
    CGFloat minX = CGRectGetMinX(bounds);
    CGFloat midX = CGRectGetMidX(bounds);
    CGFloat maxX = CGRectGetMaxX(bounds);
    CGFloat minY = CGRectGetMinY(bounds);
    //CGFloat midY = CGRectGetMidY(bounds); // Unused
    CGFloat maxY = CGRectGetMaxY(bounds);
    
    minX += _separatorHeight / 2.0f;
    maxX -= _separatorHeight / 2.0f;
    minY += _separatorHeight / 2.0f;
    maxY -= _separatorHeight / 2.0f;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, minX, maxY);
    CGPathAddArcToPoint(path, NULL, minX, minY, midX, minY, _cornerRadius);
    CGPathAddArcToPoint(path, NULL, maxX, minY, maxX, maxY, _cornerRadius);
    CGPathAddLineToPoint(path, NULL, maxX, maxY);
    CGPathAddLineToPoint(path, NULL, minX, maxY);
    CGPathCloseSubpath(path);
    
    CGContextSaveGState(c);
    CGContextAddPath(c, path);
    [self fillBackground:c];
    CGContextRestoreGState(c);
    
    CGContextSaveGState(c);
    CGContextAddPath(c, path);
    CGContextSetStrokeColorWithColor(c, [tableView.separatorColor CGColor]);
    CGContextSetLineWidth(c, _separatorHeight);
    CGContextStrokePath(c);
    CGContextRestoreGState(c);
    
    CGPathRelease(path);
}

- (void)drawMiddleCellWithContext:(CGContextRef)c
{
    CGRect bounds = [self bounds];
    UITableView *tableView = [self tableView];
    //UITableViewCellSeparatorStyle separatorStyle = self.tableView.separatorStyle;
    
    CGFloat minX = CGRectGetMinX(bounds);
    //CGFloat midX = CGRectGetMidX(bounds); // Unused
    CGFloat maxX = CGRectGetMaxX(bounds);
    CGFloat minY = CGRectGetMinY(bounds);
    //CGFloat midY = CGRectGetMidY(bounds); // Unused
    CGFloat maxY = CGRectGetMaxY(bounds);
    
    minX += _separatorHeight / 2.0f;
    maxX -= _separatorHeight / 2.0f;
    //minY += _separatorHeight / 2.0f;    // Not required
    maxY -= _separatorHeight / 2.0f;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, minX, minY);
    CGPathAddLineToPoint(path, NULL, minX, maxY);
    CGPathAddLineToPoint(path, NULL, maxX, maxY);
    CGPathAddLineToPoint(path, NULL, maxX, minY);
    CGPathAddLineToPoint(path, NULL, minX, minY);
    CGPathCloseSubpath(path);
    
    CGContextSaveGState(c);
    CGContextAddPath(c, path);
    [self fillBackground:c];
    CGContextRestoreGState(c);
    
    CGPathRelease(path);
    
    path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, minX, minY);
    CGPathAddLineToPoint(path, NULL, minX, maxY);
    CGPathAddLineToPoint(path, NULL, maxX, maxY);
    CGPathAddLineToPoint(path, NULL, maxX, minY);
    
    CGContextSaveGState(c);
    CGContextAddPath(c, path);
    CGContextSetStrokeColorWithColor(c, [tableView.separatorColor CGColor]);
    CGContextSetLineWidth(c, _separatorHeight);
    CGContextStrokePath(c);
    CGContextRestoreGState(c);
    
    CGPathRelease(path);
}

- (void)drawBottomCellWithContext:(CGContextRef)c
{
    CGRect bounds = [self bounds];
    UITableView *tableView = [self tableView];
    UITableViewCellSeparatorStyle separatorStyle = tableView.separatorStyle;
    
    CGFloat minX = CGRectGetMinX(bounds);
    CGFloat midX = CGRectGetMidX(bounds);
    CGFloat maxX = CGRectGetMaxX(bounds);
    CGFloat minY = CGRectGetMinY(bounds);
    //CGFloat midY = CGRectGetMidY(bounds); // Unused
    CGFloat maxY = CGRectGetMaxY(bounds);
    
    minX += _separatorHeight / 2.0f;
    maxX -= _separatorHeight / 2.0f;
    //minY += _separatorHeight / 2.0f;
    if (separatorStyle == UITableViewCellSeparatorStyleSingleLineEtched) {
        maxY -= _separatorHeight;
    } else {
        maxY -= _separatorHeight / 2.0f;
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, minX, minY);
    CGPathAddArcToPoint(path, NULL, minX, maxY, midX, maxY, _cornerRadius);
    CGPathAddArcToPoint(path, NULL, maxX, maxY, maxX, minY, _cornerRadius);
    CGPathAddLineToPoint(path, NULL, maxX, minY);
    CGPathAddLineToPoint(path, NULL, minX, minY);
    CGPathCloseSubpath(path);
    
    CGContextSaveGState(c);
    CGContextAddPath(c, path);
    [self fillBackground:c];
    CGContextRestoreGState(c);
    
    CGPathRelease(path);
    
    path = CGPathCreateMutable();
    minY = CGRectGetMinY(bounds);
    CGPathMoveToPoint(path, NULL, minX, minY);
    CGPathAddArcToPoint(path, NULL, minX, maxY, midX, maxY, _cornerRadius);
    CGPathAddArcToPoint(path, NULL, maxX, maxY, maxX, minY, _cornerRadius);
    CGPathAddLineToPoint(path, NULL, maxX, minY);
    
    CGContextSaveGState(c);
    CGContextAddPath(c, path);
    CGContextSetStrokeColorWithColor(c, [tableView.separatorColor CGColor]);
    if (separatorStyle == UITableViewCellSeparatorStyleSingleLineEtched) {
        CGContextSetShadowWithColor(c, CGSizeMake(0.0f, _separatorHeight / 2.0f), _separatorHeight / 2.0f, [self.shadowColor CGColor]);
    }
    CGContextSetLineWidth(c, _separatorHeight);
    CGContextStrokePath(c);
    CGContextRestoreGState(c);
    
    CGPathRelease(path);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(c, YES);
    CGContextSetShouldAntialias(c, YES);
    
    switch (_cellType) {
        case OrphanCell:
            [self drawOrphanCellWithContext:c];
            break;
        case HeaddingCell:
            [self drawHeaddingCellWithContext:c];
            break;
        case BottomCell:
            [self drawBottomCellWithContext:c];
            break;
        case MiddleCell:
            [self drawMiddleCellWithContext:c];
            break;
    }
}

@end
