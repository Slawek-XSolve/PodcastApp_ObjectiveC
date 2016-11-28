//
//  PodcastModel.h
//  PodcastApp_ObjectiveC
//
//  Created by Slawomir Zagorski on 22.11.2016.
//  Copyright © 2016 SZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@import JSONModel.JSONModel;

NS_ASSUME_NONNULL_BEGIN

@protocol PodcastModel <NSObject>

@end

@interface PodcastModel : JSONModel <PodcastModel>

@property (nonatomic, copy) NSString *artistName;
@property (nonatomic, copy) NSString<Optional> *collectionName;
@property (nonatomic, copy) NSString<Optional> *trackName;
@property (nonatomic, copy) NSString<Optional> *artworkUrl60;
@property (nonatomic, copy) NSString<Optional> *artworkUrl100;

@property (nonatomic, readonly) NSURL<Ignore> *artworkURL;

@end

NS_ASSUME_NONNULL_END
