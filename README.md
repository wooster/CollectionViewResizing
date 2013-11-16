# Collection View Resizing

This is a simple project to show what happens with different approaches to resizing UICollectionViewCells with resizable text on rotation.

In `ViewController.m`, there are a few different approaches implemented, each with their own pitfalls. You can swap between them by changing the `SIZING_APPROACH` value:

```objective-c
typedef NS_ENUM(NSInteger, SizingApproach) {
    SizingApproachNone,
    SizingApproachAddConstraintCollectionView,
    SizingApproachAddConstraintCollectionViewContentView,
    SizingApproachManualCalculation,
    SizingApproachPreferredMaxLayoutWidth,
};

#define SIZING_APPROACH SizingApproachPreferredMaxLayoutWidth
```

The key for getting this to work properly for UILabels is `preferredMaxLayoutWidth`, which unfortunately can't be manipulated via layout constraints.
