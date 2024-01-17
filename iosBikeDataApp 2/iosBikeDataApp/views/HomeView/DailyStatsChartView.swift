//
//  DailyStatsChartView.swift
//  iosBikeDataApp
//
//  Created by user245042 on 9/24/23.
//
import FirebaseFirestoreSwift
import SwiftUI
import Charts
import FirebaseAuth

struct DailyStatsChartView: View {
    @StateObject var staticBikeViewModel = StaticBikeViewViewModel()
    @ObservedObject var homeViewViewModel = HomeViewViewModel(userId: Auth.auth().currentUser?.uid ?? "")
    @FirestoreQuery var items: [DataCollection]


    init(userId: String) {
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/Data info")

            let beginingOfInterval = Date().addingTimeInterval(-1 * 3600 * 24 * 30)
            self._scrollPosistion = State(initialValue: beginingOfInterval.timeIntervalSinceReferenceDate)
    }
    
    
    @State private var scrollPosistion: TimeInterval = TimeInterval()
    let numberOfDisplayDays = 30
    
    var scrollPositionStart: Date {
        Date(timeIntervalSinceReferenceDate: scrollPosistion)
    }
    
    var scrollPositionEnd: Date {
        scrollPositionStart.addingTimeInterval(3600 * 24 * 30)
    }
    
    var scrollPositionString: String {
        scrollPositionStart.formatted(.dateTime.month().day())
    }
    
    var scrollPositionEndString: String {
        scrollPositionEnd.formatted(.dateTime.month().day().year())
    }
    var body: some View {
        VStack{
            Text("\(scrollPositionString) - \(scrollPositionEndString)")
           // Text("You biked ") +
           // Text("\(homeViewViewModel.totalStats.toDouble()) ") +
            //Text("In the last 90 Days")
                    
            Chart(items.sorted{$0.createdDate < $1.createdDate}) { stat in
                BarMark(x: .value("Day", Date(timeIntervalSince1970: stat.createdDate), unit: .day),
                        y: .value("Miles", Double(stat.Miles) ?? 0.0))
            }
            .chartXAxis {
                AxisMarks { _ in
                    AxisValueLabel(format:
                            .dateTime.month(.abbreviated), centered: true)
                }
            }
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: 3600 * 24 * numberOfDisplayDays)
            .chartScrollTargetBehavior(
                .valueAligned(matching: .init(hour: 0), majorAlignment: .matching(.init(day:1)))
            )
            .chartScrollPosition(x: $scrollPosistion)
        }
    }
}

struct DailyStatsChartView_Previews: PreviewProvider {
    static var previews: some View {
        DailyStatsChartView(userId: "userID")
            .aspectRatio(1, contentMode: .fit)
            .padding()
    }
}
