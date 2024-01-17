//
//  RegisterView.swift
//  iosBikeDataApp
//
//  Created by user245042 on 9/3/23.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject var viewModel = RegisterViewViewModel()
    
    var body: some View {
        VStack{
            ZStack{ // HEADER
                RoundedRectangle(cornerRadius: 0)
                    .foregroundColor(Color.blue)
                    .rotationEffect(Angle(degrees: 15))
                    .offset(y: -160)
                
                VStack{
                    Text("Register")
                        .font(.system(size: 40))
                        .foregroundColor(Color.white)
                        .bold()
                    Text("Start tracking your data")
                        .font(.system(size: 30))
                        .foregroundColor(Color.white)
                }
                .padding(.top, -120)
            }
            .frame(width: UIScreen.main.bounds.width * 3, height: 400)
            .offset(y: -70)
            // END HEADER
            
            //CREATE ACCOUNT FORM
            Form{
                TextField("Full name", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled()
                TextField("Email Address", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button {
                    viewModel.register()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.green)
                        
                        Text("Create Account")
                            .foregroundColor(Color.white)
                            .bold()
                    }
                }
                .padding()
            }
            //END FORM

            
            Spacer()
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
