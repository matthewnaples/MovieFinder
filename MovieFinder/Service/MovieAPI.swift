//
//  MovieAPI.swift
//  MovieFinder
//
//  Created by matt naples on 9/25/23.
//

import Foundation

public protocol MovieAPI{
    func fetchMoviesNowPlaying() async throws -> [MovieModel]
    func fetchReviews(for movieId: Int) async throws -> [ReviewModel]
    func fetchMoviesSimilarTo(_ movieId: Int) async throws -> [MovieModel]
 
}
