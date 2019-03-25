//
//  EOCAutoDictionary.m
//  practice_消息转发机制
//
//  Created by luke on 2019/3/25.
//  Copyright © 2019 luke. All rights reserved.
//



/*
 动态给其添加set和get方法。
 */




#import "EOCAutoDictionary.h"

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface EOCAutoDictionary()
@property (nonatomic, strong) NSMutableDictionary * backingStore;
@end

@implementation EOCAutoDictionary

@dynamic string, number, date, opaqueObject;
// dynamic  使其不会自动生成 set get方法

- (instancetype)init{
    if (self = [super init]) {
        _backingStore = [NSMutableDictionary new];
    }
    return self;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel{

    NSString * selectorString = NSStringFromSelector(sel);

    if ([selectorString hasPrefix:@"set"]) {
        class_addMethod(self, sel, (IMP)autoDictionarySetter, "v@:@");
    }else{
        class_addMethod(self, sel, (IMP)autoDictionaryGetter, "@@:");
    }
    return YES;
}
/*


 class_addMethod 最后一个参数是 type encodings ，用来标识IMP函数实现的返回值与参数，
 v  void
 @  object (whether statically typed or typed id)
 :  method selector (SEL)

 */


//
id autoDictionaryGetter(id self, SEL _cmd){
    // Get the backing store from the object
    EOCAutoDictionary * typedSelf = (EOCAutoDictionary*)self;
    NSMutableDictionary * backingStore = typedSelf.backingStore;

    // The key is simply the selector name
    NSString * key = NSStringFromSelector(_cmd);

    // Return the value
    return [backingStore objectForKey:key];

}



void autoDictionarySetter(id self, SEL _cmd, id value) {

    // Get the backing store from the object
    EOCAutoDictionary * typedSelf = (EOCAutoDictionary *)self;
    NSMutableDictionary * backingStore = typedSelf.backingStore;

    /** The selector will be for example, "setOpaqueObject:".
     * We need to remove the "set", ":" and lowercase the first
     * letter of the remainder.
     */
    NSString * selectorString = NSStringFromSelector(_cmd);
    NSMutableString * key = [selectorString mutableCopy];

    // Remove the ':' at the end
    [key deleteCharactersInRange:NSMakeRange(key.length-1, 1)];
    // Remove the 'set' prefix
    [key deleteCharactersInRange:NSMakeRange(0, 3)];

    // Lowercase the first character
    NSString * lowercaseFirstChar = [[key substringToIndex:1] lowercaseString];
    [key replaceCharactersInRange:NSMakeRange(0, 1) withString:lowercaseFirstChar];

    if (value) {
        [backingStore setObject:value forKey:key];
    }else{
        [backingStore removeObjectForKey:key];
    }

}




@end
