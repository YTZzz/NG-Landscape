//
//  PhotoViewController.m
//  NG Landscape
//
//  Created by Sodapig on 2016/10/20.
//  Copyright © 2016年 Taozhu Ye. All rights reserved.
//

#import "PhotoViewController.h"
#import "UIImageView+WebCache.h"
#import "Definition.h"

@interface PhotoViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *titleAndAuthorLabel;
@property (weak, nonatomic) IBOutlet UITextView *photoDetailTextView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *doubleTapGesture;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.isNeedRefreshData = YES;
    self.photoDetailView.layer.cornerRadius = 8;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 2.0;
    self.tapGesture.numberOfTapsRequired = 1;
    self.doubleTapGesture.numberOfTapsRequired = 2;
    [self.tapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isNeedRefreshData == YES) {
        [self refreshData];
        self.isNeedRefreshData = NO;
    }
}

- (void)refreshData {
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.photoObject.url] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    
    NSString * titleAndAuthorStr = [NSString stringWithString:self.photoObject.title];
    if ([self.photoObject.author isEqualToString:@""] == NO) {
        titleAndAuthorStr = [titleAndAuthorStr stringByAppendingString:[NSString stringWithFormat:@" - %@", self.photoObject.author]];
    }
    self.titleAndAuthorLabel.text = titleAndAuthorStr;
    
    self.photoDetailTextView.text = self.photoObject.content;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapImageView:(id)sender {
    
    BOOL setHiddenOrNot = !self.photoDetailView.isHidden;
    
    [self.photoDetailView setHidden:setHiddenOrNot];
    [self.navigationController.navigationBar setHidden:setHiddenOrNot];
}

- (IBAction)doubleTapImageView:(UITapGestureRecognizer *)sender {
    
    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
        
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
        
    } else {
        
        CGPoint touchPoint = [sender locationInView:sender.view];
        CGSize scrollViewSize = self.scrollView.bounds.size;
        
        CGFloat widthAfterZoom = scrollViewSize.width / self.scrollView.maximumZoomScale;
        CGFloat heightAfterZoom = scrollViewSize.height / self.scrollView.maximumZoomScale;
        CGFloat xAfterZoom = touchPoint.x - ( widthAfterZoom / self.scrollView.maximumZoomScale );
        CGFloat yAfterZoom = touchPoint.y - ( heightAfterZoom / self.scrollView.maximumZoomScale );
        
        CGRect rect = CGRectMake(xAfterZoom, yAfterZoom, widthAfterZoom, heightAfterZoom);
        [self.photoDetailView setHidden:YES];
        [self.scrollView zoomToRect:rect animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
