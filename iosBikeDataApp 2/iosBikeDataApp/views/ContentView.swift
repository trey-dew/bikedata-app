//
//  ContentView.swift
//  iosBikeDataApp
//
//  Created by user245042 on 8/26/23.
//

import SwiftUI


//enum Emoji: String, CaseIterable {
//    case 😂,🥰,😆,😿,👁️,🏷️,🚴🏼
//}

struct ContentView: View {
    @StateObject var viewModel = ContentViewViewModel()
    
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            TabView {
                
                HomeView(userId: "userID")
                    .tabItem{
                        Label("Home", systemImage: "house")
                    }
                
                BikingOptionView()
                    .tabItem{
                        Label("Stopwatch",systemImage: "clock")
                    }

                ProfileView()
                    .tabItem{
                        Label("Profile",systemImage: "person")
                    }
            }
            
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
