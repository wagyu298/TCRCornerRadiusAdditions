// This is free and unencumbered software released into the public domain.
// For more information, please refer to <http://unlicense.org/>

#import <UIKit/UIKit.h>

@interface TCRRoundRectCellBackgroundView : UIView

@property (nonatomic) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat separatorHeight UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *cellBackgroundColor UI_APPEARANCE_SELECTOR;

- (UITableView *)tableView;
- (UITableViewCell *)tableViewCell;
- (void)fillBackground:(CGContextRef)c;

@end
