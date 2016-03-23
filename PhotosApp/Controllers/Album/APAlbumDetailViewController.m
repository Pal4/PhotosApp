//
//  APAlbumDetailViewController.m
//  PhotosApp
//
//  Created by Андрей Полунин on 3/23/16.
//  Copyright © 2016 Andrey Polunin. All rights reserved.
//

#import "APAlbumDetailViewController.h"
#import "APPhotoAlbum.h"
#import "APPhotoCell.h"

@import Photos;

@interface APAlbumDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation APAlbumDetailViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.album.title;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.album.photoAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    APPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[APPhotoCell reuseIdentifier]
                                                                  forIndexPath:indexPath];
    [cell configureWithAsset:self.album.photoAssets[indexPath.item]];
    return cell;
}


#pragma mark - UICollectionViewDelegate


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.collectionView.bounds.size.width / 3.f;
    return CGSizeMake(width, width);
}

@end
