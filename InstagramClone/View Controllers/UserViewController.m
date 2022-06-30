//
//  UserViewController.m
//  InstagramClone
//
//  Created by Airei Fukuzawa on 6/28/22.
//

#import "UserViewController.h"
#import "ProfileViewController.h"
#import "DetailsViewController.h"
#import "Parse/Parse.h"
#import "PFImageView.h"
#import "Post.h"
#import "GridViewCell.h"

@interface UserViewController () <ProfileViewControllerDelegate,UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *gridView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) NSArray* posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation UserViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    [self fetchData];
    self.editButton.layer.borderWidth = 1;

    self.editButton.layer.borderColor = [UIColor blueColor].CGColor;
    // Initialize a UIRefreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.gridView insertSubview:self.refreshControl atIndex:0];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    self.profileImage.layer.masksToBounds = YES;
    [self fetchProfile];
    
}
- (IBAction)editProfile:(id)sender {
    [self performSegueWithIdentifier:@"editSegue" sender:NULL];
}

- (void) fetchProfile {
    PFUser *user = [PFUser currentUser];
    if(user[@"profileImage"]){
        PFFileObject *file = user[@"profileImage"];
        [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:imageData];  // Here is your image. Put it in a UIImageView or whatever
                        [self.profileImage setImage:image];
                    }
                }];
    }
    self.usernameLabel.text = user.username;
    
}

- (void)fetchData {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    [query orderByDescending:(@"createdAt")];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.posts = posts;
            [self.gridView reloadData];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {

    [self fetchData];
    [self.refreshControl endRefreshing];
    
}

- (void) didChange {
    [self fetchProfile];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.posts.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    int totalwidth = self.gridView.bounds.size.width;
    int numberOfCellsPerRow = 3;
    int dimensions = (CGFloat)(totalwidth / numberOfCellsPerRow) - 10;
    return CGSizeMake(dimensions, dimensions);
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GridViewCell" forIndexPath:indexPath];
        PFFileObject *file = self.posts[indexPath.row][@"image"];
        [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:imageData];  // Here is your image. Put it in a UIImageView or whatever
                        [cell.image setImage:image];
                    }
                }];
    cell.post =self.posts[indexPath.row];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"editSegue"]){
        
        ProfileViewController *profileVC = [segue destinationViewController];
        profileVC.delegate = self;
    }else if ([segue.identifier isEqualToString:@"gridToDetail"]) {
        NSIndexPath *indexPath = [self.gridView indexPathForCell:(GridViewCell *)sender];
        DetailsViewController *detailVC = [segue destinationViewController];
        detailVC.post = self.posts[indexPath.row];
    }
    
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    [self performSegueWithIdentifier:<#(nonnull NSString *)#> sender:<#(nullable id)#>]
//}


@end
