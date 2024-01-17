//
//  BikingOptionView.swift
//  iosBikeDataApp
//
//  Created by user245042 on 9/9/23.
//

import SwiftUI

struct BikingOptionView: View {
    var body: some View {
        NavigationView{
            VStack{
                Text("this is a bike 🚴🏻‍♂️")
                    .padding()
               
                NavigationLink("Select destination from a map", destination: MapView())
                    .padding()
                    .bold()
                
                NavigationLink("Select location as you go", destination:TrackingView())
                    .padding()
                
                NavigationLink("Select stationary bike or work out bike", destination: StaticBikeView())
                    .padding()
                
                NavigationLink("Stopwatch", destination: NewStopWatchView())
                    .padding()
            }
        }
        
    }
}

struct BikingOptionView_Previews: PreviewProvider {
    static var previews: some View {
        BikingOptionView()
    }
}
