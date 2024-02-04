//
//  protocol Movie.swift
//  MovieFinder
//
//  Created by matt naples on 9/25/23.
//

import Foundation

public struct MovieModel: Codable, Identifiable{
    public var id: Int
    public var title: String
    public var tagline: String?
    public var overview: String?
    public var posterUrl: URL?
    public var backdropUrl: URL?
    public var voterRating: Double?
    public var voteCount: Int?
}

extension MovieModel{
    static var sample: MovieModel{
        MovieModel(id: 346698, title: "Barbie", overview: "Barbie and Ken are having the time of their lives in the colorful and seemingly perfect world of Barbie Land. However, when they get a chance to go to the real world, they soon discover the joys and perils of living among humans.",posterUrl: URL(string: "https://image.tmdb.org/t/p/original/iuFNMS8U5cb6xfzi51Dbkovj7vM.jpg"), backdropUrl: URL(string: "https://image.tmdb.org/t/p/original/ctMserH8g2SeOAnCw5gFjdQF8mo.jpg"), voterRating: 8,voteCount: 4356)
    }
}
