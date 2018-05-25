//
//  InboxCollectionViewCell.m
//  ZaloiOS-Development_InHouse
//
//  Created by CPU11806 on 5/25/18.
//

#import "InboxCollectionViewCell.h"
#import "InboxDataSourceObject.h"
#include <queue>
#include <pair>

@interface InboxCollectionViewCell ()

@property (strong, nonatomic) AFImageView *avatarImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *captionLabel;
@property (strong, nonatomic) UILabel *topicTitleLabel;
@property (strong, nonatomic) UILabel *timeStampLabel;

@end

@implementation InboxCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

#pragma mark - PROPERTY
- (AFImageView*) avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[AFImageView alloc]init];
    }
    return _avatarImageView;
}

#pragma mark - setObject
- (void)setObject:(InboxDataSourceObject*)object {
    
    typedef pair<InboxDataSourceObjectLayout, UIView*> p2;
    queue<p2> layoutQueue;
    layoutQueue.push({object.layout,self.contentView});
    
    while (!layoutQueue.empty()) {
        p2 layoutPair = layoutQueue.front();
        InboxDataSourceObjectLayout layout = layoutPair.first;
        layoutQueue.pop();
        UIView *superView =layoutPair.second;
        
        UIView*view = [self addSubViewType:layout.cellComponentType frame:layout.frame superView:superView];
        
        for (auto it= layout.children.begin(); it!=layout.children.end(); it++) {
            InboxDataSourceObjectLayout childLayout = *it;
            layoutQueue.push({childLayout,view});
        }
        
    }
    
}

- (UIView*)addSubViewType:(InboxDataSourceCellComponentType)type frame:(CGRect)frame superView:(UIView*)superView {
    UIView *componenentView;
    switch (type) {
        case InboxDataSourceCellContainerView:
            componenentView = [[UIView alloc]initWithFrame:frame];
            break;
        case InboxDataSourceCellAvatarView:
            componenentView = self.avatarImageView;
            break;
        case InboxDataSourceCellTitleLabel:
            componenentView = self.titleLabel;
            break;
        case InboxDataSourceCellCaptionLabel:
            componenentView = self.captionLabel;
            break;
        case InboxDataSourceCellTopicTitle:
            componenentView = self.topicTitleLabel;
            break;
        case InboxDataSourceCellTimeStampLabel:
            componenentView = self.timeStampLabel;
            break;
        default:
            break;
    }
    [componenentView setFrame:frame];
    [superView addSubview:componenentView];
    return componenentView;
}


@end
