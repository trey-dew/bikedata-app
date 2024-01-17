//
//  LoginView.swift
//  iosBikeDataApp
//
//  Created by user245042 on 9/3/23.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()

    
    var body: some View {
        NavigationView {
            VStack{
                ZStack{ // HEADER
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundColor(Color.blue)
                        .rotationEffect(Angle(degrees: 15))
                        .offset(y: -60)
                    
                    VStack{
                        Text("Bike Data Tracking")
                            .font(.system(size: 40))
                            .foregroundColor(Color.white)
                            .bold()
                        Text("Tracks all your data")
                            .font(.system(size: 30))
                            .foregroundColor(Color.white)
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 3, height: 300)
                .offset(y: -40)
                // END HEADER
                
                //LOGIN FORM
                
                Form{
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(Color.red)
                    }
                    
                    TextField("Email Address", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button {
                        viewModel.login()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.blue)
                            
                            Text("Log In")
                                .foregroundColor(Color.white)
                                .bold()
                        }
                    }
                    
                }
                // END LOGIN FORM
                
                
                // CREATE ACCOUNT
                VStack{
                    Text("Dont Have An Account?")
                    NavigationLink("Create An Account", destination: RegisterView())
                }
                
                Spacer()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
