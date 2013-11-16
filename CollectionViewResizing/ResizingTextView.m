//
//  ResizingTextView.m
//  CollectionViewResizing
//
//  Created by Andrew Wooster on 11/15/13.
//  Copyright (c) 2013 Andrew Wooster. All rights reserved.
//

#import "ResizingTextView.h"

@implementation ResizingTextView

- (void)layoutSubviews {
	[super layoutSubviews];
	if (!CGSizeEqualToSize(self.bounds.size, [self intrinsicContentSize])) {
		[self invalidateIntrinsicContentSize];
	}
}

- (CGSize)intrinsicContentSize {
	if (self.preferredMaxLayoutWidth == 0) {
		return [self sizeGivenWidth:self.bounds.size.width];
	} else {
		return [self sizeGivenWidth:self.preferredMaxLayoutWidth];
	}
}

- (CGSize)sizeGivenWidth:(CGFloat)givenWidth {
	CGSize intrinsicContentSize = self.contentSize;
	
	if (([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] != NSOrderedAscending)) {
		// Based on some of the approaches here:
		// http://stackoverflow.com/questions/18368567/uitableviewcell-with-uitextview-height-in-ios-7
		CGRect rect = CGRectMake(0, 0, givenWidth, 10000);
		CGRect insetRect = UIEdgeInsetsInsetRect(rect, self.textContainerInset);
		insetRect = UIEdgeInsetsInsetRect(insetRect, self.contentInset);
		insetRect = CGRectInset(insetRect, self.textContainer.lineFragmentPadding, 0);
		
		CGFloat width = CGRectGetWidth(insetRect);
		CGRect textSize = [self.attributedText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
		
		CGFloat verticalPadding = rect.size.height - insetRect.size.height;
		CGFloat actualHeight = ceil(CGRectGetHeight(textSize) + verticalPadding);
		
		intrinsicContentSize.height = actualHeight;
		intrinsicContentSize.width = CGRectGetWidth(rect);
		return intrinsicContentSize;
	}
	return intrinsicContentSize;
}
@end
