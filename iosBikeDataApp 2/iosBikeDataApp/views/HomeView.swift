//
//  HomeView.swift
//  iosBikeDataApp
//
//  Created by user245042 on 9/6/23.
//
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import Charts

struct HomeView: View {
    @StateObject var staticBikeViewModel = StaticBikeViewViewModel()
    @ObservedObject var homeViewViewModel = HomeViewViewModel(userId: Auth.auth().currentUser?.uid ?? "")
    @FirestoreQuery var items: [DataCollection]
    @State private var visibleItems = 7
    
    
    init(userId: String) {
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/Data info")
    }
    
    var body: some View {
        NavigationStack{
            List{
                Text("Welcome back! Here are your stats!")
                    .bold()
                
                if let changedMilesStats = changedMilesStats() {
                    HStack(alignment: .firstTextBaseline) {
                        Image(systemName: isPositiveChange ?
                              "arrow.up.right" : "arrow.down.right") .bold()
                            .foregroundColor(isPositiveChange ? .green : .red)
                        
                        Text("Your Miles ") +
                        Text(changedMilesStats)
                            .bold() +
                        Text(" in the last 90 days.")
                    }
                }
                NavigationLink {
                    StatsView(userId: Auth.auth().currentUser?.uid ?? "")
                } label: {
                    DailyStatsChartView(userId:  Auth.auth().currentUser?.uid ?? "")
                        .frame(height: 100)
                        .chartXAxis(.hidden)
                        .chartYAxis(.hidden)
                }
                Text("Average Speed")
                    .bold()
                NavigationLink{
                    SpeedView(userId: Auth.auth().currentUser?.uid ?? "")
                } label: {
                    DailySpeedChartView(userId:  Auth.auth().currentUser?.uid ?? "")
                        .frame(height: 100)
                        .chartXAxis(.hidden)
                        .chartYAxis(.hidden)
                }
                .padding()
                
                let sortedItems = items.sorted {$0.createdDate > $1.createdDate}
                ForEach(sortedItems.prefix(visibleItems)) { item in
                    DataCollectionView(item: item)
                }
                
                if visibleItems < items.count {
                    Button("See More") {
                        visibleItems += 7
                    }
                }
                
                Text("Total stats: \(homeViewViewModel.totalStats.toDouble())")
                
                
            }
            .navigationTitle("Home View")
            .onAppear() {
                self.homeViewViewModel.fetchData()
            }
            
        }
           
    }
    var percentage: Double {
        Double(homeViewViewModel.totalStats) /
        Double(homeViewViewModel.lastTotalStats) - 1
    }
            
    var isPositiveChange: Bool {
        percentage > 0
    }

    func changedMilesStats() -> String? {
         let percentage = percentage
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        
        guard let formattedPercentage = numberFormatter.string(from: NSNumber(value: percentage)) else {
            return nil
        }
        
        let changedDescription = percentage < 0 ? "decreased by " : "increased by "
        
        return changedDescription + formattedPercentage
    }
}




struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(userId: "userID")
    }
}


