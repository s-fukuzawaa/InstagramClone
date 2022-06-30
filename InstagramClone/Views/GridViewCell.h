//
//  GridViewCell.h
//  InstagramClone
//
//  Created by Airei Fukuzawa on 6/29/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
NS_ASSUME_NONNULL_BEGIN

@interface GridViewCell : UICollectionViewCell
@property (nonatomic, strong) Post* post;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@end

NS_ASSUME_NONNULL_END
