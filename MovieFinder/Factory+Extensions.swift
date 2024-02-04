//
//  Factory+Extensions.swift
//  MovieFinder
//
//  Created by matt naples on 9/26/23.
//

import Factory
import TMDb
extension Container {
    var movieService: Factory<MovieAPI> {
        Factory(self) { TMDbAdapter(api: TMDbAPI(apiKey: "<your-api-key-here>")) }
    }
    var favoritesService: Factory<FavoriteMovieService> {
        Factory(self) { LocalCacheFavoriteMovieService() }
    }
}
