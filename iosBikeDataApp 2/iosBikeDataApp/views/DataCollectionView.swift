//
//  DataCollectionView.swift
//  iosBikeDataApp
//
//  Created by user245042 on 9/23/23.
//

import SwiftUI

struct DataCollectionView: View {
    let item: DataCollection
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text("\(item.Miles) Miles in \(item.Time) minutes")
                    .font(.title2)
                    .bold()
                Text("\(Date(timeIntervalSince1970: item.createdDate).formatted(date: .abbreviated, time: .shortened)) \(item.methodOfTransport)")
            }
            Spacer()
        }
    }
}

struct DataCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        DataCollectionView(item: .init(id: "123", Miles: "12", Time: "123", createdDate: Date().timeIntervalSince1970, methodOfTransport: "Stationary Bike"))
    }
}
