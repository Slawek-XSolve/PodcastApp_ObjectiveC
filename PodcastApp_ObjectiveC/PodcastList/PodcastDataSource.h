//
//  PodcastDataSource.h
//  PodcastApp_ObjectiveC
//
//  Created by Slawomir Zagorski on 22.11.2016.
//  Copyright © 2016 SZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PodcastModel;

NS_ASSUME_NONNULL_BEGIN

@class PodcastDataSource;

@protocol PodcastDataSourceDelegate <NSObject>

- (void)podcastDataSourceChanged:(PodcastDataSource *)dataSource;

@end

@interface PodcastDataSource : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDelegate:(NSObject<PodcastDataSourceDelegate> *)delegate;

@property (nonatomic, assign, getter=isWorking) BOOL working;
@property (nonatomic, copy) NSString *searchTerm;

@property (nonatomic, readonly) NSInteger numberOfItems;

- (PodcastModel * _Nullable)itemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
