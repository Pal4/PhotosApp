//
//  APAlbumTableViewCell.m
//  PhotosApp
//
//  Created by Андрей Полунин on 3/23/16.
//  Copyright © 2016 Andrey Polunin. All rights reserved.
//

#import "APAlbumTableViewCell.h"
#import "APPhotoAlbum.h"

@import Photos;

@interface APAlbumTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation APAlbumTableViewCell

+ (NSString *)reuseIdentifier {
    return [NSString stringWithFormat:@"%@Identifier", NSStringFromClass([self class])];
}

- (void)configureWithAlbum:(APPhotoAlbum *)album {
    self.titleLabel.text = album.title;
    NSUInteger count = album.photoAssets.count;
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)count];
}

@end
