//
//  InboxDataLoader.m
//  NewInboxProject
//
//  Created by CPU11806 on 5/25/18.
//  Copyright © 2018 CPU11806. All rights reserved.
//

#import "InboxDataLoader.h"
#import "InboxDataSourceItem.h"
#import "InboxCollectionViewCellItem.h"

@interface InboxDataLoader()

@end

@implementation InboxDataLoader {
    NSMutableArray *items;
}

+ (instancetype)sharedInstance {
    static InboxDataLoader *dataLoader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!dataLoader)
            dataLoader = [[InboxDataLoader alloc]init];
    });
    return dataLoader;
}

- (void)loadContentWithCompletionHandle:(loadContentCompletion)completion {
    [self fetchChatsWithCompletionHandle:^(NSArray<NSDictionary*>*entities, NSError*error){
        if (error) {
            if (completion)
                completion(nil,error);
            return;
        }
        [self creatingItemsByEntities:entities];
    }];
}

#pragma mark creatingItems
- (void)creatingItemsByEntities:(NSArray*)entities {
    items = [[NSMutableArray alloc]init];
    for (NSDictionary *entity in entities) {
        InboxDataSourceItem *dataSourceItem = [[InboxDataSourceItem alloc]init];
        
        InboxCollectionViewCellItem *item = [[InboxCollectionViewCellItem alloc]init];
        item.title = [entity objectForKey:@"title"];
        item.caption = [entity objectForKey:@"detail"];
        item.timeStamp = [entity objectForKey:@"lastUpdate"];
        item.avatarUrl = [entity objectForKey:@"icon"];
        
        CGSize cellSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 80);
        
        
        struct InboxDataSourceItemLayout layout = {InboxDataSourceCellContainerView, CGRectMake(0, 0, cellSize.width, cellSize.height), {InboxDataSourceCellAvatarView, CGRectMake(0, 0, cellSize.height, cellSize.height)}};
        
    }
}


#pragma mark fetch

- (void)fetchChatsWithCompletionHandle:(void(^)(NSArray<NSDictionary*>*chats, NSError*error))completion {
    
    if (completion) {
        [self fetchJsonResourceWithName:@"chat" completionHandle:^(NSDictionary*json, NSError*error) {
            NSArray *entities = json[@"result"];
            completion(entities,error);
        }];
    }
}

- (void)fetchJsonResourceWithName:(NSString*)name completionHandle:(void (^) (NSDictionary*json, NSError*error))completion {
    NSURL *resourceURL = [[NSBundle mainBundle]URLForResource:name withExtension:@"json"];
    if (!resourceURL) {
        NSAssert(NO, @"invalid jsonResource");
    }
    
    NSError*error;
    NSData *data = [NSData dataWithContentsOfURL:resourceURL options:NSDataReadingMappedIfSafe error:&error];
    if (!data) {
        NSLog(@"No Data");
        return;
    }
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!json) {
        if (completion)
            completion(nil,error);
    }
    
    NSNumber *delayResultNumber = json[@"delayResult"];
    if (delayResultNumber && [delayResultNumber isKindOfClass:[NSNumber class]]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([delayResultNumber floatValue] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (completion)
                completion(json,error);
        });
    } else {
        if (completion)
            completion(json,error);
    }
}

@end
