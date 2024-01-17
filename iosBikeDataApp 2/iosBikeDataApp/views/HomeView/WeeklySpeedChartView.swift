//
//  WeeklySpeedChartView.swift
//  iosBikeDataApp
//
//  Created by user245042 on 10/1/23.
//
import FirebaseFirestoreSwift
import SwiftUI
import Charts
import FirebaseAuth

struct WeeklySpeedChartView: View {
        @FirestoreQuery var items: [DataCollection]
        
        init(userId: String) {
            self._items = FirestoreQuery(collectionPath: "users/\(userId)/Data info")
        }
     
        var body: some View {
            let weeklyAverages = calculateWeeklyAverages(for: items.sorted{$0.createdDate < $1.createdDate})
            let chartView = createChartView(weeklyAverages: weeklyAverages)
            return chartView
        }
    
    func calculateWeeklyAverages(for items: [DataCollection]) -> [String: Double] {
            // Create a dictionary to store weekly averages
            var weeklyAverages: [String: Double] = [:]

            // Group the items by week
            let calendar = Calendar.current
            let groupingInterval: Calendar.Component = .weekOfYear
            let groupedData = Dictionary(grouping: items) { item in
                let date = Date(timeIntervalSince1970: item.createdDate)
                return calendar.component(groupingInterval, from: date)
            }

            // Calculate the average for each week
            for (week, weekItems) in groupedData {
                let totalMiles = weekItems.reduce(0.0) { $0 + (Double($1.Miles) ?? 0.0) }
                let totalMinutes = weekItems.reduce(0.0) { $0 + (Double($1.Time) ?? 0.0) }
                let averageSpeed = totalMiles / (totalMinutes / 60.0)

                let weekIdentifier = "Week \(week)"
                weeklyAverages[weekIdentifier] = averageSpeed
            }

            return weeklyAverages
        }

        func createChartView(weeklyAverages: [String: Double]) -> some View {
            let chartDataPoints = weeklyAverages.keys.sorted()

            return Chart(chartDataPoints.map { ChartDataPoint(week: $0, averageSpeed: weeklyAverages[$0] ?? 0.0) }) { dataPoint in
                BarMark(x: .value("Week", dataPoint.week), y: .value("Average Speed", dataPoint.averageSpeed))
            }
            .chartXAxis {
                AxisMarks { _ in
                    AxisValueLabel(format:
                            .dateTime.month(), centered: true)                    
                }
            }
        }
    

    struct ChartDataPoint: Identifiable {
        let id = UUID()
        let week: String
        let averageSpeed: Double
    }
}


struct WeeklySpeedChartView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklySpeedChartView(userId: "userID")
            .aspectRatio(1, contentMode: .fit)
            .padding()
    }
}
