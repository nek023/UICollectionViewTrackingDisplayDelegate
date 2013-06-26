//
//  UICollectionViewTrackingDisplayDelegate.h
//  UICollectionViewTrackingDisplayDelegate
//
//  Created by Katsuma Tanaka on 2013/06/16.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UICollectionView;
@class UICollectionViewCell;
@class NSIndexPath;

@protocol UICollectionViewTrackingDisplayDelegate <NSObject>

@optional
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end
