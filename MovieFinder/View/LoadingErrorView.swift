//
//  LoadingErrorView.swift
//  MovieFinder
//
//  Created by matt naples on 9/25/23.
//

import SwiftUI

struct LoadingErrorView: View {
    @Environment(\.refresh) var tryAgainAction
    var buttonLabel: String = "Try again"
    var errorMessage: String
    var body: some View {
        VStack{
            Text(errorMessage)
            Button {
                Task{
                    await tryAgainAction?()
                }
            } label: {
                Text(buttonLabel)
            }
        }

    }
}

struct LoadingErrorView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingErrorView(errorMessage: "Oh no... an error occurred")
    }
}
