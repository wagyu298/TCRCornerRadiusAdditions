// This is free and unencumbered software released into the public domain.
// For more information, please refer to <http://unlicense.org/>

#import "ViewController.h"
#import "UITableView+TCRCornerRadiusAdditions.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 1;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    if (indexPath.section == 0) {
        identifier = @"FirstSectionCellIdentifier";
    } else {
        identifier = @"SecondSectionCellIdentifier";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    // configureCornerRadiusCell methods add some functions to control corner radius
    [tableView configureCornerRadiusCell:cell];
    if (indexPath.section == 0) {
        cell.cornerRadius = 3.0f;
    } else {
        cell.cornerRadius = 5.0f;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.text = [NSString stringWithFormat:@"section=%d row=%d", indexPath.section, indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"3 rows";
    } else if (section == 1) {
        return @"Single row";
    } else {
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return @"First section configured with\ncorner radius 3px.";
    } else if (section == 1) {
        return @"Second section configured with\ncorner radius 5px.";
    } else {
        return nil;
    }
}

@end
