//
//  APPhotoCell.m
//  PhotosApp
//
//  Created by Андрей Полунин on 3/23/16.
//  Copyright © 2016 Andrey Polunin. All rights reserved.
//

#import "APPhotoCell.h"

@import Photos;

@interface APPhotoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (assign, nonatomic) PHImageRequestID requestId;

@end

@implementation APPhotoCell

+ (NSString *)reuseIdentifier {
    return [NSString stringWithFormat:@"%@Identifier", NSStringFromClass([self class])];
}

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (void)configureWithAsset:(PHAsset *)asset {
    if (self.requestId != 0) {
        [[PHImageManager defaultManager] cancelImageRequest:self.requestId];
        self.requestId = 0;
    }

    self.requestId = [[PHImageManager defaultManager] requestImageForAsset:asset
                                                                targetSize:self.imageView.frame.size
                                                               contentMode:PHImageContentModeAspectFill
                                                                   options:nil
                                                             resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                                 self.imageView.image = result;
                                                             }];
}

@end
