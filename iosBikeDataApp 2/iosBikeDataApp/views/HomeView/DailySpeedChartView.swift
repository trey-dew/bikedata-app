//
//  DailySpeedChartView.swift
//  iosBikeDataApp
//
//  Created by user245042 on 10/1/23.
//
import FirebaseFirestoreSwift
import SwiftUI
import Charts
import FirebaseAuth

struct DailySpeedChartView: View {
    @FirestoreQuery var items: [DataCollection]
    
    init(userId: String) {
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/Data info")
    }

    
    
    var body: some View {
        
        let dailyAverages = calculateDailyAverages(for: items)
        let chartView = createChartView(dailyAverages: dailyAverages)
        return chartView
        
    }
    
    func calculateDailyAverages(for items: [DataCollection]) -> [String: Double] {
            // Create a dictionary to store daily averages
            var dailyAverages: [String: Double] = [:]

            // Group the items by day
        let groupedByDay = Dictionary(grouping: items.sorted{$0.createdDate < $1.createdDate}) { item in
                let date = Date(timeIntervalSince1970: item.createdDate)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust the date format as needed
            return dateFormatter.string(from: date)
            }

            // Calculate the average for each day
            for (day, dayItems) in groupedByDay {
                let totalMiles = dayItems.reduce(0.0) { $0 + (Double($1.Miles) ?? 0.0) }
                let totalMinutes = dayItems.reduce(0.0) { $0 + (Double($1.Time) ?? 0.0) }
                let averageSpeed = totalMiles / (totalMinutes / 60.0)
                dailyAverages[day] = averageSpeed
            }

            return dailyAverages
        }
    
    func createChartView(dailyAverages: [String: Double]) -> some View {
            let chartDataPoints = dailyAverages.keys.sorted()
            
        return Chart(chartDataPoints.map { ChartDataPoint(day: $0, averageSpeed: dailyAverages[$0] ?? 0.0) }) { dataPoint in
                BarMark(x: .value("Day", dataPoint.day), y: .value("Average Speed", dataPoint.averageSpeed))
            }
            .chartXAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                }
            }
        }
    
    struct ChartDataPoint: Identifiable {
        let id = UUID()
        let day: String
        let averageSpeed: Double
    }
}

struct DailySpeedChartView_Previews: PreviewProvider {
    static var previews: some View {
        DailySpeedChartView(userId: "userID")
            .aspectRatio(1, contentMode: .fit)
            .padding()
    }
}
