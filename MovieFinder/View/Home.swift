//
//  MoviePracticew.swift
//  MovieFinder
//
//  Created by matt naples on 9/25/23.
//

import SwiftUI
import Factory

enum Segment: String, Identifiable, CaseIterable {
    var id: String{
        return self.rawValue
    }
    case all = "All"
    case favorites = "My Favorites"
}
struct Home: View {
    @State private var selected: MovieModel?
    @StateObject var favoritesViewModel = FavoritesViewModel()
    @State private var selectedSegment: Segment = .all
    var body: some View {
        VStack{
            Picker("", selection: $selectedSegment) {
            ForEach(Segment.allCases) { segment in
                Text(segment.rawValue)
                    .tag(segment)
                    .foregroundColor(selectedSegment == segment ? .accentColor : .textPrimary)
               }
            }
            .pickerStyle(.segmented)
            .padding()
            
            ZStack{
                NowPlayingMovieList(selectedMovie: $selected)
                    .opacity(selectedSegment == .all ? 1 : 0)
                
                FavoriteMovies(selectedMovie: $selected)
                    .opacity(selectedSegment == .favorites ? 1 : 0)
            }
            
            
        }
        .onAppear{
            favoritesViewModel.loadFavorites()
        }
        .background(Color.background)
        .environmentObject(favoritesViewModel)
     
    }
}


struct NowPlayingMovieList: View{
    @Injected(\.movieService) var movieService
    @Binding var selectedMovie: MovieModel?
    var body: some View{
        ItemLoader {
            try await movieService.fetchMoviesNowPlaying()
        } content: { loadMovies, loadingPhase in
            ZStack{
                Color.background.ignoresSafeArea()
                ScrollView{
                    VStack(alignment: .leading){
                        Text("Movies Now Playing")
                            .font(.custom("TestNational2CmpBold", size: 48))
                            .foregroundColor(.onImage)
                        switch loadingPhase{
                        case .initial,.loading:
                            ProgressView()
                                .task {
                                    await loadMovies()
                                }
                        case .error:
                            LoadingErrorView(errorMessage: "There was an error loading data")
                        case .loaded(let movies):
                            if movies.isEmpty{
                                Text("It Looks like there are no movies!")
                            }
                            else{
                                //                            VStack{
                                ForEach(movies){movie in
                                    MovieCell(movie: movie)
                                        .onTapGesture {
                                            withAnimation{
                                                selectedMovie = movie
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .fullScreenCover(item: $selectedMovie) { movie in
                MovieDetail(movie: movie)
            }
            
        }
    }
}

struct FavoriteMovies: View{
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    @Binding var selectedMovie: MovieModel?
    var body: some View{
        ScrollView{
            VStack{
                ForEach(favoritesViewModel.sortedFavorites){movie in
                    MovieCell(movie: movie)
                    .onTapGesture {
                        withAnimation{
                            selectedMovie = movie
                        }
                    }
                }
            
            }
        }
            
    }

}

struct MoviePracticew_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
