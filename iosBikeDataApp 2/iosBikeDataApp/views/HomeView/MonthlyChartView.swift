//
//  MonthlyChartView.swift
//  iosBikeDataApp
//
//  Created by user245042 on 9/24/23.
//

import SwiftUI
import Charts
import FirebaseFirestoreSwift
import FirebaseAuth

struct MonthlyChartView: View {
    @StateObject var staticBikeViewModel = StaticBikeViewViewModel()
    @StateObject var homeViewViewModel = HomeViewViewModel(userId: Auth.auth().currentUser?.uid ?? "")
    @FirestoreQuery var items: [DataCollection]


    init(userId: String) {
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/Data info")
    }
    
    let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "MMMM" // Format for month of the year
            return df
        }()
    
    var body: some View {
        
        Chart(items.sorted{$0.createdDate < $1.createdDate}) { stat in

            BarMark(x: .value("Week", Date(timeIntervalSince1970: stat.createdDate), unit: .month),
                    y: .value("Miles", Double(stat.Miles) ?? 0.0))
        }
//        Chart(homeViewViewModel.statsByWeek, id: \.day) { milesDate in
//            BarMark(x: .value("Month", milesDate.day, unit: .month),
//                    y: .value("Miles", milesDate.stats))
//
//        }
        .chartXAxis {
            AxisMarks { _ in
                AxisValueLabel(format:
                        .dateTime.month(), centered: true)
            }
        }
    }
}

struct MonthlyChartView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyChartView(userId: "userID")
            .aspectRatio(1, contentMode: .fit)
            .padding()
    }
}
