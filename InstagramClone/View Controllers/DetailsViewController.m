//
//  DetailsViewController.m
//  InstagramClone
//
//  Created by Airei Fukuzawa on 6/28/22.
//

#import "DetailsViewController.h"
#import "NSDate+DateTools.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) NSDate* date;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Set Date
    self.date = self.post.createdAt;
    [self formatDate];
    
    // Set image
    PFFileObject *file = self.post.image;
    [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:imageData];  // Here is your image. Put it in a UIImageView or whatever
                    [self.postImage setImage:image];
                }
            }];
    
    // Set profile image
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
    
    self.usernameLabel.text = [@"@" stringByAppendingString:user[@"username"]];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    self.profileImage.layer.masksToBounds = YES;
    // Set caption
    self.captionLabel.text = [user.username stringByAppendingString: @": "];
    self.captionLabel.text = [self.captionLabel.text stringByAppendingString:self.post.caption];
    
}
- (void) formatDate {
    [self.dateLabel setText: [self.post.createdAt shortTimeAgoSinceNow]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
