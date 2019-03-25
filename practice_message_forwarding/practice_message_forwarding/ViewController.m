//
//  ViewController.m
//  practice_消息转发机制
//
//  Created by luke on 2019/3/25.
//  Copyright © 2019 luke. All rights reserved.
//  https://www.jianshu.com/p/9c93c7ab734d

/*
 IMP是”implementation”的缩写，它是objetive-C 方法(method)实现代码块的地址，可像C函数一样直接调用。通常情况下我们是通过[object method:parameter]或objc_msgSend()的方式向对象发送消息，然后Objective-C运行时(Objective-C runtime)寻找匹配此消息的IMP,然后调用它;但有些时候我们希望获取到IMP进行直接调用。
 */



/*
 1、 OC中调用方法其实都是由 runtime 将方法调用转化成一个 C语言的函数调用，都是向 某一个对象发送了一个消息
 
 消息发送的步骤：
 1.首先检查这个selector是不是要忽略
 2.检测这个selector的target是不是nil,  OC允许我们对一个nil对象执行任何方法不崩溃，就是因为运行时检查到targe为nil就会被忽略
 3.开始查找消息接受者所属类的实现IMP,先从cache里查找. (每个类都有这样一块缓存，方法匹配成功就将结果缓存在这样的里面，下次再发来形同的消息，执行速度就会更快了)
 4.cache没找到就去该类里面找，还没找到就去父类往上找，找到NSObject类为止。找到就执行
 5.最终没有找到，就执行 消息转发 操作
 */

/*
 消息转发机制：
 
 消息转发分为两个阶段：
 1、征询接收者，看它能否动态添加方法，已处理这个未知的SEL，这个过程叫做动态方法解析 （dynamic method resolution）
 （类方法+(BOOL)resolveInstanceMethod:(SEL)selector:查看这个类是否能新增一个实例方法用以处理此SEL）
 
 2、请接收者看有没有其他对象能处理这条消息：
 如果有：则运行期系统会把消息转给那个对象
 如果没有：则启动完整的消息转发机制，运行期系统会把与消息有关的全部细节都封装到NSInvocation对象中，再给接收者最后一次机会，令其设法解决当前还没处理的这条消息。
 （实例方法- (id)forwardTargetForSelector:(SEL)selector;:询问是否能找到未知消息的备援接受者，如果能找到备援对象，就将其返回，如果不能，就返回nil。
 
 实例方法- (void)forwardInvocation:(NSInvocation*)invocation:创建NSInvocation对象，将尚未处理的那条消息 有关的全部细节都封于其中，在触发NSInvocation对象时，“消息派发系统（message-dispatch system）”就会将消息派给目标对象。）
 
 */



#import "ViewController.h"
#import "EOCAutoDictionary.h"
#import "person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EOCAutoDictionary * eocDic = [[EOCAutoDictionary alloc] init];
    
    
    eocDic.string = @"123";
    NSLog(@"%@", eocDic.string);
    
    person * p1 = [[person alloc] init];
    p1.age = 25;
    p1.array = [[NSMutableArray alloc] initWithArray:@[@"zzz",@1111]];
    
    eocDic.opaqueObject = p1;
    
    NSMutableArray * a1 = ((person *)eocDic.opaqueObject).array;
    for (int i = 0; i<a1.count; i++) {
        NSLog(@"%@", a1[i]);
    }
    
}


@end
