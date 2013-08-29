// This is free and unencumbered software released into the public domain.
// For more information, please refer to <http://unlicense.org/>

#import "UITableView+TCRCornerRadiusAdditions.h"

@implementation UITableView (TCRCornerRadiusAdditions)

- (void)configureCornerRadiusCell:(UITableViewCell *)cell
{
    if (self.style == UITableViewStyleGrouped) {
        [cell configureCornerRadius];
    }
}

@end
