//
//  TRIPPaletteSwatch.h
//  Atom
//
//  Created by dylan.tang on 17/4/11.
//  Copyright © 2017年 dylan.tang All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PaletteSwatch : NSObject

- (instancetype)initWithColorInt:(NSInteger)colorInt population:(NSInteger)population;

- (UIColor*)getColor;
- (NSString*)getColorString;
- (NSArray*)getHsl;
- (NSInteger)getPopulation;

@end
