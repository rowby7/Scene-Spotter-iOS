//
//  LocationSearchManager.swift
//  SceneSpotter
//
//  Created by Rowby Villanueva on 3/18/26.
//

import Foundation
import MapKit
import Combine

class LocationSearchManager: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    
    
    @Published var results: [MKLocalSearchCompletion] = []
    var completer = MKLocalSearchCompleter()
    
    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = .address
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results
        
    }
    
    func updateQuery(_ query: String) {
        completer.queryFragment = query
    }
    
    
}
