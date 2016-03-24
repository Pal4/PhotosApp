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
#import "APPhotosViewController.h"

static NSString *const kShowPhotosSegue = @"ShowPhotosSegue";

@import Photos;

@interface APAlbumDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign, nonatomic) NSIndexPath* selectedPhotoIndexPath;

@end

@implementation APAlbumDetailViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.album.title;
    [self setupCollectionView];
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
    [cell configureWithAsset:self.album.photoAssets[indexPath.item] imageContentMode:UIViewContentModeScaleAspectFill];
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedPhotoIndexPath = indexPath;
    [self performSegueWithIdentifier:kShowPhotosSegue sender:self];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.collectionView.bounds.size.width / 3.f;
    return CGSizeMake(width, width);
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kShowPhotosSegue]) {
        APPhotosViewController *vc = segue.destinationViewController;
        vc.album = self.album;
        vc.selectedIndexPath = self.selectedPhotoIndexPath;
    }
}

@end
