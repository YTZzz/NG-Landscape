//
//  PhotoCollectionViewCell.m
//  NG Landscape
//
//  Created by Sodapig on 2016/10/29.
//  Copyright © 2016年 Taozhu Ye. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "Definition.h"

@interface PhotoCollectionViewCell () <UIScrollViewDelegate>

@property (assign, nonatomic) CGFloat imageDisplayWidth;
@property (assign, nonatomic) CGFloat imageDisplayHeight;
@property (assign, nonatomic) CGRect imageRectInImageView;
@property (assign, nonatomic) int maxOutSideSpace;

@end

@implementation PhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.maxOutSideSpace = 20;
    
    self.scrollView.delegate = self;

    UITapGestureRecognizer * tapImageViewGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
    tapImageViewGesture.numberOfTouchesRequired = 1;
    tapImageViewGesture.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:tapImageViewGesture];
    
    UITapGestureRecognizer * doubleTapImageViewGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapImageView:)];
    doubleTapImageViewGesture.numberOfTouchesRequired = 1;
    doubleTapImageViewGesture.numberOfTapsRequired = 2;
    [self.imageView addGestureRecognizer:doubleTapImageViewGesture];
    
    [tapImageViewGesture requireGestureRecognizerToFail:doubleTapImageViewGesture];
}

- (void)tapImageView:(UITapGestureRecognizer *)sender {
    
    if ([self.delegate respondsToSelector:@selector(tapImageView:)]) {
        [self.delegate tapImageView:sender];
    }
}

- (void)doubleTapImageView:(UITapGestureRecognizer *)sender {
    
    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
        
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
        
    } else {
        
        if ([self.delegate respondsToSelector:@selector(doubleTapImageView:)]) {
            [self.delegate doubleTapImageView:sender];
        }
        
        CGPoint tapPoint = [sender locationInView:self.imageView];
        
        CGFloat w = self.scrollView.frame.size.width / self.scrollView.maximumZoomScale;
        CGFloat h = self.scrollView.frame.size.height / self.scrollView.maximumZoomScale;
        CGFloat x = tapPoint.x - (w / self.scrollView.maximumZoomScale);
        CGFloat y = tapPoint.y - (h / self.scrollView.maximumZoomScale);
        
        [self.scrollView zoomToRect:CGRectMake(x, y, w, h) animated:YES];
    }
}

- (void)finishSetImage:(UIImage *)image {
    
    CGFloat imageScaleWidth = self.imageView.bounds.size.width / self.imageView.image.size.width ;
    CGFloat imageScaleHeight = self.imageView.bounds.size.height / self.imageView.image.size.height;
    CGFloat imageScale = fminf(imageScaleWidth, imageScaleHeight);
    self.imageDisplayWidth = self.imageView.image.size.width * imageScale;
    self.imageDisplayHeight = self.imageView.image.size.height * imageScale;
    
    CGSize imageViewSize = self.imageView.bounds.size;
    self.imageRectInImageView = CGRectMake((imageViewSize.width - self.imageDisplayWidth) / 2,
                                           (imageViewSize.height - self.imageDisplayHeight) / 2,
                                           imageViewSize.width,
                                           imageViewSize.height);
}

- (void)willDisplay {
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:NO];
}

// 将有黑边的方向（水平或垂直）图像居中
- (void)scrollImageToCenter {
    
    CGFloat scale = self.scrollView.zoomScale;
    if (scale == self.scrollView.minimumZoomScale) {
        return;
    }

    BOOL isNeedToScrollToCenter = NO;
    
    CGFloat willMoveToX = self.scrollView.contentOffset.x;
    if (self.imageDisplayWidth * scale < SCREEN_WIDTH) {
        willMoveToX = (self.scrollView.contentSize.width - self.scrollView.frame.size.width) / 2;
        isNeedToScrollToCenter = YES;
    }
    CGFloat willMoveToY = self.scrollView.contentOffset.y;
    if (self.imageDisplayHeight * scale < SCREEN_HEIGHT) {
        willMoveToY = (self.scrollView.contentSize.height - self.scrollView.frame.size.height) / 2;
        isNeedToScrollToCenter = YES;
    }
    
    if (isNeedToScrollToCenter == NO) {
        return;
    }
    [self.scrollView setContentOffset:CGPointMake(willMoveToX, willMoveToY) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    if (SCREEN_WIDTH > SCREEN_HEIGHT) {
        return;
    }
    [self scrollImageToCenter];
}

@end
