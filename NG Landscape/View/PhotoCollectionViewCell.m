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

@property (assign, nonatomic) BOOL isWidthEqual;

@end

@implementation PhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _scrollView.delegate = self;
    
    UITapGestureRecognizer * tapScrollViewGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
    tapScrollViewGesture.numberOfTapsRequired = 1;
    tapScrollViewGesture.numberOfTouchesRequired = 1;
    [_scrollView addGestureRecognizer:tapScrollViewGesture];

    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.userInteractionEnabled = YES;
    [_scrollView addSubview:_imageView];
    
    UITapGestureRecognizer * tapImageViewGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
    tapImageViewGesture.numberOfTouchesRequired = 1;
    tapImageViewGesture.numberOfTapsRequired = 1;
    [_imageView addGestureRecognizer:tapImageViewGesture];
    
    UITapGestureRecognizer * doubleTapImageViewGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapImageView:)];
    doubleTapImageViewGesture.numberOfTouchesRequired = 1;
    doubleTapImageViewGesture.numberOfTapsRequired = 2;
    [_imageView addGestureRecognizer:doubleTapImageViewGesture];
    
    [tapImageViewGesture requireGestureRecognizerToFail:doubleTapImageViewGesture];
}

- (void)tapImageView:(UITapGestureRecognizer *)sender {
    
    if ([_delegate respondsToSelector:@selector(hideOrShowOtherViews)]) {
        [_delegate hideOrShowOtherViews];
    }
}

- (void)doubleTapImageView:(UITapGestureRecognizer *)sender {
    
    if (_scrollView.zoomScale > _scrollView.minimumZoomScale) {
        
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
        
    } else {
        
        CGPoint tapPoint = [sender locationInView:_imageView];
        
        CGFloat w = _scrollView.frame.size.width / _scrollView.maximumZoomScale;
        CGFloat h = _scrollView.frame.size.height / _scrollView.maximumZoomScale;
        CGFloat x = tapPoint.x - (w / _scrollView.maximumZoomScale);
        CGFloat y = tapPoint.y - (h / _scrollView.maximumZoomScale);
        
        [self.scrollView zoomToRect:CGRectMake(x, y, w, h) animated:YES];
    }
}

- (void)willDisplay {
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:NO];
    
    [self configImageViewSize];
}

- (void)configImageViewSize {
    CGFloat widthDivideByHeightOfImage = _imageView.image.size.width / _imageView.image.size.height;
    
    CGFloat scrollViewWidth = self.frame.size.width;
    CGFloat scrollViewHeight = self.frame.size.height;
    
    _isWidthEqual = widthDivideByHeightOfImage >= (scrollViewWidth / scrollViewHeight);
    
    if (_isWidthEqual) {
        CGFloat imageViewHeightAfter = scrollViewWidth / widthDivideByHeightOfImage;
        CGFloat imageViewYAfter = (scrollViewHeight - imageViewHeightAfter) / 2;
        _imageView.frame = CGRectMake(0, imageViewYAfter, scrollViewWidth, imageViewHeightAfter);
    } else {
        CGFloat imageViewWidthAfter = scrollViewHeight * widthDivideByHeightOfImage;
        CGFloat imageViewXAfter = (scrollViewWidth - imageViewWidthAfter) / 2;
        _imageView.frame = CGRectMake(imageViewXAfter, 0, imageViewWidthAfter, scrollViewHeight);
    }
    _scrollView.contentSize = _scrollView.bounds.size;
}


#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return _imageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    
    if ([_delegate respondsToSelector:@selector(hideOtherViews)]) {
        [_delegate hideOtherViews];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {

    CGFloat imageViewWidth = _imageView.frame.size.width;
    CGFloat imageViewHeight = _imageView.frame.size.height;
    
    if (_isWidthEqual) {
        CGFloat scrollViewHeight = scrollView.frame.size.height;
        if (imageViewHeight < scrollViewHeight) {
            CGFloat topSpaceRemain = (scrollViewHeight - imageViewHeight) / 2;
            _imageView.frame = CGRectMake(_imageView.frame.origin.x,
                                          topSpaceRemain,
                                          imageViewWidth,
                                          imageViewHeight);
        } else {
            _imageView.frame = CGRectMake(_imageView.frame.origin.x,
                                          0,
                                          imageViewWidth,
                                          imageViewHeight);
        }
    } else {
        CGFloat scrollViewWidth = scrollView.frame.size.width;
        if (imageViewWidth < scrollViewWidth) {
            CGFloat leftSpaceRemain = (scrollViewWidth - imageViewWidth) / 2;
            _imageView.frame = CGRectMake(leftSpaceRemain,
                                          _imageView.frame.origin.y,
                                          imageViewWidth,
                                          imageViewHeight);
        } else {
            _imageView.frame = CGRectMake(0,
                                          _imageView.frame.origin.y,
                                          imageViewWidth,
                                          imageViewHeight);
        }
    }
}

@end
