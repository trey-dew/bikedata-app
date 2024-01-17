//
//  LocationSearchViewModel.swift
//  iosBikeDataApp
//
//  Created by user245042 on 9/12/23.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject{
    
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedBikeLocation: BikeLocation?
    @Published var startTime: String?
    @Published var endTime: String?
    @Published var totalMiles: String?
    
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion) {
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error = error {
                print("DEBUG: Location Search Failed with error \(error.localizedDescription)")
                return
            }
                    
            guard let item = response?.mapItems.first else {return}
            let coordinate = item.placemark.coordinate
            self.selectedBikeLocation = BikeLocation(title: localSearch.title, coordinate: coordinate)
        }
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: completion)
    }
    
    func computeDistance() -> Double {
        guard let destCoordinate = selectedBikeLocation?.coordinate else { return 0.0}
        guard let userCoordinate = self.userLocation else { return 0.0}

        let userLocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)

        let destination = CLLocation(latitude: destCoordinate.latitude, longitude: destCoordinate.longitude)

        let tripDistanceInMiles = userLocation.distance(from: destination) / 1609.34

        return tripDistanceInMiles
    }
    
    func getDestinationRoute(from userLocation: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping(MKRoute) -> Void) {
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destPlacemark = MKPlacemark(coordinate: destination)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destPlacemark)
        let directions = MKDirections(request: request)
        
        directions.calculate {response, error in
            if let error = error {
                print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
                return
            }
            
            guard let route = response?.routes.first else {return}
            self.configureStartAndEndTimes(with: route.expectedTravelTime)
            completion(route)
        }
    }
    
    func configureStartAndEndTimes(with expectedTravelTime: Double) {
        let formatter = DateFormatter()
        let distanceFormatter = NumberFormatter()
        formatter.dateFormat = "hh:mm a"
        
        startTime = formatter.string(from: Date())
        endTime = formatter.string(from: Date() + expectedTravelTime)
        
        let distance = self.computeDistance()
        distanceFormatter.maximumFractionDigits = 2
        
        if let formattedString = distanceFormatter.string(from: NSNumber(value: distance)){
            totalMiles = formattedString
        }
    }
    
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
