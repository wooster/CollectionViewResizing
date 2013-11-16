//
//  ResizableCell.h
//  CollectionViewResizing
//
//  Created by Andrew Wooster on 11/15/13.
//  Copyright (c) 2013 Andrew Wooster. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ResizingTextView.h"

@interface ResizableCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet ResizingTextView *textView;

@end
