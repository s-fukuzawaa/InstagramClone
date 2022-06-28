//
//  DetailsViewController.h
//  InstagramClone
//
//  Created by Airei Fukuzawa on 6/28/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DetailsViewControllerDelegate

- (void)didAction;

@end
@interface DetailsViewController : UIViewController
@property (nonatomic, strong) Post *post;
@property (nonatomic, weak) id<DetailsViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
