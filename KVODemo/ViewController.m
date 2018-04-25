//
//  ViewController.m
//  KVODemo
//
//  Created by apple on 2018/4/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ViewController.h"
#import "KVOModel.h"
@interface ViewController ()
@property (nonatomic, strong) KVOModel *kvoModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.kvoModel = [[KVOModel alloc]init];
    
    /*1.注册对象myKVO为被观察者: option中，
     NSKeyValueObservingOptionOld 以字典的形式提供 “初始对象数据”;
     NSKeyValueObservingOptionNew 以字典的形式提供 “更新后新的数据”; */
    [self.kvoModel addObserver:self forKeyPath:@"num" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

/* 2.只要object的keyPath属性发生变化，就会调用此回调方法，进行相应的处理：UI更新：*/
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    // 判断是否为self.myKVO的属性“num”:
    if([keyPath isEqualToString:@"num"] && object == self.kvoModel){
        // 响应变化处理：UI更新（label文本改变）
        self.numLabel.text = [NSString stringWithFormat:@"当前的num值为：%@",[change valueForKey:@"new"]];
    }
    
    //change的使用：上文注册时，枚举为2个，因此可以提取change字典中的新、旧值的这两个方法
    NSLog(@"\\noldnum:%@ newnum:%@",[change valueForKey:@"old"],
          [change valueForKey:@"new"]);

}

/*KVO以及通知的注销，一般是在-(void)dealloc中编写。
 至于很多小伙伴问为什么要在didReceiveMemoryWarning？因为这个例子是在书本上看到的，所以试着使用它的例子。
 但小编还是推荐把注销行为放在-(void)dealloc中。(严肃脸😳)
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.kvoModel removeObserver:self forKeyPath:@"num" context:nil];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeNumClick:(id)sender {
    self.kvoModel.num += 1;

}

@end
