//
//  InboxDataSourceObject.h
//  ZaloiOS-Development_InHouse
//
//  Created by CPU11806 on 5/25/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <vector>

using namespace std;

typedef enum {
    InboxDataSourceCellContainerView = 0,
    InboxDataSourceCellAvatarView,
    InboxDataSourceCellTitleLabel,
    InboxDataSourceCellCaptionLabel,
    InboxDataSourceCellTopicTitle,
    InboxDataSourceCellTimeStampLabel,
    
} InboxDataSourceCellComponentType;

struct InboxDataSourceObjectLayout{
    InboxDataSourceCellComponentType cellComponentType;
    CGRect frame;
    vector<InboxDataSourceObjectLayout> children;
};

@interface InboxDataSourceItem : NSObject

@property (nonatomic) InboxDataSourceObjectLayout layout;
@property (strong, nonatomic) id item;

@end
