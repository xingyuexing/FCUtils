//
//  FCCutImageViewController.h
//  FCUtils
//
//  Created by 宋明月 on 2017/4/10.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FCCutImageViewController;

@protocol FCCutImageViewControllerDelegate <NSObject>

- (void)imageCropper:(FCCutImageViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(FCCutImageViewController *)cropperViewController;

@end


@interface FCCutImageViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic,   weak) id<FCCutImageViewControllerDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (instancetype)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
