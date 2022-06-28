//
//  HomeViewController.m
//  InstagramClone
//
//  Created by Airei Fukuzawa on 6/27/22.
//

#import "HomeViewController.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"
#import "FeedCell.h"
#import "Parse/Parse.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, DetailsViewControllerDelegate, ComposeViewControllerDelegate>
- (IBAction)logoutButton:(id)sender;
@property (strong, nonatomic) NSArray* dataArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchData];
    // Initialize a UIRefreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {

    [self fetchData];
    [self.refreshControl endRefreshing];
    
}


- (void)fetchData {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:(@"createdAt")];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.dataArr = posts;
            self.tableView.dataSource = self;
            self.tableView.delegate = self;
            [self.tableView reloadData];
            self.tableView.rowHeight = UITableViewAutomaticDimension;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)composeButton:(id)sender {
    [self performSegueWithIdentifier:@"homeToCompose" sender:nil];
}

- (IBAction)logoutButton:(id)sender {
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell"];
    cell.captionText.text = self.dataArr[indexPath.row][@"caption"];
    PFFileObject *file = self.dataArr[indexPath.row][@"image"];
    [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:imageData];  // Here is your image. Put it in a UIImageView or whatever
                    [cell.postImage setImage:image];
                }
            }];
    
    return cell;
}

- (void)didAction {
    [self fetchData];
}

- (void)didPost {
    [self fetchData];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
            
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"homeToCompose"]){
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
        
    }else if([segue.identifier isEqualToString:@"detailsSegue"]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(FeedCell *)sender];
        DetailsViewController *detailVC = [segue destinationViewController];
        detailVC.post = self.dataArr[indexPath.row];
        
    }
}
@end
