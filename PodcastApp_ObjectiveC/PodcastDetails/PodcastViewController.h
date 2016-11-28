//
//  PodcastViewController.h
//  PodcastApp_ObjectiveC
//
//  Created by Slawomir Zagorski on 22.11.2016.
//  Copyright © 2016 SZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PodcastModel;

@interface PodcastViewController : UIViewController

- (void)configureWithPodcast:(PodcastModel *)podcast;

@end

NS_ASSUME_NONNULL_END
