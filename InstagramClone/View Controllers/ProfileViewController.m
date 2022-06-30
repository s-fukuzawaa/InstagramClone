//
//  ProfileViewController.m
//  InstagramClone
//
//  Created by Airei Fukuzawa on 6/27/22.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "PFImageView.h"
#import "Post.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;


@end
@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.updateButton.layer.borderWidth = 1;

    self.updateButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [self fetchProfile];
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profileImageView addGestureRecognizer:profileTapGestureRecognizer];
    [self.profileImageView setUserInteractionEnabled:YES];

    // Do any additional setup after loading the view.
}
- (IBAction)updateProfile:(id)sender {
    PFUser *user = [PFUser currentUser];
    user[@"profileImage"] = self.profileImageView.file;
//    PFFileObject fileObjectWithData: [image
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
              NSLog(@"Error posting: %@", error.localizedDescription);
         }
         else{
             NSLog(@"Successfully posted");
             [self.delegate didChange];
         }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void) fetchProfile {
    PFUser *user = [PFUser currentUser];
    if(user[@"profileImage"]){
        PFFileObject *file = user[@"profileImage"];
        [self.profileImageView setFile:file];
        [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:imageData];  // Here is your image. Put it in a UIImageView or whatever
                        [self.profileImageView setImage:image];
                        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
                        self.profileImageView.layer.masksToBounds = YES;
                        [self.usernameLabel setText: [@"Username: " stringByAppendingString: user.username]];
                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                        [dateFormat setDateFormat:@"YYYY-MM-dd"];
                        [self.dateLabel setText: [@"Joined since: " stringByAppendingString: [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:user.createdAt]]]];
                    }
                }];
    }
    
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    
    
    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Media" message:@"Choose"
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        // create a cancel action
        UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"Take Photo"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle cancel response here. Doing nothing will dismiss the view.
            UIImagePickerController *imagePickerVC = [UIImagePickerController new];
            imagePickerVC.delegate = self;
            imagePickerVC.allowsEditing = YES;
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
                                                          }];
        // add the cancel action to the alertController
        [alert addAction:photoAction];

        // create an OK action
        UIAlertAction *uploadAction = [UIAlertAction actionWithTitle:@"Upload from Library"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle response here.
            UIImagePickerController *imagePickerVC = [UIImagePickerController new];
            imagePickerVC.delegate = self;
            imagePickerVC.allowsEditing = YES;
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
                                                         }];
        // add the OK action to the alert controller
        [alert addAction:uploadAction];
        
        //cancel
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle response here.
            
                                                         }];
        // add the OK action to the alert controller
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting

        }];
        
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        UIImagePickerController *imagePickerVC = [UIImagePickerController new];
        imagePickerVC.delegate = self;
        imagePickerVC.allowsEditing = YES;
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    originalImage = [self resizeImage:originalImage withSize:self.profileImageView.image.size];
    [self.profileImageView setImage:originalImage];
    PFFileObject *file = [Post getPFFileFromImage:originalImage];
    [self.profileImageView setFile:file];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
