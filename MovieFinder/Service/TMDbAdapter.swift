//
//  TMDbAdapter.swift
//  MovieFinder
//
//  Created by matt naples on 9/25/23.
//

import Foundation
import TMDb

class TMDbAdapter: MovieAPI{
    let api: TMDbAPI
    init(api: TMDbAPI){
        self.api = api
    }
    func fetchMoviesNowPlaying() async throws -> [MovieModel] {
        let movies =  try await api.movies.nowPlaying(page: 1)
        return try await mapToMovieModel(movies.results)
    }
    
    func fetchReviews(for movieId: Int) async throws -> [ReviewModel]{
        let reviews = try await api.movies.reviews(forMovie: movieId, page: 1)
        return reviews.results.map{ReviewModel(id: $0.id,author: $0.author, review: $0.content)}
    }
    
    func fetchMoviesSimilarTo(_ movieId: Int) async throws -> [MovieModel]{
        let movies =  try await api.movies.similar(toMovie: movieId, page: 1)
        return try await mapToMovieModel(movies.results)
    }
    private func mapToMovieModel(_ movies: [Movie]) async throws -> [MovieModel]{
        let imageConfig = try await api.configurations.apiConfiguration().images
        return movies.map { movie in
            
            return MovieFinder.MovieModel(id: movie.id, title: movie.title, tagline: movie.tagline, overview: movie.overview,posterUrl: imageConfig.posterURL(for: movie.posterPath), backdropUrl: imageConfig.backdropURL(for: movie.backdropPath), voterRating: movie.voteAverage, voteCount: movie.voteCount)
        }
    }
 
}


public extension Movie{
    static var sample: Movie {
        .init(
            id: 550,
            title: "Fight Club",
            tagline: "How much can you know about yourself if you've never been in a fight?",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            overview: "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground \"fight clubs\" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.",
            runtime: 139,
            genres: [
                Genre(id: 18, name: "Drama")
            ],
            releaseDate: Date(),
            posterPath: nil,
            backdropPath: URL(string: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"),
            budget: 63000000,
            revenue: 100853753,
            homepageURL: URL(string: ""),
            imdbID: "tt0137523",
            status: .released,
            productionCompanies: [
                ProductionCompany(
                    id: 508,
                    name: "Regency Enterprises",
                    originCountry: "US",
                    logoPath: URL(string: "/7PzJdsLGlR7oW4J0J5Xcd0pHGRg.png")
                )
            ],
            productionCountries: [
                ProductionCountry(
                    countryCode: "US",
                    name: "United States of America"
                )
            ],
            spokenLanguages: [
                SpokenLanguage(
                    languageCode: "en",
                    name: "English"
                )
            ],
            popularity: 0.5,
            voteAverage: 7.8,
            voteCount: 3439,
            video: false,
            adult: false
        )
    }
}

