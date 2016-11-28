//
//  PodcastViewController.m
//  PodcastApp_ObjectiveC
//
//  Created by Slawomir Zagorski on 22.11.2016.
//  Copyright © 2016 SZ. All rights reserved.
//

#import "PodcastViewController.h"

@import SDWebImage.UIImageView_WebCache;

#import "PodcastModel.h"

@interface PodcastViewController ()

@property (nonatomic, strong) PodcastModel *podcast;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblSubtitle;
@property (nonatomic, weak) IBOutlet UILabel *lblDescription;

@end

@implementation PodcastViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.podcast) {
        [self configureWithPodcast:self.podcast];

        self.podcast = nil;
    }
}

- (void)configureWithPodcast:(PodcastModel *)podcast
{
    if (!self.imageView) {
        self.podcast = podcast;

        return;
    }
    self.navigationItem.title = podcast.trackName;
    self.lblTitle.text = podcast.trackName;
    self.lblSubtitle.text = podcast.artistName;
    self.lblDescription.text = podcast.collectionName;

    if (podcast.artworkURL)
        [self.imageView sd_setImageWithURL:podcast.artworkURL];
}

@end
