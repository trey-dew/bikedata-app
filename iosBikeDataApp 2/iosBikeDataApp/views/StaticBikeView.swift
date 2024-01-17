//
//  StaticBikeView.swift
//  iosBikeDataApp
//
//  Created by user245042 on 9/9/23.
//

import SwiftUI
import MapKit

struct StaticBikeView: View {
    @StateObject var viewModel = StaticBikeViewViewModel()
    
    
    var body: some View {
        VStack{
            Form{
                Text("Miles Traveled")
                TextField("", text: $viewModel.miles)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                Text("Time Taken (in minutes)")
                TextField("", text: $viewModel.time)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button {
                    viewModel.isItValid()
                    viewModel.save()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.blue)
                        
                        Text("Save info")
                            .foregroundColor(Color.white)
                            .bold()
                    }
                }
                if viewModel.isValid {
                    Text("mile Value is \(viewModel.mileData) time value is \(viewModel.timeData)")
                } else {
                    Text("No Valid Input")
                }
            }
            
            
            
        }
    }
}

func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let allowedCharacters = CharacterSet.decimalDigits
    let characterSet = CharacterSet(charactersIn: string)
    return allowedCharacters.isSuperset(of: characterSet)
}


struct StaticBikeView_Previews: PreviewProvider {
    static var previews: some View {
        StaticBikeView()
    }
}
