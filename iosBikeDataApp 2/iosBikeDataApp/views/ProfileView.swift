//
//  ProfileView.swift
//  iosBikeDataApp
//
//  Created by user245042 on 9/8/23.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    
    var body: some View {
        NavigationView {
            VStack{
                if let user = viewModel.user {
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.blue)
                        .frame(width: 125, height: 125)
                        .padding()
                    
                    VStack(alignment: .leading){
                        HStack{
                            Text("Name:")
                                .bold()
                            Text(user.name)
                        }.padding()
                        HStack{
                            Text("Email:")
                                .bold()
                            Text(user.email)
                        }.padding()
                        HStack{
                            Text("member since:")
                                .bold()
                            Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
                        }.padding()
                    }
                    .padding()
                    
                    Button("Log Out") {
                        viewModel.LogOut()
                    }
                    .tint(.red)
                    .padding()
                    
                    Spacer()
                } else {
                    Text("Loading Profile...")
                    Button("Log Out") {
                        viewModel.LogOut()
                    }
                }
                
            }
            .navigationTitle("Profile")
        }
        .onAppear{
            viewModel.fetchUser()
        }
    }
        
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
