//
//  ZChoiceBack.h
//  SeaGuest
//
//  Created by 广为网络 on 16/3/4.
//  Copyright © 2016年 广为网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZChoiceBack : UIView

@property (nonatomic,strong) void (^myBlock) (NSInteger buttonTag);
@property (nonatomic,strong) UIScrollView * buttonBackView;
- (id)initWithFrame:(CGRect)frame;
- (void)buttonBackArr:(NSArray *)buttonArr;
- (void)myShow;
@end
