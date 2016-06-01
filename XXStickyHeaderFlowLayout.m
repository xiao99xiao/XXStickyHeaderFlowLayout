//
//  XXStickyHeaderFlowLayout.m
//  Kaomoji Lover
//
//  Created by Xiao Xiao on 16/5/15.
//  Copyright © 2016年 Xiao Xiao. All rights reserved.
//

#import "XXStickyHeaderFlowLayout.h"

@implementation XXStickyHeaderFlowLayout

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *attributesOfAllItems = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    NSCollectionView * const collectionView = self.collectionView;
    CGPoint const contentOffset = [_scrollView documentVisibleRect].origin;
    
    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
    for (NSCollectionViewLayoutAttributes *layoutAttributes in attributesOfAllItems) {
        if (layoutAttributes.representedElementCategory == NSCollectionElementCategoryItem) {
            [missingSections addIndex:layoutAttributes.indexPath.section];
        }
    }
    for (NSCollectionViewLayoutAttributes *layoutAttributes in attributesOfAllItems) {
        if ([layoutAttributes.representedElementKind isEqualToString:NSCollectionElementKindSectionHeader]) {
            [missingSections removeIndex:layoutAttributes.indexPath.section];
        }
    }
    
    [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        
        NSCollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:NSCollectionElementKindSectionHeader atIndexPath:indexPath];
        
        if (layoutAttributes) {
            [attributesOfAllItems addObject:layoutAttributes];
        }
        
    }];
    
    for (NSCollectionViewLayoutAttributes *layoutAttributes in attributesOfAllItems) {
        
        if ([layoutAttributes.representedElementKind isEqualToString:NSCollectionElementKindSectionHeader]) {
            
            NSInteger section = layoutAttributes.indexPath.section;
            NSInteger numberOfItemsInSection = [collectionView numberOfItemsInSection:section];
            
            NSIndexPath *firstItemIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            NSIndexPath *lastItemIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1)) inSection:section];
            
            NSCollectionViewLayoutAttributes *firstItemAttributes = [self layoutAttributesForItemAtIndexPath:firstItemIndexPath];
            NSCollectionViewLayoutAttributes *lastItemAttributes = [self layoutAttributesForItemAtIndexPath:lastItemIndexPath];
            
            CGFloat headerHeight = CGRectGetHeight(layoutAttributes.frame);
            CGPoint origin = layoutAttributes.frame.origin;
            origin.y = MIN(
                           MAX(
                               contentOffset.y,
                               (CGRectGetMinY(firstItemAttributes.frame) - headerHeight)
                               ),
                           (CGRectGetMaxY(lastItemAttributes.frame) - headerHeight)
                           );
            
            layoutAttributes.zIndex = 1024;
            layoutAttributes.frame = (CGRect){
                .origin = origin,
                .size = layoutAttributes.frame.size
            };
            
        }
        
    }
    
    return attributesOfAllItems;
    
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    
    return YES;
    
}

@end
