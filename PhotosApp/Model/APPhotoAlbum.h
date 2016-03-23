//
//  APPhotoAlbums.h
//  PhotosApp
//
//  Created by Андрей Полунин on 3/23/16.
//  Copyright © 2016 Andrey Polunin. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PHAssetCollection, PHFetchResult<ObjectType>, PHAsset;


@interface APPhotoAlbum : NSObject


+ (void)fetchPhotoAlbumsWithCompletion:(void(^)(NSArray<APPhotoAlbum *>*))completion;

- (instancetype)initWithAssetCollection:(PHAssetCollection *)collection;
- (PHFetchResult<PHAsset *> *)photoAssets;
- (NSString *)title;

@end
