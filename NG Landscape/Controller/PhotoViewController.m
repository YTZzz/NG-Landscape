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

@interface PhotoViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *photoCollectionViewLayout;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (assign, nonatomic) BOOL isHiddenAnimationRunning;
@property (strong, nonatomic) NSString * reuseIdentifier;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAllViewsAndVariables];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear self.row = %d", self.row);
    NSLog(@"viewWillAppear %@", self.photoCollectionView);
    [self.photoCollectionView setContentOffset:CGPointMake(self.row * SCREEN_WIDTH, 0) animated:NO];
    [self setTextViewContent];
}


- (void)initAllViewsAndVariables {
    
    self.isHiddenAnimationRunning = NO;
    
    PhotoObject * photoObject = [self.photoObjectsArray objectAtIndex:self.row];
    self.title = photoObject.title;

    self.reuseIdentifier = @"PhotoCollectionViewCell";
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    UINib *cellNib = [UINib nibWithNibName:self.reuseIdentifier bundle:nil];
    [self.photoCollectionView registerNib:cellNib forCellWithReuseIdentifier:self.reuseIdentifier];
    self.photoCollectionViewLayout.sectionInset = UIEdgeInsetsZero;
    self.photoCollectionViewLayout.minimumLineSpacing = 0;
    self.photoCollectionViewLayout.minimumInteritemSpacing = 0;
    self.photoCollectionViewLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    self.photoCollectionView.contentSize = CGSizeMake(self.photoObjectsArray.count * SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [self rotateCollectionViewWithSize:size];
}

- (void)rotateCollectionViewWithSize:(CGSize)size {

    self.photoCollectionViewLayout.itemSize = CGSizeMake(size.width, size.height);
    
    __weak typeof(self) weakSelf = self;
    [self.photoCollectionView performBatchUpdates:nil completion:^(BOOL finished){
        if (finished) {
            [weakSelf.photoCollectionView scrollRectToVisible:CGRectMake(self.row * size.width, size.height / 2, size.width, 1)
                                                     animated:NO];
            [weakSelf.textView setContentOffset:CGPointZero animated:NO];
        }
    }];
}

- (void)setTextViewContent {
    PhotoObject * photoObject = [self.photoObjectsArray objectAtIndex:self.row];
    
    NSString * text = photoObject.title;
    if (photoObject.author) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@" -  %@", photoObject.author]];
    }
    if (photoObject.content) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"\n\n%@", photoObject.content]];
    }
    self.textView.text = text;
}

- (void)tapImageView:(UITapGestureRecognizer *)sender {

    if (self.isHiddenAnimationRunning == YES) {
        return;
    }
    [self setToolBarAndTextViewHideOrNot:(!self.textView.hidden)];
}

- (void)doubleTapImageView:(UITapGestureRecognizer *)sender {

    if (self.textView.hidden == YES) {
        return;
    }
    [self setToolBarAndTextViewHideOrNot:YES];
}

- (void)setToolBarAndTextViewHideOrNot:(BOOL)hidden {
    
    self.isHiddenAnimationRunning = YES;
    [UIView animateWithDuration:0.2
                     animations:^(){
                         self.toolBar.hidden = hidden;
                         self.textView.hidden = hidden;
                     }
                     completion:^(BOOL finished){
                         if (finished == YES) {
                             self.isHiddenAnimationRunning = NO;
                         }
                     }
     ];
}
- (IBAction)touchSaveButton:(id)sender {
    
}

- (IBAction)touchBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)touchCollectButton:(id)sender {
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.photoObjectsArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    PhotoCollectionViewCell * photoCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier
                                                                                                  forIndexPath:indexPath];
    PhotoObject * photoObject = [self.photoObjectsArray objectAtIndex:indexPath.row];
    [photoCollectionViewCell.imageView sd_setImageWithURL:[NSURL URLWithString:photoObject.url] placeholderImage:[UIImage imageNamed:@"placeHolder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        [photoCollectionViewCell finishSetImage:image];
    }];
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
    
    int row = (scrollView.contentOffset.x + 0.5 * scrollView.frame.size.width) / scrollView.frame.size.width;
    if (row < self.photoObjectsArray.count && self.row != row) {
        self.row = row;
        [self setTextViewContent];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
