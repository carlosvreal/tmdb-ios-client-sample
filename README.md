[![Build Status](https://travis-ci.org/carlosvreal/moviesTMDB.svg)](https://travis-ci.org/carlosvreal/moviesTMDB) [![codecov.io](https://codecov.io/gh/carlosvreal/moviesTMDB/branch/master/graph/badge.svg)](https://codecov.io/gh/carlosvreal/moviesTMDB)

# Project
Sample project iOS client consuming TMBD RESTful service.

## Build instructions

Run `pod install` and launch `MobileDB.xcworkspace`

### Features:
  * Movies list
  * Movie Detail
  * Sorted by popularity
  * Search
  * Cache using NSCache
  * Pagination
 
 ## Architecture
 
 MVVM was chosen to be the core architecture, adding an extra layer to the traditional MVC, providing a better separation of concerns between constrollers and presentation layers. In addition, MVVM is known for facilitate the use of reactive programming on iOS
 
 ## Cocoa Pods
 
 1. RxSwift, RxCocoa 
 
 RxCocoa brings an abstraction layer to iOS components and RxSwift adds the ability to use functional and reactive features to Apple plattform.
 
 3. RxDataSources
 
 RxDataSources provides abstraction for UITableView and UICollectionView usage for instance build dataSource for tableview/collection and item selected, without implementing the usual delegate and datasource delegates. 
 
 3. RxTest, RxBlocking
 
 These libraries help to test RxSwift methods and operator, creating a controlled environment. RxTest providers a layer to test main operators from RxSwift/RxCocoa and RxBlocking helps to deal with async tests.
 
 4. SwiftLint
 
 Helps to keep track of project standards, delivering a readable, organized and safe code.
