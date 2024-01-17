//
//  StaticVikeViewViewModel.swift
//  iosBikeDataApp
//
//  Created by user245042 on 9/23/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class StaticBikeViewViewModel: ObservableObject {
    @Published var miles = ""
    @Published var time = ""
    @Published var mileData = ""
    @Published var timeData = ""
    @Published var isValid = false
    
    init() {}
    
    func save() {
        guard isValid else {
            return
        }
        
        // get current user id
        guard let uID = Auth.auth().currentUser?.uid else {
            return
        }
        
        //create model
        let newId = UUID().uuidString
        let newData = DataCollection(
            id: newId,
            Miles: mileData,
            Time: timeData,
            createdDate: Date().timeIntervalSince1970,
            methodOfTransport: "Stationary Bike")
        
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uID)
            .collection("Data info")
            .document(newId)
            .setData(newData.asDictionary())
    }
    
    func isItValid() {
        if let doubleValue = Double(miles), let timeValue = Double(time) {
            timeData = timeValue.toDouble()
            mileData = doubleValue.toDouble()
            isValid = true
        } else {
            isValid = false
        }
    }
}
