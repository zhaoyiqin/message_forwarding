//
//  person.h
//  practice_消息转发机制
//
//  Created by luke on 2019/3/25.
//  Copyright © 2019 luke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface person : NSObject
@property(nonatomic, assign) NSInteger age;
@property(nonatomic, strong) NSMutableArray *array;
@end

NS_ASSUME_NONNULL_END
