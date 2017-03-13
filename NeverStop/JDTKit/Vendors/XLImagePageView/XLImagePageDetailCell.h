//
//  MyCollectionViewCell.h
//  Animation
//
//  Created by Eiwodetianna on 15/6/19.
//  Copyright © 2015年 jinxinliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLImagePageDetailCellDelegate <NSObject>

- (void)XLImagePageDetailCellDidSelectedWithIndex:(NSInteger)cellIndex;

@end


@interface XLImagePageDetailCell : UICollectionViewCell

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, weak) id<XLImagePageDetailCellDelegate>delegate; 

@end
