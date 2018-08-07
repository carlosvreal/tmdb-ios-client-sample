# moviesDB
Movies TMDB

# CodeChallenge-iOS TMDB
The code challenge is a client for iOS intended to load and search Movies from TMDB service. 
The main features are:
  ** Load popular movies list
  ** Search movies
  ** Cache movies locally
  ** 
Bonus: 
  ** Pagination for Movies list

## Code Architecture

The project was developed following MVVM architecture. Having UIViewController and ViewModel provider a better separation of concerns. In addition, it allows to usage of reactive and functional paradigms on iOS.

## Cocoa Pods

1. ** RxSwift, RxCocoa, RxDataSources **

RxCocoa brings an abstraction layer to iOS components and RxSwift adds the ability to use functional and reactive features to Apple plattform. Also, fits greatly with MVVM architecture. RxDataSources provides abstraction for UITableView and UICollectionView usage for instance build dataSource for tableview/collection and item selected, without implementing the usual delegate and datasource delegates. 

3. ** RxTest, RxBlocking

These libraries help to test RxSwift methods and operator, creating a controlled environment. RxTest providers a layer to test main operators from RxSwift/RxCocoa and RxBlocking helps to deal with async tests.

4. ** SwiftLint **

Helps to keep track of project standards, delivering a readable, organized and safe code.
