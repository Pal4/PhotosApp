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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.collectionView.hidden = YES;
    [self.collectionView setNeedsLayout];
    [self.collectionView layoutIfNeeded];
    [self.collectionView scrollToItemAtIndexPath:self.selectedIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    self.collectionView.hidden = NO;
}


#pragma mark - Setup

- (void)setupCollectionView {
    [self.collectionView registerNib:[APPhotoCell nib] forCellWithReuseIdentifier:[APPhotoCell reuseIdentifier]];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.album.photoAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    APPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[APPhotoCell reuseIdentifier]
                                                                  forIndexPath:indexPath];
    [cell configureWithAsset:self.album.photoAssets[indexPath.item] imageContentMode:UIViewContentModeScaleAspectFit];
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.bounds.size;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.selectedIndexPath = [self indexForContentOffset:scrollView.contentOffset];
}


#pragma mark - Properties

- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
    _selectedIndexPath = selectedIndexPath;
    self.title = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)(selectedIndexPath.row + 1), (unsigned long)self.album.photoAssets.count];
}


#pragma mark - Private 

- (NSIndexPath *)indexForContentOffset:(CGPoint)offset {
    CGFloat offsetX = offset.x;
    CGFloat itemWidth = self.view.bounds.size.width;
    NSInteger item = (NSInteger)((offsetX + itemWidth / 2.f) / itemWidth);
    return [NSIndexPath indexPathForItem:item inSection:0];
}

@end
