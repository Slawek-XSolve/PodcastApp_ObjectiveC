//
//  PodcastViewController.m
//  PodcastApp_ObjectiveC
//
//  Created by Slawomir Zagorski on 22.11.2016.
//  Copyright © 2016 SZ. All rights reserved.
//

#import "PodcastListViewController.h"

@import SDWebImage.UIImageView_WebCache;

#import "PodcastDataSource.h"
#import "PodcastModel.h"
#import "PodcastCollectionViewCell.h"
#import "PodcastViewController.h"

@interface PodcastListViewController () <UISearchBarDelegate, UICollectionViewDataSource, PodcastDataSourceDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) PodcastDataSource *dataSource;
@property (nonatomic, assign) BOOL delayedSearch;

@end

@implementation PodcastListViewController

static NSString * const reuseIdentifier = @"PodcastCell";
static NSString * const podcastDetailSegueName = @"PodcastDetailSegue";

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.dataSource = [[PodcastDataSource alloc] initWithDelegate:self];

    [self.dataSource addObserver:self forKeyPath:@"working" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc
{
    if (self.dataSource)
        [self.dataSource removeObserver:self forKeyPath:@"working"];
}

#pragma mark - 

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (![@"working" isEqualToString:keyPath])
        return;

    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.dataSource.isWorking)
            [self.activityIndicator startAnimating];
        else
            [self.activityIndicator stopAnimating];
    });
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (![podcastDetailSegueName isEqualToString:segue.identifier])
        return;

    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];

    if (!indexPath)
        return;

    PodcastModel *podcast = [self.dataSource itemAtIndex:indexPath.row];

    if (!podcast)
        return;

    [(PodcastViewController *)segue.destinationViewController configureWithPodcast:podcast];
}

#pragma mark - <PodcastDataSourceDelegate>

- (void)podcastDataSourceChanged:(PodcastDataSource *)dataSource
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

#pragma mark - <UISearchBarDelegate>

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.delayedSearch)
        return;

    self.delayedSearch = YES;
    [self performSelector:@selector(updateDataSourceSearchTerm) withObject:nil afterDelay:0.3];
}

- (void)updateDataSourceSearchTerm
{
    if (!self.delayedSearch)
        return;
    
    self.delayedSearch = NO;
    self.dataSource.searchTerm = self.searchBar.text;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PodcastCollectionViewCell *cell = (PodcastCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    PodcastModel *podcast = [self.dataSource itemAtIndex:indexPath.row];
    NSURL *imageURL = podcast.artworkURL;


    if (imageURL)
        [cell.imageView sd_setImageWithURL:imageURL];
    else
        cell.imageView.image = nil;

    cell.label.text = podcast.trackName;

    return cell;
}

@end
