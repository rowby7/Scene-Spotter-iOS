//
//  MapView.swift
//  SceneSpotter
//
//  Created by Rowby Villanueva on 11/25/25.
//

import SwiftUI
import MapKit
struct MapView: View {
    @State private var cameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                Map(position: $cameraPosition)
                    .ignoresSafeArea()
                    .searchable(text: $searchText, prompt: "Search places")
                
                NavigationLink {
                    Text("Account & Settings View")
                } label: {
                    Image("profile")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    
                }
                .padding()
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing){
                    NavigationLink(destination: UploadView()) {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                }
            }
        }
    }
}


#Preview {
    MapView()
}
