//
//  WeeklyChartsView.swift
//  iosBikeDataApp
//
//  Created by user245042 on 9/24/23.
//

import SwiftUI
import Charts
import FirebaseFirestoreSwift
import FirebaseAuth

struct WeeklyChartsView: View {
    @StateObject var staticBikeViewModel = StaticBikeViewViewModel()
    @ObservedObject var homeViewViewModel = HomeViewViewModel(userId: Auth.auth().currentUser?.uid ?? "")
    @FirestoreQuery var items: [DataCollection]


    init(userId: String) {
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/Data info")
    }
//
//    let dateFormatter: DateFormatter = {
//            let df = DateFormatter()
//            df.dateFormat = "w" // Format for week of the year
//            return df
//        }()
    
    var body: some View {
//
//        Chart(items.sorted{$0.createdDate < $1.createdDate}) { stat in
//
//            let tryDate = dateFormatter.string(from: Date(timeIntervalSince1970: stat.createdDate))
//            let doubleMiles = Double(stat.Miles)
//
//
//            BarMark(x: .value("Week", tryDate),
//                    y: .value("Miles", doubleMiles ?? 0.0))
//            .foregroundStyle(Color.blue.gradient)
//        }
        
        Chart(homeViewViewModel.statsByWeek, id: \.day) { milesDate in
            BarMark(x: .value("Week", milesDate.day, unit: .weekOfYear),
                    y: .value("Miles", milesDate.stats))
        }
        .chartXAxis {
            AxisMarks { _ in
                AxisValueLabel(format:
                        .dateTime.month(), centered: true)
            }
        }
    }
}

struct WeeklyChartsView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyChartsView(userId: "userID")
            .aspectRatio(1, contentMode: .fit)
            .padding()
    }
}
