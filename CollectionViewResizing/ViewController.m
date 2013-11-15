//
//  ViewController.m
//  CollectionViewResizing
//
//  Created by Andrew Wooster on 11/15/13.
//  Copyright (c) 2013 Andrew Wooster. All rights reserved.
//

#include <stdlib.h>

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


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[self relayoutSubviews];
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
	[self configureResizableCell:sizingCell forIndexPath:indexPath];
	return [sizingCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}
@end
