//
//  InboxCollectionViewCell.h
//  ZaloiOS-Development_InHouse
//
//  Created by CPU11806 on 5/25/18.
//

#import "AAPLCollectionViewCell.h"
@class InboxDataSourceObject;

@interface InboxCollectionViewCell : AAPLCollectionViewCell

@property (strong, nonatomic) InboxDataSourceObject *object;

@end
