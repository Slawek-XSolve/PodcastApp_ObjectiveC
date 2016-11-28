//
//  PodcastDataSource.m
//  PodcastApp_ObjectiveC
//
//  Created by Slawomir Zagorski on 22.11.2016.
//  Copyright © 2016 SZ. All rights reserved.
//

#import "PodcastDataSource.h"

@import JSONModel.JSONModel;

#import "PodcastModel.h"

@interface APIResponeModel : JSONModel

@property (nonatomic, strong) NSNumber *resultCount;
@property (nonatomic, strong) NSArray<PodcastModel> *results;

@end

@implementation APIResponeModel

@end

@interface PodcastDataSource ()

@property (nonatomic, weak) NSObject<PodcastDataSourceDelegate> *delegate;
@property (nonatomic, strong) NSArray<PodcastModel *> *items;

@property (nonatomic, readonly) NSURLSession *urlSession;

@property (nonatomic, strong) NSURLSessionDataTask *currentDataTask;
@property (nonatomic, strong) NSString *currentSearchTerm;

@end

@implementation PodcastDataSource

@synthesize working = _working;

static NSString *itunesAPI = @"https://itunes.apple.com/search";
static NSInteger itemLimit = 50;

- (instancetype)initWithDelegate:(NSObject<PodcastDataSourceDelegate> *)delegate
{
    if (self = [super init])
    {
        self.delegate = delegate;
        self.items = [NSArray new];
    }
    return self;
}

- (void)setItems:(NSArray<PodcastModel *> *)items
{
    _items = items;

    [self.delegate podcastDataSourceChanged:self];
}

- (NSURLSession *)urlSession
{
    return [NSURLSession sharedSession];
}

- (NSURL *)apiURLWithSearchTerm:(NSString *)searchTerm
{
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:itunesAPI];
    NSString *escapedSearchTerm = [searchTerm stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];

    components.percentEncodedQuery = [NSString stringWithFormat:@"limit=%ld&term=%@", itemLimit, escapedSearchTerm];

    return [components URL];
}

- (void)setSearchTerm:(NSString *)searchTerm
{
    _searchTerm = searchTerm;

    if (self.currentDataTask)
    {
        [self.currentDataTask cancel];
        self.currentDataTask = nil;
        self.working = NO;
    }
    if (self.currentSearchTerm && [self.currentSearchTerm isEqualToString:_searchTerm])
        return;

    if (_searchTerm.length == 0)
    {
        self.items = @[];
        self.currentSearchTerm = @"";
        self.working = NO;

        return;
    }
    __weak typeof(self) weakSelf = self;

    self.currentDataTask = [self.urlSession dataTaskWithURL:[self apiURLWithSearchTerm:searchTerm] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        typeof(&*weakSelf) strongSelf = weakSelf;

        if (!strongSelf || error || !data)
        {
            if (error.code != NSURLErrorCancelled)
            {
                strongSelf.items = @[];
                strongSelf.currentSearchTerm = @"";
                strongSelf.working = NO;
            }
            return;
        }
        NSError *serializationError;
        APIResponeModel *model = [[APIResponeModel alloc] initWithData:data error:&serializationError];

        if (serializationError || !model)
        {
            strongSelf.items = @[];
            strongSelf.currentSearchTerm = @"";
            strongSelf.working = NO;
            
            return;
        }
        strongSelf.items = model.results;
        strongSelf.currentSearchTerm = searchTerm;
        strongSelf.working = NO;
    }];
    self.working = YES;
    [self.currentDataTask resume];
}

- (NSInteger)numberOfItems
{
    return self.items.count;
}

- (PodcastModel *)itemAtIndex:(NSInteger)index
{
    return [self.items objectAtIndex:index];
}

@end
