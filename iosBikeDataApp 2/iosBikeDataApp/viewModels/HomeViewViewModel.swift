//
//  HomeViewViewModel.swift
//  iosBikeDataApp
//
//  Created by user245042 on 9/24/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class HomeViewViewModel: ObservableObject {
    @FirestoreQuery var items: [DataCollection]    
    @Published var statsData = [DataCollection]()
    @Published var dataBase = [DataCollection]()
    private var db = Firestore.firestore()
    
    func fetchData() {
        let userID = Auth.auth().currentUser?.uid ?? ""
        db.collection("/users/\(userID)/Data info").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error fetching data \(error.localizedDescription)")
                return
            }
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            DispatchQueue.main.async {
                self.dataBase = documents.map { (queryDocumentSnapshot) -> DataCollection in
                    let dataC = queryDocumentSnapshot.data()
                    
                    let Miles = dataC["Miles"] as? String ?? ""
                    let Time = dataC["Time"] as? String ?? ""
                    let createdDate = dataC["createdDate"] as? TimeInterval ?? 0.0
                    let id = dataC["id"] as? String ?? ""
                    let methodOfTransport = dataC["methodOfTransport"] as? String ?? ""
                    
                    let dataCollection = DataCollection(id: id, Miles: Miles, Time: Time, createdDate: createdDate, methodOfTransport: methodOfTransport)
                    return dataCollection
                }
            }
        }
    }

    
    var totalStats: Double {
        var total = 0.0
        for miledata in self.dataBase {
            total += Double(miledata.Miles) ?? 0.0
        }
        return total
    }
    
    @Published var lastTotalStats: Double = 250.0
    
    var statsByWeek: [(day: Date, stats: Double)] {
        let statsByWeek = statsByWeeks(stats: dataBase)
        return totalStatsPerDate(statsByDate: statsByWeek)
    }

    
    init(userId: String) {
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/Data info")
        fetchData()
    }

    
    func statsByWeeks(stats: [DataCollection]) -> [Date: [DataCollection]] {
        var statsWeek: [Date: [DataCollection]] = [:]
        
        let calendar = Calendar.current
        
        for stat in stats {
            let date = Date(timeIntervalSince1970: stat.createdDate)
            guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) else {continue}
            
            if statsWeek[startOfWeek] != nil {
                statsWeek[startOfWeek]!.append(stat)
            } else {
                statsWeek[startOfWeek] = [stat]
            }
        }
        return statsWeek
    }
    
    func totalStatsPerDate(statsByDate: [Date: [DataCollection]]) -> [(day: Date, stats: Double)] {
        var totalStats: [(day: Date, stats: Double)] = []
        
        for (date, stats) in statsByDate {
            
            let totalQuantityForDate = stats.reduce(into: 0.0) {total, DataCollection in
                if let miles = Double(DataCollection.Miles) {
                    total += miles
                }
            }
            totalStats.append((day: date, stats: totalQuantityForDate))
        }
        return totalStats
    }
    
}
