//
//  FeedCell.h
//  InstagramClone
//
//  Created by Airei Fukuzawa on 6/28/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *captionText;

@end

NS_ASSUME_NONNULL_END
