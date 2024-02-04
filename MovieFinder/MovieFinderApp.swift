//
//  MovieFinderApp.swift
//  MovieFinder
//
//  Created by matt naples on 9/25/23.
//

import SwiftUI

@main
struct MovieFinderApp: App {
    var body: some Scene {
        WindowGroup {
//            MovieDetail(movie: .sample)
//            IntroView()
            Home()
                .onAppear {
//                    for family in UIFont.familyNames.sorted() {
//                        let names = UIFont.fontNames(forFamilyName: family)
//                        print("Family: \(family) Font names: \(names)")
//                    }
                    // set the memory capacity to 500MB for easy image loading
                    URLCache.shared.memoryCapacity = 1024*1024*1024
                }
//            MovieHeader(posterUrl: URL(string: "https://image.tmdb.org/t/p/original/iuFNMS8U5cb6xfzi51Dbkovj7vM.jpg")!, backdropUrl: URL(string: "https://image.tmdb.org/t/p/original/ctMserH8g2SeOAnCw5gFjdQF8mo.jpg")!)
//            MovieDetail(movie: .sample)
//            Home()
        }
    }
}
