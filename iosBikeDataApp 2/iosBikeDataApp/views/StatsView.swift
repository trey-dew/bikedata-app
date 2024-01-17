//
//  StatsView.swift
//  iosBikeDataApp
//
//  Created by user245042 on 9/30/23.
//
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import Charts

import SwiftUI

struct StatsView: View {
    @FirestoreQuery var items: [DataCollection]
    @State private var selectedTimeInterval = TimeInterval.day
    
    enum TimeInterval: String, CaseIterable, Identifiable {
        case day = "Day"
        case week = "Week"
        case month = "Month"
        
        var id: Self { return self}
    }
    
    init(userId: String) {
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/Data info")
    }
    func whatTab() -> String {
        var Tab = ""
        if( selectedTimeInterval == .day) {
            Tab = "On These Days"
        }
        else if(selectedTimeInterval == .week){
            Tab = "In These Weeks"
        }
        else {
            Tab = "In These Months"
        }
        return Tab
    }
    var body: some View {
        
            VStack{
                Picker(selection: $selectedTimeInterval) {
                    ForEach(TimeInterval.allCases) { interval in
                        Text(interval.rawValue)
                    }
                } label: {
                    Text("Time Interval for chart")
                }
                .pickerStyle(.segmented)
                .padding()
                
                
                
                Group{
                    Text("Your Biked Miles ") +
                    Text("\(whatTab())")
                }

                Group {
                    switch selectedTimeInterval {
                    case .day:
                        DailyStatsChartView(userId:  Auth.auth().currentUser?.uid ?? "")
                        
                    case .week: WeeklyChartsView(userId: Auth.auth().currentUser?.uid ?? "")
                       // Tab = "In These Weeks"
                        
                    case .month: MonthlyChartView(userId: Auth.auth().currentUser?.uid ?? "")
                        //Tab = "In These Months"
                    }
                }
                .aspectRatio(0.8, contentMode: .fit)
                
                Spacer()
            }
            .padding()
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(userId: "userID")
    }
}
