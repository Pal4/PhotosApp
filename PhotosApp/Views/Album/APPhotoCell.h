//
//  APPhotoCell.h
//  PhotosApp
//
//  Created by Андрей Полунин on 3/23/16.
//  Copyright © 2016 Andrey Polunin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAsset;

@interface APPhotoCell : UICollectionViewCell

+ (UINib *)nib;
+ (NSString *)reuseIdentifier;
- (void)configureWithAsset:(PHAsset *)asset;

@end
