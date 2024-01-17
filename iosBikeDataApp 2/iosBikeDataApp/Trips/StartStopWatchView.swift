//
//  StartStopWatchView.swift
//  iosBikeDataApp
//
//  Created by user245042 on 9/16/23.
//

import SwiftUI

struct StartStopWatchView: View {
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    var body: some View {
        VStack{
            Capsule()
                .foregroundColor(Color(.systemGray))
                .frame(width: 48,height: 6)
                .padding()
            
            HStack{
                VStack{
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 8, height: 8)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 32)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(width: 8, height: 8)
                }
                
                VStack(alignment: .leading, spacing: 24){
                    HStack{
                        Text("Current location")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Spacer()
                        
                        Text(locationViewModel.startTime ?? "")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        if let location = locationViewModel.selectedBikeLocation {    
                            Text(location.title)
                                .font(.system(size: 16, weight: .semibold))
                        }
                        Spacer()
                        
                        Text(locationViewModel.endTime ?? "")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.leading, 4)
            }
            .padding()
            
            Divider()
            
            Text("\(locationViewModel.totalMiles ?? "") MILES")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding()
                    .foregroundColor(.gray)
            
            
            Text("00:00:00 🚴🏻‍♂️")
                .font(.system(size: 50))
                .padding(.bottom)
            
            Divider()
                .padding(.vertical, 8)
            
            Button {
                
            } label: {
                Text("START TRIP")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    .background(.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            
        }
        .padding(.bottom, 100)
        .background(Color.theme.backgroundColor)
        .cornerRadius(12)
    }
}

struct StartStopWatchView_Previews: PreviewProvider {
   
    static var previews: some View {
        StartStopWatchView().environmentObject(LocationSearchViewModel())
    }
}
