//
//  PhotoCollectionViewCell.h
//  NG Landscape
//
//  Created by Sodapig on 2016/10/29.
//  Copyright © 2016年 Taozhu Ye. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HideOtherViewDelegate <NSObject>

- (void)hideOtherViews;
- (void)hideOrShowOtherViews;

@end



@interface PhotoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) id <HideOtherViewDelegate> delegate;

- (void)willDisplay;

@end
