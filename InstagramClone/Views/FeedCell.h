//
//  FeedCell.h
//  InstagramClone
//
//  Created by Airei Fukuzawa on 6/28/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Parse/Parse.h"
#import "PFImageView.h"
NS_ASSUME_NONNULL_BEGIN
@protocol FeedCellDelegate;


@interface FeedCell : UITableViewCell
@property (nonatomic, strong) Post* post;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *captionText;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet PFImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
@protocol FeedCellDelegate
// TODO: Add required methods the delegate needs to implement
- (void)feedCell:(FeedCell *)feedCell didTap:(PFUser *)user;

@end
NS_ASSUME_NONNULL_END
