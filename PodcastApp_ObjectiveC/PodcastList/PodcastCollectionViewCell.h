//
//  PodcastCollectionViewCell.h
//  PodcastApp_ObjectiveC
//
//  Created by Slawomir Zagorski on 21.11.2016.
//  Copyright © 2016 SZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PodcastCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak, nullable) IBOutlet UIImageView *imageView;
@property (nonatomic, weak, nullable) IBOutlet UILabel *label;

@end

NS_ASSUME_NONNULL_END
