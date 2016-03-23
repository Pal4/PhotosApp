//
//  APPhotosViewController.m
//  PhotosApp
//
//  Created by Андрей Полунин on 3/23/16.
//  Copyright © 2016 Andrey Polunin. All rights reserved.
//

#import "APPhotosViewController.h"
#import "APPhotoAlbum.h"
#import "APPhotoCell.h"

@import Photos;

@interface APPhotosViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation APPhotosViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupCollectionView];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self reloadDataAndSetOffset];
}


#pragma mark - Setup

- (void)setupCollectionView {
    [self.collectionView registerNib:[APPhotoCell nib] forCellWithReuseIdentifier:[APPhotoCell reuseIdentifier]];
    self.collectionView.hidden = YES;
}

- (void)reloadDataAndSetOffset {
    [self.collectionView reloadData];
    self.collectionView.contentOffset = [self contentOffestForIndex:self.startIndex];
    self.collectionView.hidden = NO;
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


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.bounds.size;
}


#pragma mark - Private

- (CGPoint)contentOffestForIndex:(NSUInteger)index {
    CGFloat elementWidth = self.collectionView.bounds.size.width;
    CGPoint offset = CGPointMake((index * elementWidth), 0.f);
    return offset;
}


@end
