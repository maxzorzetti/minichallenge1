//
//  SAFriendTableViewCell.h
//  
//
//  Created by Max Zorzetti on 02/05/17.
//
//

#import <UIKit/UIKit.h>

@interface SAFriendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *selectionImageView;

@end
