//
//  EOCAutoDictionary.h
//  practice_消息转发机制
//
//  Created by luke on 2019/3/25.
//  Copyright © 2019 luke. All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOCAutoDictionary : NSObject

@property (nonatomic, strong) NSString * string;
@property (nonatomic, strong) NSNumber * number;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) id opaqueObject;


@end

NS_ASSUME_NONNULL_END
