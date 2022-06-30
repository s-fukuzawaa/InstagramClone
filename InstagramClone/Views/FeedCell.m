//
//  FeedCell.m
//  InstagramClone
//
//  Created by Airei Fukuzawa on 6/28/22.
//

#import "FeedCell.h"

@implementation FeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)didTapLike:(id)sender {
    self.post.liked = !self.post.liked;
    if(self.post.liked == YES){
        NSNumber *sum = [NSNumber numberWithFloat:(1 + [self.post.likeCount intValue])];

        self.post.likeCount = sum;
    }else{
        NSNumber *sum = [NSNumber numberWithFloat:(-1 + [self.post.likeCount intValue])];

        if(sum<0){
            self.post.likeCount = 0;
        }else{
            self.post.likeCount = sum;
        }
    }
    [self refreshDataFavorite];
}
- (IBAction)didTapComment:(id)sender {
    NSNumber *sum = [NSNumber numberWithFloat:(1 + [self.post.commentCount intValue])];

    self.post.commentCount = sum;
    [self refreshDataComment];
}

- (void) refreshDataFavorite {
//    Update count
    [self.likeButton setTitle:[NSString stringWithFormat:@"%@", self.post.likeCount] forState:UIControlStateNormal];
//    Case when liked:
    if(self.post.liked == YES) {
        
        [self.likeButton setImage: [UIImage systemImageNamed: @"heart.fill"] forState:UIControlStateNormal];

    }else{
//        Case when unliked:
        [self.likeButton setImage: [UIImage systemImageNamed: @"heart"] forState:UIControlStateNormal];
    }
    //       Update

            [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(error){
                      NSLog(@"Error posting: %@", error.localizedDescription);
                 }
                 else{
                     NSLog(@"Successfully posted");
                 }
            }];

}


- (void) refreshDataComment {
//    Update count
    [self.commentButton setTitle:[NSString stringWithFormat:@"%@", self.post.commentCount] forState:UIControlStateNormal];
    [self.commentButton setImage: [UIImage systemImageNamed: @"message.fill"] forState:UIControlStateNormal];

    if([self.post.commentCount intValue] == 0) {
        [self.commentButton setImage: [UIImage systemImageNamed: @"message"] forState:UIControlStateNormal];
    }
    //       Update

    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
              NSLog(@"Error posting: %@", error.localizedDescription);
         }
         else{
             NSLog(@"Successfully posted");
         }
    }];

}


- (void) setPost: (Post *)post {
    _post = post;
    PFFileObject *file = post.image;
    [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:imageData];  // Here is your image. Put it in a UIImageView or whatever
                    [self.postImage setImage:image];
                }
            }];
    // Set like button
    [self.likeButton setTitle:[NSString stringWithFormat:@" %@",post.likeCount] forState:UIControlStateNormal];
    if(post.liked) {
        [self.likeButton setImage: [UIImage systemImageNamed: @"heart.fill"] forState:UIControlStateNormal];
    }else{
        [self.likeButton setImage: [UIImage systemImageNamed: @"heart"] forState:UIControlStateNormal];
    }
    // Set comment button
    [self.commentButton setTitle:[NSString stringWithFormat:@" %@",post.commentCount] forState:UIControlStateNormal];
    if([post.commentCount intValue] == 0){
        [self.commentButton setImage: [UIImage systemImageNamed: @"message"] forState:UIControlStateNormal];
    }else{
        [self.commentButton setImage: [UIImage systemImageNamed: @"message.fill"] forState:UIControlStateNormal];
    }
    PFUser *temp = post.author;
    NSLog(@"%@", temp.objectId);
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:temp.objectId];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            // do something with the array of object returned by the call
            PFUser *user= users[0];
            if(user[@"profileImage"]){
                PFFileObject *file = user[@"profileImage"];
                [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                            if (!error) {
                                UIImage *image = [UIImage imageWithData:imageData];  // Here is your image. Put it in a UIImageView or whatever
                                [self.userImage setImage:image];
                            }
                        }];
            }
            self.usernameLabel.text = [@"@" stringByAppendingString:user.username];
            self.captionText.text = [user.username stringByAppendingString: @": "];
            self.captionText.text = [self.captionText.text stringByAppendingString:post.caption];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"YYYY-MM-dd"];
            [self.dateLabel setText: [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:user.createdAt]]];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    NSLog(@"%@",post.caption);
   
    self.userImage.layer.cornerRadius = self.userImage.frame.size.height/2;
    self.userImage.layer.masksToBounds = YES;
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
