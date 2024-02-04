//
//  FavoritesService.swift
//  MovieFinder
//
//  Created by matt naples on 9/25/23.
//

import Foundation
protocol FavoriteMovieService{
    func load() throws -> [Int: MovieModel]
    func save(_ movie: MovieModel) throws
}
class LocalCacheFavoriteMovieService: FavoriteMovieService{
    let fileName = "reviews.json"
    public func load() throws -> [Int: MovieModel] {
        let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName)
        if let fileUrl {
            print("loading file from url: \(fileUrl)")
            do{
                let data = try Data(contentsOf: fileUrl)
                let decoder = JSONDecoder()
                let object = try decoder.decode([Int:MovieModel].self, from: data)
                return object
            } catch CocoaError.fileReadNoSuchFile{
                return [:]
            }
        
        }
        return [:]
    }
   public func save(_ movie: MovieModel) throws{
       let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName)
       
       var allMovies = try! load()
       if allMovies[movie.id] != nil{
           allMovies.removeValue(forKey: movie.id)
       } else{
           allMovies[movie.id] = movie
       }
       let encoder = JSONEncoder()
       let data = try encoder.encode(allMovies)
       if let fileUrl {
           try data.write(to: fileUrl)
//           let macros = try load(as: WidgetData.self)
//           print(macros)
           print("saving file to: \(fileUrl)")
       }
       
   }

    
}
