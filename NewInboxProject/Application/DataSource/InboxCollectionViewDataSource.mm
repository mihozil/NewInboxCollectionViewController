//
//  InboxCollectionViewDataSource.m
//  NewInboxProject
//
//  Created by CPU11806 on 5/25/18.
//  Copyright © 2018 CPU11806. All rights reserved.
//

#import "InboxCollectionViewDataSource.h"
#import "InboxCollectionViewCell.h"
#import "InboxDataSourceItem.h"
#import "InboxDataLoader.h"

@implementation InboxCollectionViewDataSource

- (void)registerReusableViewsWithCollectionView:(UICollectionView *)collectionView {
    [super registerReusableViewsWithCollectionView:collectionView];
    [collectionView registerClass:[InboxCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([InboxCollectionViewCell class])];
}

- (void)loadContentWithProgress:(AAPLLoadingProgress *)progress {
    loadContentCompletion loadCompletion = ^(NSArray<InboxDataSourceItem*>* items, NSError* error) {
        if (progress.cancelled)
            return;
        if (error) {
            [progress doneWithError:error];
            return;
        }
        if (!items || items.count==0) {
            [progress updateWithNoContent:^(InboxCollectionViewDataSource* me) {
                me.items = @[];
            }];
            return;
        }
        
        [progress updateWithContent:^(InboxCollectionViewDataSource *me){
            me.items = items;
        }];
    };
    
    [[InboxDataLoader sharedInstance]loadContentWithCompletionHandle:loadCompletion];
}

#pragma mark subClass
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    InboxCollectionViewCell *cell = (InboxCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([InboxCollectionViewCell class]) forIndexPath:indexPath];
    InboxDataSourceItem *dataSourceItem = (InboxDataSourceItem*)[self.items objectAtIndex:indexPath.row];
    [cell setObject:dataSourceItem];
    
    return cell;
}

@end
