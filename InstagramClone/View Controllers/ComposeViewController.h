//
//  ComposeViewController.h
//  InstagramClone
//
//  Created by Airei Fukuzawa on 6/27/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ComposeViewControllerDelegate

- (void)didPost;

@end
@interface ComposeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
