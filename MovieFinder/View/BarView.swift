//
//  BarView.swift
//  MovieFinder
//
//  Created by matt naples on 9/25/23.
//

import SwiftUI

public struct BarView: View {

    var currentValue: Double
    
    public init(currentValue: Double) {
        self.currentValue = currentValue
 
    }
    var barMax: Double = 10
      
    

    func currentValueBar(_ geometry: GeometryProxy) -> some View{
             Rectangle()
                .frame(width: currentValue/barMax * geometry.size.width)
    }
     func maxBar(_ geometry: GeometryProxy) -> some View{
             Rectangle()
            .fill(.gray)
            .frame(width: geometry.size.width)

    }
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading){
                maxBar(geometry)
                currentValueBar(geometry)
                
            }

        }
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(currentValue: 5)
            .frame(height: 10)
            .foregroundColor(.red)
            .background(Color.gray)
    }
}
