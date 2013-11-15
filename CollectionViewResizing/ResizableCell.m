//
//  ResizableCell.m
//  CollectionViewResizing
//
//  Created by Andrew Wooster on 11/15/13.
//  Copyright (c) 2013 Andrew Wooster. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "ResizableCell.h"

@implementation ResizableCell

- (void)setup {
	self.layer.borderColor = [UIColor grayColor].CGColor;
	self.layer.borderWidth = 1;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
	[self setup];
}

@end
