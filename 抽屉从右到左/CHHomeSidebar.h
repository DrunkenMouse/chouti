//
//  CHHomeSidebar.h
//  anbang_ios
//
//  Created by 王奥东 on 17/3/22.
//  Copyright © 2017年 ch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MenuButtonClickedBlock) (NSInteger index,NSString *title,NSInteger titleCounts);

@interface CHHomeSidebar : UIView

-(void)trigger;

@property(nonatomic, copy) MenuButtonClickedBlock menuClickBlock;

@end
