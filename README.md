# UICollectionReusableView child resize animation bug

This repo contains an iOS app to showcase a bug where the child view of a `UICollectionReusableView` is animated in its resizing but that child's _children_ do not animate. Think of it like this:

```
UICollectionView
  -> UICollectionReusableView
    -> UIViewController view (resize is animated)
      -> UIView/UITableView/etc (resize is immediate, not animated)
```

The resize of the UICollectionReusableView comes from a `UICollectionViewFlowLayout` subclass that knows about the need to make room in the collection for the `UICollectionReusableView` height.

## Using the demo

Clone or download the repo and run it in in Xcode 7 or 8 beta 1, targeting iOS 9.3 or 10. Earlier of iOS may be susceptible but have not been tested.

All relevant logic is in [CollectionController](https://github.com/adamyanalunas/SupplimentaryViewAnimation/blob/master/SupplimentaryViewAnimation/Controllers/CollectionController.swift).

Tapping the green cell will present the supplementary view and add a basic `UIViewController`'s child done in [selectCell](https://github.com/adamyanalunas/SupplimentaryViewAnimation/blob/master/SupplimentaryViewAnimation/Controllers/CollectionController.swift#L90). Tapping the supplementary view will toggle the collection to resize its size between 300 and 350 pts, seen in [supplementaryTapped](https://github.com/adamyanalunas/SupplimentaryViewAnimation/blob/master/SupplimentaryViewAnimation/Controllers/CollectionController.swift#L72). This resizing is seen to smoothly animate

Tapping the red cell will present a `UIViewController` that has a `UITableView` and `UIView` as child views. 

## Thanks

A sincere thanks to every Apple engineer that spent time with me in the 2016 WWDC labs to diagnose, debug, and attempt to solve this issue.
