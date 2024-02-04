//
//  MovieCell.swift
//  MovieFinder
//
//  Created by matt naples on 9/25/23.
//

import SwiftUI
import CachedAsyncImage
import SkeletonUI
struct MovieCell: View{
    var movie: MovieModel
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    var body: some View{
        
        VStack(alignment: .leading, spacing: 0){
                HStack{
                    Text(movie.title)
                        .font(.headline).fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom)
                    Spacer()
                    Image(systemName: favoritesViewModel.isFavorite(movie.id) ? "star.fill" : "star")
                             .foregroundColor(.accentColor)
                    
                    .padding(4)
                    .background(Material.ultraThin)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.accentColor))
                    .onTapGesture {
                        withAnimation{
                            favoritesViewModel.save(movie)
                        }
                    }
                    
                }
                HStack(){
                        CachedAsyncImage(
                            url: movie.posterUrl,
                            content: { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    
                                //                                     .clipShape(Circle())
                                    .cornerRadius(8)
                                
                                //                                     .background(Color.red)
                                
                            },
                            placeholder: {
                                Rectangle()
                                    .fill(.clear)
                                    .skeleton(with: true, shape: .rounded(.radius(8, style: .continuous)))
                                    .frame(width: 200 * 2/3)
                                
                            }
                        )
                        .frame(height: 200)

                    
                    
                    //            Spacer()
                    if let overview = movie.overview{
                        Text(overview)
                            .font(.footnote)
                            .multilineTextAlignment(.leading)

                    }
                }
    
                
            }
            .padding()
            .background(Color.gray5)
            .cornerRadius(8)
    }
    
}


struct MovieCell_Previews: PreviewProvider {
    static var previews: some View {
        
        MovieCell(movie: .sample)
        //            .padding()
        Rectangle()
            .skeleton(with: true, shape: .rounded(.radius(8,style: .continuous)))
            .frame(width: 50,height: 100)
        
    }
}
