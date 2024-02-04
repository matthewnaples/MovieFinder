//
//  MovieDetail.swift
//  MovieFinder
//
//  Created by matt naples on 9/25/23.
//

import SwiftUI
import Factory
import CachedAsyncImage


struct SimilarMoviesSection: View{
    var movie: MovieModel
    @Injected(\.movieService) var api
    //    @State private var credits: MoviePageableList?
    var body: some View{
        
        ItemLoader {
            try await api.fetchMoviesSimilarTo(movie.id)
        } content: { (loadMovies, loadingPhase) in
            ZStack{
                switch loadingPhase{
                case .error(_):
                    LoadingErrorView(errorMessage: "an error occurred")
                case .initial, .loading:
                    ProgressView()
                case .loaded(let movies):
                    //                    ScrollView(.horizontal){
                    VStack{
                        ForEach(movies){
                            MovieCell(movie: $0)
                        }
                    }
                    //                    }
                }
                
            }
            .task {
                await loadMovies()
            }
        }
    }
}
struct ReviewCell: View{
    @State private var showWholeReview = false
    var review: ReviewModel
    var body: some View{
        VStack(alignment: .leading, spacing: 4){
            Text(review.author)
                .font(.subheadline)
                .fontWeight(.bold)
            Divider()
            Text(LocalizedStringKey(review.review))
                .font(.footnote)
                .lineLimit(showWholeReview ? nil : 3)
            
        }
        
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray5)
        .cornerRadius(8)
        .onTapGesture(perform: {
            withAnimation {
                showWholeReview.toggle()
            }
        })
    }
}
struct ReviewSection: View{
    var movie: MovieModel
    @Injected(\.movieService) var api
    @State private var showWholeReview = false
    var body: some View{
        ItemLoader {
            try await api.fetchReviews(for: movie.id)
        } content: { (loadMovies, loadingPhase) in
            ZStack{
                switch loadingPhase{
                case .error (_):
                    LoadingErrorView(errorMessage: "an error occurred")
                case .initial, .loading:
                    VStack{
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    
                    
                case .loaded(let reviews):
                    VStack(alignment: .leading){
                        
                        ForEach(reviews){review in
                            ReviewCell(review: review)
                        }
                    }
                    
                }
                
            }
            .task {
                await loadMovies()
            }
        }
    }
}
struct DetailSection<Content: View>: View{
    var title: String
    @ViewBuilder var content: () -> Content
    init(title: String, @ViewBuilder content: @escaping () -> Content){
        self.title = title
        self.content = content
    }
    var body: some View{
        VStack(alignment: .leading, spacing: 8){
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            content()
        }
    }
}
