//
//  MapView.swift
//  FavouritePlaces
//
//  Created by Stanislav Smirnov on 15/5/2022.
//

import SwiftUI
import MapKit

/**
This struct is a part of the View and is used to dispaly a representation of the model and receive the user's interaction with the view.
 It is used to display a Map details for each place.
*/

struct MapView: View {
    /// edit mode
    @Environment(\.editMode) var editMode
    /// observed object which is passed from the DetailVIew
    @ObservedObject var place: Place
    @State var regionViewModel: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -27.47, longitude: 153.02), latitudinalMeters: 5000, longitudinalMeters: 5000)
    
    var body: some View {
        VStack {
            VStack {
                /// enabling editing Place location by using its name or coordinates
                if editMode?.wrappedValue == .active {
                    HStack {
                        Button {
                            print("Looking up \(place.placeName)")
                            lookupCoordinates(place: place.placeName)
                        } label: {
                            Label("", systemImage: "magnifyingglass")
                        }
                        TextField("Enter Place Name", text: $place.placeName)
                    }
                    HStack {
                        Map(coordinateRegion: $regionViewModel)
                    }
                    HStack {
                        Button {
                            print("Looking up \(regionViewModel.latitudeString) \(regionViewModel.longitudeString)")
                            place.lookupName(for: Float(regionViewModel.latitudeString) ?? 0.0, for: Float(regionViewModel.longitudeString) ?? 0.0)
                        } label: {
                            Label("", systemImage: "globe.europe.africa.fill")
                        }
                        Text("Lat:")
                        TextField("Enter Latitude", text: $regionViewModel.latitudeString) {
                    }
                    HStack {
                        Text("Lon:")
                        TextField("Enter Longitude", text: $regionViewModel.longitudeString)
                            }
                        }
                } else {
                    /// displaying the map in a regualar mode
                Text($place.placeName.wrappedValue)
                HStack {
                    Map(coordinateRegion: $regionViewModel)
                }
                    HStack {
                        Text("Latitude: \(regionViewModel.latitudeString)")
                    }
                    HStack {
                        Text("Longitude: \(regionViewModel.longitudeString)")
                    }
                }
            }
            .navigationBarItems(trailing: EditButton())
        }.onAppear() {
            regionViewModel.latitudeString = place.latitudeView
            regionViewModel.longitudeString = place.longitudeView
        }
        .onDisappear() {
            place.latitudeView = regionViewModel.latitudeString
            place.longitudeView = regionViewModel.longitudeString
        }
        
    }
    
    /// this function looks up coordinates by using place name
    private func lookupCoordinates(place: String) {
        let coder = CLGeocoder()
        coder.geocodeAddressString(place) { optionalPlacemarks, optionalError in
            if let error = optionalError {
                print("Error looking up \(place): \(error.localizedDescription)")
                return
            }
            guard let placemarks = optionalPlacemarks, !placemarks.isEmpty else {
                print("Placemarks came back empty")
                return
            }
            let placemark = placemarks[0]
            guard let location = placemark.location else {
                print("Placemark has no location")
                return
            }
            regionViewModel.latitudeString = String(location.coordinate.latitude)
            regionViewModel.longitudeString = String(location.coordinate.longitude)
        }
    }
    
}
