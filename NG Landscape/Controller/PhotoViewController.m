//
//  PhotoViewController.m
//  NG Landscape
//
//  Created by Sodapig on 2016/10/25.
//  Copyright © 2016年 Taozhu Ye. All rights reserved.
//

#import "PhotoViewController.h"
#import "UIImageView+WebCache.h"
#import "Definition.h"
#import "PhotoCollectionViewCell.h"
#import "PhotoObject.h"
#import "UIImageView+WebCache.h"

@interface PhotoViewController () <UICollectionViewDataSource, UICollectionViewDelegate, HideOtherViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *photoCollectionViewLayout;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (assign, nonatomic) BOOL shouldStatusBarHidden;
@property (assign, nonatomic) BOOL isHiddenAnimationRunning;
@property (strong, nonatomic) NSString * reuseIdentifier;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAllViewsAndVariables];
}

- (BOOL)prefersStatusBarHidden {
    return _shouldStatusBarHidden;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_photoCollectionView setContentOffset:CGPointMake(_row * SCREEN_WIDTH, 0) animated:NO];
    [self setTextViewContent];
}

- (void)initAllViewsAndVariables {
    
    _isHiddenAnimationRunning = NO;
    _shouldStatusBarHidden = NO;
    if (SCREEN_HEIGHT < SCREEN_WIDTH) {
        _shouldStatusBarHidden = YES;
    }
    
    PhotoObject * photoObject = [_photoObjectsArray objectAtIndex:_row];
    self.title = photoObject.title;

    _reuseIdentifier = @"PhotoCollectionViewCell";
    
    UINib *cellNib = [UINib nibWithNibName:_reuseIdentifier bundle:nil];
    [_photoCollectionView registerNib:cellNib forCellWithReuseIdentifier:_reuseIdentifier];
    _photoCollectionViewLayout.sectionInset = UIEdgeInsetsZero;
    _photoCollectionViewLayout.minimumLineSpacing = 0;
    _photoCollectionViewLayout.minimumInteritemSpacing = 0;
    CGFloat screenHeight = SCREEN_HEIGHT;
    CGFloat screenWidth = SCREEN_WIDTH;
    _photoCollectionViewLayout.itemSize = CGSizeMake(screenWidth, screenHeight);
    _photoCollectionView.contentSize = CGSizeMake(_photoObjectsArray.count * screenWidth, screenHeight);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [self rotateCollectionViewWithSize:size];
}

- (void)rotateCollectionViewWithSize:(CGSize)size {

    _photoCollectionViewLayout.itemSize = CGSizeMake(size.width, size.height);
    
    [_photoCollectionView reloadData];
    [_photoCollectionView setContentOffset:CGPointMake(_row * size.width, 0) animated:NO];

//    [_photoCollectionView performBatchUpdates:nil completion:^(BOOL finished){
//        [_photoCollectionView setContentOffset:CGPointMake(_row * size.width, 0) animated:NO];
//    }];
}

- (void)setTextViewContent {
    PhotoObject * photoObject = [_photoObjectsArray objectAtIndex:_row];
    
    NSString * text = photoObject.title;
    NSString * author = photoObject.author;
    NSString * content = photoObject.content;
    
    if (author && [author isEqualToString:@""] == NO) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@" -  %@", author]];
    }
    if (photoObject.content) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"\n\n%@", content]];
    }
    _textView.text = text;
}

- (void)hideOrShowOtherViews {

    if (_isHiddenAnimationRunning == YES) {
        return;
    }
    [self setToolBarAndTextViewHideOrNot:(!_textView.hidden)];
}

- (void)hideOtherViews {
    [self setToolBarAndTextViewHideOrNot:YES];
}

- (void)setToolBarAndTextViewHideOrNot:(BOOL)hidden {
    
    _isHiddenAnimationRunning = YES;
    [UIView animateWithDuration:0.2
                     animations:^(){
                         _toolBar.hidden = hidden;
                         _textView.hidden = hidden;
                     }
                     completion:^(BOOL finished){
                         if (finished == YES) {
                             _isHiddenAnimationRunning = NO;
                         }
                     }
     ];
}
- (IBAction)touchSaveButton:(id)sender {
    
}

- (IBAction)touchBackButton:(id)sender {
    if (SCREEN_WIDTH < SCREEN_HEIGHT) {
        _shouldStatusBarHidden = NO;
        [self setNeedsStatusBarAppearanceUpdate];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)touchCollectButton:(id)sender {
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _photoObjectsArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    PhotoCollectionViewCell * photoCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:_reuseIdentifier
                                                                                                  forIndexPath:indexPath];
    PhotoObject * photoObject = [_photoObjectsArray objectAtIndex:indexPath.row];
    [photoCollectionViewCell.imageView sd_setImageWithURL:[NSURL URLWithString:photoObject.url]
                                         placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    photoCollectionViewCell.delegate = self;
    
    return photoCollectionViewCell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCollectionViewCell * photoCollectionViewCell = (PhotoCollectionViewCell *)cell;
    [photoCollectionViewCell willDisplay];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat scrollViewWidth = scrollView.frame.size.width;
    CGFloat offSetX = scrollView.contentOffset.x;
    
    int row = (offSetX + 0.5 * scrollViewWidth) / scrollViewWidth;
    if (row < _photoObjectsArray.count && _row != row) {
        _row = row;
        [self setTextViewContent];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
