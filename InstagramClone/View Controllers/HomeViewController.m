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

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, DetailsViewControllerDelegate, ComposeViewControllerDelegate, UIScrollViewDelegate>
- (IBAction)logoutButton:(id)sender;
@property (strong, nonatomic) NSArray* dataArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic) int count;
@property (assign, nonatomic) BOOL isMoreDataLoading;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.count = 20;
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


- (void)fetchData{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];

    [query orderByDescending:(@"createdAt")];
    query.limit = self.count;
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.dataArr = posts;
            
            self.tableView.rowHeight = UITableViewAutomaticDimension;
            self.count = self.count + 20;
            // Update flag
            self.isMoreDataLoading = false;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            [self fetchData];
        }
    }
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row + 1 == [self.dataArr count]){
        [self fetchData];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell"];
    Post *postData = self.dataArr[indexPath.row];
    cell.post = postData;
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

- (void)feedCell:(FeedCell *)feedCell didTap:(PFUser *)user{
    // TODO: Perform segue to profile view controller
    [self performSegueWithIdentifier:@"profileSegue" sender:user];


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
