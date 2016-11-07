//
//  PhotoCollectionViewCell.h
//  NG Landscape
//
//  Created by Sodapig on 2016/10/29.
//  Copyright © 2016年 Taozhu Ye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (assign, nonatomic) id delegate;

- (void)finishSetImage:(UIImage*)image;
- (void)willDisplay;

@end
