//
//  ViewController.m
//  CollectionViewResizing
//
//  Created by Andrew Wooster on 11/15/13.
//  Copyright (c) 2013 Andrew Wooster. All rights reserved.
//

#include <stdlib.h>

typedef NS_ENUM(NSInteger, SizingApproach) {
	SizingApproachNone,
	SizingApproachAddConstraintCollectionView,
	SizingApproachAddConstraintCollectionViewContentView,
	SizingApproachManualCalculation,
};

#define SIZING_APPROACH SizingApproachAddConstraintCollectionView

#import "ViewController.h"

#import "LoremIpsum.h"
#import "ResizableCell.h"

static NSString *const ResizableCellReuseIdentifier = @"ResizableCell";

@interface ViewController ()

@end

@implementation ViewController {
	ResizableCell *sizingCell;
	
	NSMutableArray *data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UINib *resizableCellNib = [UINib nibWithNibName:@"ResizableCell" bundle:nil];
	sizingCell = [[resizableCellNib instantiateWithOwner:self options:nil] firstObject];
	
	[self.collectionView registerNib:resizableCellNib forCellWithReuseIdentifier:ResizableCellReuseIdentifier];
	
	data = [NSMutableArray array];
	
	LoremIpsum *ipsum = [[LoremIpsum alloc] init];
	for (NSUInteger i = 0; i < 40; i++) {
		[data addObject:[ipsum sentences:arc4random()%3 + 1]];
	}
	
	[self.collectionView reloadData];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	self.collectionView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0);
	self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0);
	[self.view layoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[self relayoutSubviews];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
//	[self relayoutSubviews];
}

- (void)relayoutSubviews {
	[self.flowLayout invalidateLayout];
}

- (void)configureResizableCell:(ResizableCell *)cell forIndexPath:(NSIndexPath *)indexPath {
	cell.label.text = data[indexPath.item];
}

#pragma mark UICollectionViewDelegate

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [data count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)aCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	ResizableCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:ResizableCellReuseIdentifier forIndexPath:indexPath];
	[self configureResizableCell:cell forIndexPath:indexPath];
	return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (SIZING_APPROACH == SizingApproachNone) {
		[self configureResizableCell:sizingCell forIndexPath:indexPath];
		return [sizingCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
		
	} else if (SIZING_APPROACH == SizingApproachAddConstraintCollectionView) {
		// Adding a constant size constraint on the width of the cell.
		// The problem here is that the height of the portrait layout is the same as the height of the landscape
		// layout, so there's a lot of extra vertical padding.
		NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:sizingCell attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.collectionView.bounds.size.width];
		[sizingCell.label setPreferredMaxLayoutWidth:self.collectionView.bounds.size.width - 40];
		[sizingCell addConstraint:constraint];
		[self configureResizableCell:sizingCell forIndexPath:indexPath];
		CGSize size = [sizingCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
		CGSize sizingBounds = CGSizeMake(self.collectionView.bounds.size.width - 40, CGFLOAT_MAX);
		CGSize labelSize = [sizingCell.label sizeThatFits:sizingBounds];
		CGSize computedSize = CGSizeMake(sizingBounds.width + 40, labelSize.height + 18);
		if (!CGSizeEqualToSize(computedSize, size)) {
			NSLog(@"labelSize; %@, intrinisc: %@", NSStringFromCGSize(labelSize), NSStringFromCGSize(sizingCell.label.intrinsicContentSize));
		}
		[sizingCell removeConstraint:constraint];
		return size;
		
	} else if (SIZING_APPROACH == SizingApproachAddConstraintCollectionViewContentView) {
		// Same as above, except the constraint is on the content view.
		NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:sizingCell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.collectionView.bounds.size.width];
		[sizingCell.contentView addConstraint:constraint];
		[self configureResizableCell:sizingCell forIndexPath:indexPath];
		CGSize size = [sizingCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
		[sizingCell.contentView removeConstraint:constraint];
		return size;
	
	} else if (SIZING_APPROACH == SizingApproachManualCalculation) {
		// Here we just calculate things directly.
		[self configureResizableCell:sizingCell forIndexPath:indexPath];
		CGSize sizingBounds = CGSizeMake(self.collectionView.bounds.size.width - 40, CGFLOAT_MAX);
		CGSize labelSize = [sizingCell.label sizeThatFits:sizingBounds];
		CGSize size = CGSizeMake(sizingBounds.width + 40, labelSize.height + 18);
		return size;
		
	} else {
		return CGSizeZero;
	}
}
@end
