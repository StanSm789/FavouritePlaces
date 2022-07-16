//
//  DetailView.swift
//  FavouritePlaces
//
//  Created by Stanislav Smirnov on 9/5/2022.
//

import SwiftUI
import MapKit

/**
This struct is a part of the View and is used to dispaly a representation of the model and receive the user's interaction with the view.
 It is used to display a DetailView for each place.
*/

struct DetailView: View {
    /// edit mode
    @Environment(\.editMode) var editMode
    /// observed object which is passed from the MasterView
    @ObservedObject var place: Place
    /// @State variables that allow to modify values inside the struct
    @State var placeName = ""
    @State var imageURL = ""
    @State var image = Image(systemName: "photo")
    @State var detailsView = ""
    @State var latitudeView = ""
    @State var longitudeView = ""
    @State var sunrise = "undefined"
    @State var sunset = "undefined"

    var body: some View {
        /// edit mode that allows the user to edit place attribute values
        VStack(alignment: .leading, spacing: 16) {
            if editMode?.wrappedValue == .active {
                TextField(place.placeName == "" ? "Enter place name" : place.placeName, text: $placeName) {
                    $place.placeName.wrappedValue = placeName
                }
                TextField("Enter image URL", text: $imageURL) {
                    $place.urlString.wrappedValue = imageURL
                }
                HStack {
                    Text("Latitude:")
                    TextField(place.latitudeView, text: $latitudeView) {
                        $place.latitudeView.wrappedValue = latitudeView
                    }
                }
                HStack {
                    Text("Longitude:")
                    TextField(place.longitudeView, text: $longitudeView) {
                        $place.longitudeView.wrappedValue = longitudeView
                    }
                }
                Text("Enter Location Details:").bold().padding(.horizontal, 30)
                TextField(place.detailsView == "" ? "Location details" : place.details, text: $detailsView) {
                    $place.detailsView.wrappedValue = detailsView
                }
                Spacer()
            } else {
                /// Displaying information about the Place and providing a navigation link to the map of this Place
                List {
                image.aspectRatio(contentMode: .fit)
                HStack {
                    NavigationLink(destination: MapView(place: place)) {
                        Map(coordinateRegion: $place.regionView).frame(width: 50, height: 50)
                        Text("Map of \(place.placeName)")
                    }
                }
                Text(place.detailsView)
            }
        }
        }.padding()
        .navigationTitle(place.placeName)
        .task {
            image = await place.getImage()
        }.onAppear() {
            let sunriseSunset = place.lookupSunriseAndSunset()
            place.sunriseView = sunriseSunset[0]
            place.sunsetView = sunriseSunset[1]
            sunrise = place.sunriseView
            sunset = place.sunsetView
        }
        /// displaying sunrise and sunset information for the Place
        HStack {
            Label(sunrise, systemImage: "sunrise")
            Spacer()
            Label(sunset,  systemImage: "sunset")
        }.padding()
    }
}
