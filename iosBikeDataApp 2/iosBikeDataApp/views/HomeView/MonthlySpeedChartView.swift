//
//  MonthlySpeedChartView.swift
//  iosBikeDataApp
//
//  Created by user245042 on 10/1/23.
//
import FirebaseFirestoreSwift
import SwiftUI
import Charts
import FirebaseAuth

struct MonthlySpeedChartView: View {
    @FirestoreQuery var items: [DataCollection]
    
    init(userId: String) {
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/Data info")
    }
    
    var body: some View {
        let monthlyAverages = calculateMonthlyAverages(for: items)
        let chartView = createChartView(monthlyAverages: monthlyAverages)
        return chartView
    }
    
    func calculateMonthlyAverages(for items: [DataCollection]) -> [String: Double] {
           // Create a dictionary to store monthly averages
           var monthlyAverages: [String: Double] = [:]

           // Group the items by month
           let calendar = Calendar.current
           let groupingInterval: Calendar.Component = .month
           let groupedData = Dictionary(grouping: items) { item in
               let date = Date(timeIntervalSince1970: item.createdDate)
               return calendar.component(groupingInterval, from: date)
           }

           // Calculate the average for each month
           for (month, monthItems) in groupedData {
               let totalMiles = monthItems.reduce(0.0) { $0 + (Double($1.Miles) ?? 0.0) }
               let totalMinutes = monthItems.reduce(0.0) { $0 + (Double($1.Time) ?? 0.0) }
               let averageSpeed = totalMiles / (totalMinutes / 60.0)

               let monthIdentifier = calendar.monthSymbols[month - 1] // Get the month name
               monthlyAverages[monthIdentifier] = averageSpeed
           }

           return monthlyAverages
       }

       func createChartView(monthlyAverages: [String: Double]) -> some View {
           let chartDataPoints = monthlyAverages.keys.sorted { $0 > $1}

           return Chart(chartDataPoints.map { ChartDataPoint(month: $0, averageSpeed: monthlyAverages[$0] ?? 0.0) }) { dataPoint in
               BarMark(x: .value("Month", dataPoint.month), y: .value("Average Speed", dataPoint.averageSpeed))
           }
           .chartXAxis {
               AxisMarks { _ in
                   AxisValueLabel()
               }
           }
       }
   
   struct ChartDataPoint: Identifiable {
       let id = UUID()
       let month: String
       let averageSpeed: Double
   }
}


struct MonthlySpeedChartView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlySpeedChartView(userId: "userID")
            .aspectRatio(1, contentMode: .fit)
            .padding()
    }
}
