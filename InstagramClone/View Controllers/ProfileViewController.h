//
//  ProfileViewController.h
//  InstagramClone
//
//  Created by Airei Fukuzawa on 6/27/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ProfileViewControllerDelegate
// TODO: Add required methods the delegate needs to implement
- (void) didChange;

@end

@interface ProfileViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, weak) id<ProfileViewControllerDelegate> delegate;
@end
//@protocol ProfileViewControllerDelegate
//// TODO: Add required methods the delegate needs to implement
//- (void) didChange;
//
//@end
NS_ASSUME_NONNULL_END
