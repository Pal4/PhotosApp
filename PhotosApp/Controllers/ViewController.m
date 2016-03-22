//
//  ViewController.m
//  PhotosApp
//
//  Created by Андрей Полунин on 3/22/16.
//  Copyright © 2016 Andrey Polunin. All rights reserved.
//

#import "ViewController.h"

@import Photos;

@interface ViewController ()

@property (strong, nonatomic) UIAlertController *unauthorizedAlert;

@end

@implementation ViewController

#pragma mark - Lifecyle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self requestPermission];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Setup

- (void)setupWithAuthorization:(PHAuthorizationStatus)status {
    if (status == PHAuthorizationStatusAuthorized) {
        [self setupAuthorized];
    } else {
        [self setupUnauthorized];
    }
}

- (void)setupAuthorized {

}

- (void)setupUnauthorized {
    [self presentViewController:self.unauthorizedAlert animated:YES completion:nil];
}


#pragma mark - Photo permission

- (void)requestPermission {
    __weak typeof(self) wSelf = self;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [wSelf setupWithAuthorization:status];
        });
    }];
}


#pragma mark - Private properties

- (UIAlertController *)unauthorizedAlert {
    if (!_unauthorizedAlert) {
        _unauthorizedAlert = [UIAlertController
                              alertControllerWithTitle:@"Нет доступа к фотографиям"
                              message:@"Для работы приложения необходим доступ к фотографиям"
                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* exitButton = [UIAlertAction
                                    actionWithTitle:@"Выход"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        exit(0);
                                    }];
        UIAlertAction* settingsButton = [UIAlertAction
                                     actionWithTitle:@"Настройки доступа"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                         exit(0);
                                     }];

        [_unauthorizedAlert addAction:settingsButton];
        [_unauthorizedAlert addAction:exitButton];
    }
    return _unauthorizedAlert;
}


@end
