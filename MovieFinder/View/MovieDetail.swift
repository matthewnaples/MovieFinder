//
//  MovieDetail.swift
//  MovieFinder
//
//  Created by matt naples on 9/25/23.
//

import SwiftUI
import SkeletonUI
import CachedAsyncImage
struct MovieDetail: View {
    @State var currentType: String = "Popular"
    // MARK: For Smooth Sliding Effect
    @Namespace var animation
    var movie: MovieModel
    @Environment(\.dismiss) var dismiss
    @State var headerOffsets: (CGFloat,CGFloat) = (0,0)
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0){
                HeaderView()
                // MARK: Pinned Header with Content
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section {
                        movieDetailInfo
                        
                    } header: {
                        PinnedHeaderView()
                            .background(Color.background)
                            .offset(y: headerOffsets.1 > 0 ? 0 : -headerOffsets.1 / 8)
                            .modifier(OffsetModifier(offset: $headerOffsets.0, returnFromStart: false))
                            .modifier(OffsetModifier(offset: $headerOffsets.1))
                    }
                }
                .background(Color.background)

            }
        }
        .overlay(content: {
            Rectangle()
                .fill(.black)
                .frame(height: 50)
                .frame(maxHeight: .infinity,alignment: .top)
                .opacity(headerOffsets.0 < 5 ? 1 : 0)
        })
        .coordinateSpace(name: "SCROLL")
        .ignoresSafeArea(.container, edges: .vertical)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
     
    }

    // MARK: Header View
    @ViewBuilder
    func HeaderView()->some View{
        GeometryReader{proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let size = proxy.size
            let height = (size.height + minY)
            CachedAsyncImage(url: movie.backdropUrl, content: { phase in
                if let image = phase.image {
                    image // Displays the loaded image.
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else if phase.error != nil {
                    Color.clear
 // Indicates an error.
                } else {
                    Color.clear
                        .skeleton(with: true, shape: .rectangle)// Acts as a placeholder.
                }
            })
                .frame(width: size.width,height: height > 0 ? height : 0,alignment: .top)
                .overlay(content: {
                    ZStack(alignment: .bottom) {
                        
                        // Dimming Out the text Content
                        LinearGradient(colors: [
                            .clear,
                            .black.opacity(0.5)
                        ], startPoint: .center, endPoint: .bottom)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Button {
                                dismiss()

                            } label: {
                                
                                    Image(systemName: "chevron.backward")
                                             .foregroundColor(.onImage)
                                
                                .padding()
                                .background(Material.ultraThin)
                                .clipShape(Circle())

                            }
                            .padding(.bottom)
                        
                            Text(movie.title)
                                .font(.title.bold())
                                .foregroundColor(.onImage)
                                .shadow(color: .black.opacity(0.4),radius: 8)
                            if let rating = movie.voterRating{
                                VStack(alignment: .leading,spacing: 4){
                                    HStack{
                                        Text("Rating: \(String(format: "%.1f",rating))/10")
                                        
                                        Spacer()
                                        if let voterCount = movie.voteCount{
                                            Text("votes: \(voterCount)")
                                        }
                                    }

                                    BarView(currentValue: rating)
                                        .frame(height: 12)
                                        .foregroundColor(.accentColor)
                                        .background(Color.gray.opacity(0.5))
                                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                }
                                .padding(4)
                                .background(Material.ultraThin)
                                .cornerRadius(8)
                                .font(.caption)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom,25)
                        .frame(maxWidth: .infinity,alignment: .leading)
                    }
                })
//                .cornerRadius(15)
                .offset(y: -minY)
        }
        .frame(height: 250)
    }
    
    // MARK: Pinned Header
    @ViewBuilder
    func PinnedHeaderView()->some View{
        Color.clear
    }
    var poster: some View{
        CachedAsyncImage(
            url: movie.posterUrl!,
            content: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                       
//                                     .clipShape(Circle())
                    .cornerRadius(8)
                    .frame(height: 200)
                
            },
            placeholder: {
                Rectangle()
                    .fill(.clear)
                    .skeleton(with: true, shape: .rounded(.radius(8, style: .continuous)))
                    .frame(width: 200 * 2/3)
            }
        )
    }
    @ViewBuilder var movieDetailInfo: some View{
        VStack(alignment: .leading){
      
            HStack(){
                poster
                    .shadow(color: Color.black.opacity(0.25),radius: 8)
                VStack(alignment: .leading){
                        
                    if let overview = movie.overview{
                        Text(overview)
                            .font(.subheadline)
                    }
                }
            }
//            .background(Color.green)
            Button(action: {
                withAnimation{
                    favoritesViewModel.save(movie)
                }
            }, label: {
                Text(favoritesViewModel.isFavorite(movie.id) ? "Remove from Favorites" : "Add to Favorites")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.onImage)
                    .padding()
                    .contentShape(Rectangle())
                    .font(.headline)
                    .background(Color.accentColor)
                    .cornerRadius(8)
            })
                
            Divider()
            DetailSection(title: "Read what people are saying"){
                ReviewSection(movie: movie)
            }
    
            DetailSection(title: "See Similar Movies"){
                SimilarMoviesSection(movie: movie)
            }
        }
        
        .padding()
        .background(Color.background)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetail(movie: .sample)
    }
}


extension MovieModel{
    var ratingString: String?{
        guard let voterRating else {return nil}
        return "\( String(format: "%.1f",voterRating))/10"
    }
}
