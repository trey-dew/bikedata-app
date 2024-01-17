//
//  SpeedView.swift
//  iosBikeDataApp
//
//  Created by user245042 on 10/1/23.
//
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import Charts
import SwiftUI

struct SpeedView: View {
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
            Tab = "Days"
        }
        else if(selectedTimeInterval == .week){
            Tab = "Weeks"
        }
        else {
            Tab = "Months"
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
                    Text("Your Average Speed these ") +
                    Text("\(whatTab())")
                }

                Group {
                    switch selectedTimeInterval {
                    case .day:
                        DailySpeedChartView(userId:  Auth.auth().currentUser?.uid ?? "")
                        
                    case .week: WeeklySpeedChartView(userId: Auth.auth().currentUser?.uid ?? "")
                       // Tab = "In These Weeks"
                        
                    case .month: MonthlySpeedChartView(userId: Auth.auth().currentUser?.uid ?? "")
                        //Tab = "In These Months"
                    }
                }
                .aspectRatio(0.8, contentMode: .fit)
                
                Spacer()
            }
            .padding()
    }
}

struct SpeedView_Previews: PreviewProvider {
    static var previews: some View {
        SpeedView(userId: "userID")
    }
}
