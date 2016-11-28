//
//  PodcastModel.m
//  PodcastApp_ObjectiveC
//
//  Created by Slawomir Zagorski on 22.11.2016.
//  Copyright © 2016 SZ. All rights reserved.
//

#import "PodcastModel.h"

@implementation PodcastModel

- (NSURL<Ignore> *)artworkURL
{
    NSString *artworkUrl = self.artworkUrl100 ?: self.artworkUrl60;

    return artworkUrl ? [NSURL URLWithString:artworkUrl] : nil;
}

@end
