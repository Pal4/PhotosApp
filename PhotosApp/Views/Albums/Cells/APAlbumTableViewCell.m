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

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (assign, nonatomic) PHImageRequestID requestId;

@end

@implementation APAlbumTableViewCell

+ (NSString *)reuseIdentifier {
    return [NSString stringWithFormat:@"%@Identifier", NSStringFromClass([self class])];
}

- (void)configureWithAlbum:(APPhotoAlbum *)album {
    self.titleLabel.text = album.title;
    NSUInteger count = album.photoAssets.count;
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)count];

    PHAsset *lastImageAsset = album.photoAssets.lastObject;

    if (lastImageAsset) {
        self.requestId = [[PHImageManager defaultManager] requestImageForAsset:lastImageAsset
                                                                    targetSize:self.thumbnailImageView.frame.size
                                                                   contentMode:PHImageContentModeAspectFill
                                                                       options:nil
                                                                 resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                                     self.thumbnailImageView.image = result;
                                                                 }];
    }
}


#pragma mark - ovveride

- (void)prepareForReuse {
    if (self.requestId != 0) {
        [[PHImageManager defaultManager] cancelImageRequest:self.requestId];
        self.requestId = 0;
    }

    self.thumbnailImageView.image = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    UIColor *backgroundImageColor = self.thumbnailImageView.backgroundColor;

    [super setSelected:selected animated:animated];

    self.thumbnailImageView.backgroundColor = backgroundImageColor;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    UIColor *backgroundImageColor = self.thumbnailImageView.backgroundColor;

    [super setHighlighted:highlighted animated:animated];

    self.thumbnailImageView.backgroundColor = backgroundImageColor;
}

@end
