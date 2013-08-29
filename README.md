TCRCornerRadiusAdditions
========================

TCRCornerRadiusAdditions is a library for iOS that provides functions to control corner radius and separator height of UITableView cells.

![Screenshot](https://raw.github.com/wagyu298/TCRCornerRadiusAdditions/master/Example/screenshot.png "Screenshot")


Usage
-----

Clone TCRCornerRadiusAdditions repository from github and copy all files in `Classes' directory to your project.

Add configureCornerRadiusCell: method call to your TableViewDataSource's tableView:cellForRowAtIndexPath: method.

```objective-c
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    // configureCornerRadiusCell methods add some functions to control corner radius
    [tableView configureCornerRadiusCell:cell];
    // Modify additional properties
    cell.cornerRadius = 3.0f;
    cell.separatorHeight = 1.0f;

    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.text = [NSString stringWithFormat:@"section=%d row=%d", indexPath.section, indexPath.row];
    return cell;
}
```

TCRCornerRadiusAdditions add the following property to UITableViewCell for controlling corner radius, separator height and background view color.

```objective-c
@property (nonatomic) CGFloat cornerRadius;          // default is 10.0f
@property (nonatomic) CGFloat separatorHeight;       // default is 1.0f
@property (nonatomic) UIColor *cellBackgroundColor;  // default is [UIColor whiteColor]
```


Example
-------

To build example project, open Example/CornerRadiusExample.xcodeproj
project file and run from Xcode.


License
-------

TCRCornerRadiusAdditions is free and unencumbered software released into the public domain.
For more information, please refer to <http://unlicense.org/>
