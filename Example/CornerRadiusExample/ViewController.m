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
    static NSString *identifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    // configureCornerRadiusCell methods add some functions to control corner radius
    [tableView configureCornerRadiusCell:cell];
    cell.cornerRadius = 3.0f;
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.text = [NSString stringWithFormat:@"section=%d row=%d", indexPath.section, indexPath.row];
    return cell;
}

@end
