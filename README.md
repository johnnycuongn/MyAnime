# MyAnime iOS App

If you want to look for a mobile app that is updated with top animes that are in the market, look no further to this MyAnime app. 
The app provides top animes with user ranking, all from your mobile app. You can have the ability to favourite anime so you can know which anime to watch later.

💡 This app is built using [`Jikan`](https://jikan.moe) REST API.

⚠️ No authentication or API key needed

This is a SwifUI version, updated on top of UIKit version.

UIKit AnimeList Version: [`AnimeList`](https://github.com/johnnycuongn/AnimeList)

### Features

- Top Animes
- Favourite Anime
- Search Anime

### Error-free Application

This mobile handle error within the app with care so that users don't worry about the error that have to face.

Using error-handling technique defined as below:

```swift
    // Define
    func getAnimes(_ completion: @escaping (Result<[FavouriteAnime], Error>) -> Void {
        try {
            // Logic here
            completion(.success(animes))
        } catch let error {
            completion(.failure(error))
        }

    }

    // Implementation
    getAnimes {result in 
        switch result:
            case .success(let animes):
                // Handle success here
            case .failure(let error):
                // Handle error here
    })
}
```

Using **Result** struct approach that is provided by Apple, give us the developers to transfer data and error to the whichever functions that are going to use. This allow error-handling at the View Model layer, which the error can be converted to a readable message for general users.

## 
