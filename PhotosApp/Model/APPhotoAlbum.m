//
//  APPhotoAlbums.m
//  PhotosApp
//
//  Created by Андрей Полунин on 3/23/16.
//  Copyright © 2016 Andrey Polunin. All rights reserved.
//

#import "APPhotoAlbum.h"

@import Photos;

@interface APPhotoAlbum ()

@property (strong, nonatomic) PHAssetCollection *assetCollection;
@property (strong, nonatomic) PHFetchResult<PHAsset *> *photoAssets;

@end


@implementation APPhotoAlbum

#pragma mark - Fetching albums

+ (void)fetchPhotoAlbumsWithCompletion:(void (^)(NSArray<APPhotoAlbum *> *))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        PHFetchResult<PHAssetCollection *> *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                                                   subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                                                   options:nil];
        NSMutableArray *albums = [NSMutableArray arrayWithCapacity:smartAlbums.count];

        for (PHAssetCollection *collection in smartAlbums) {
            if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumVideos ||
                collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumSlomoVideos ||
                collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumTimelapses) {
                continue;
            }
            
            [albums addObject:[[APPhotoAlbum alloc] initWithAssetCollection:collection]];
        }

        if (completion) {
            completion(albums.copy);
        }

    });
}


#pragma mark - Initialize

- (instancetype)initWithAssetCollection:(PHAssetCollection *)collection {
    self = [self init];
    if (self) {
        self.assetCollection = collection;
        [self fetchPhotos];
    }
    return self;
}


#pragma mark - Public

- (NSString *)title {
    return self.assetCollection.localizedTitle;
}


#pragma mark - Private

- (void)fetchPhotos {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    self.photoAssets = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:options];
}

@end