//
//  FavoritesViewModel.swift
//  MovieFinder
//
//  Created by matt naples on 9/25/23.
//

import Foundation
import Factory
class FavoritesViewModel: ObservableObject{
    @Injected(\.favoritesService) var favoritesService
    @Published private(set) var favorites: [Int: MovieModel] = [:]
    @Published private(set) var errorMessage: String?
    var sortedFavorites: [MovieModel]{
        return favorites.map{$0.value}.sorted(by: {$0.title.lowercased() < $1.title.lowercased()})
    }
    func save(_ movie: MovieModel){
        do{
            try favoritesService.save(movie)
            loadFavorites()
        } catch{
            errorMessage = "Oh no, an error occurred."
        }
    }
    func loadFavorites(){
        print("loading")
        do{
            self.favorites = try favoritesService.load()
        } catch{
            errorMessage = "Oh no, an error occurred."
        }
    }
    func isFavorite(_ movieId: Int) -> Bool{
        favorites[movieId] != nil
    }
}
