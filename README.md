# Movies
Movies TMDB

# Sample TMDB iOS client
Client for iOS consuming TMDB REST service. It will provide information about movies list, movie detail and search any Movie. 

### Features:

  ** Filtered by popular movies
  ** Search movies
  ** Cache movies locally
  ** Pagination for Movies list and Search
 
## Architecture

MVVM was used as the core architecture for this code. ADding an extra layer to the traditional MVC, MVVM provides a better separation of concerns. In addition, offers infrastructure to work with reactive and functional paradigms on iOS.

## Cocoa Pods

1. RxSwift, RxCocoa 

RxCocoa brings an abstraction layer to iOS components and RxSwift adds the ability to use functional and reactive features to Apple plattform.

3. RxDataSources

RxDataSources provides abstraction for UITableView and UICollectionView usage for instance build dataSource for tableview/collection and item selected, without implementing the usual delegate and datasource delegates. 

3. RxTest, RxBlocking

These libraries help to test RxSwift methods and operator, creating a controlled environment. RxTest providers a layer to test main operators from RxSwift/RxCocoa and RxBlocking helps to deal with async tests.

4. SwiftLint

Helps to keep track of project standards, delivering a readable, organized and safe code.
