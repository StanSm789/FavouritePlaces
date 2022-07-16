//
//  PlaceViewModel.swift
//  FavouritePlaces
//
//  Created by Stanislav Smirnov on 8/5/2022.
//

import CoreData
import Foundation
import SwiftUI
import MapKit
import Combine
import CoreLocation

/// this variable is used by getImage() function of Place extension
fileprivate let defaultImage = Image(systemName: "photo")
/// this variable is used by getImage() function of Place extension
fileprivate var downloadedImages = [URL : Image]()

/**
     This extension is a part of the ViewModel and is used to extend functionality of the Model class called Place.
     
     1. This extension has six attributes: **placeName**, **urlString**, **detailsView**, **latitudeView**, **longitudeView**, **regionView**.
     2. This extension has five functions: **getImage**, **lookupCoordinates**, **lookupName**, **lookupSunriseAndSunset**, **save**
     3. This extension conforms to Identifiable protocol.
     
*/

extension Place: Identifiable {
    /// this variable is a computed property that returns Place "name" value or an empty string
    /// it also sets a new value for "name" and then saves it in CoreData
    var placeName: String {
        get { name ?? "" }
        set {
            name = newValue
            save()
        }
    }
    
    /// this variable is a computed property that returns Place "imageURL" value as a string or an empty string
    /// it also sets a new value for "imageURL" and then saves it in CoreData
    var urlString: String {
        get { imageURL?.absoluteString ?? "" }
        set {
            guard let url = URL(string: newValue) else { return }
            imageURL = url
            save()
        }
    }
    
    /// this function downloads and returns an image by using imageURL
    func getImage() async -> Image {
        guard let url = imageURL else { return defaultImage }
        if let image = downloadedImages[url] { return image }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            print("Downloaded \(response.expectedContentLength) bytes.")
            guard let uiImg = UIImage(data: data) else { return defaultImage }
            let image = Image(uiImage: uiImg).resizable()
            downloadedImages[url] = image
            return image
        } catch {
            print("Error downloading \(url): \(error.localizedDescription)")
        }
        return defaultImage
    }
    
    /// this variable is a computed property that return Place "details" value
    /// it also sets a new value for "details" and then saves it in CoreData
    var detailsView: String {
        get { details }
        set {
            details = newValue
            save()
        }
    }
    
    /// this variable is a computed property that returns Place "latitude" value
    /// it also sets a new value for "latitude" and then saves it in CoreData
    var latitudeView: String {
        get { "\(latitude)" }
        set {
            latitude = Float(newValue) ?? 0.0
            save()
        }
    }
    
    /// this variable is a computed property that returns Place "longitude" value
    /// it also sets a new value for "longitude" and then saves it in CoreData
    var longitudeView: String {
        get { "\(longitude)" }
        set {
            longitude = Float(newValue) ?? 0.0
            save()
        }
    }
    
    /// sunrise view
    var sunriseView: String {
        get { sunrise ?? "" }
        set {
            sunrise = newValue
            save()
        }
    }
    
    /// sunset view
    var sunsetView: String {
        get { sunset ?? "" }
        set {
            sunset = newValue
            save()
        }
    }
    
    /// this variable is a computed property that returns an instance of MKCoordinateRegion using "latitude" and "longitude"
    /// it also sets a new values for "latitude" and "longitude"
    var regionView: MKCoordinateRegion {
        get { MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)), latitudinalMeters: 5000, longitudinalMeters: 5000) }
        set {
            latitude = Float(newValue.center.latitude)
            longitude = Float(newValue.center.longitude)
            save()
        }
    }
    
    /// this function looks up place name by using coordinates (latitude and longitude)
    func lookupName(for latitude: Float, for longitude: Float) {
        //CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)
        let location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        let coder = CLGeocoder()
        coder.reverseGeocodeLocation(location) { optionalPlacemarks, optionalError in
            if let error = optionalError {
                print("Error looking up \(location.coordinate): \(error.localizedDescription)")
                return
            }
            guard let placemarks = optionalPlacemarks, !placemarks.isEmpty else {
                print("Placemarks came back empty")
                return
            }
            let placemark = placemarks[0]
            for value in [
                \CLPlacemark.name,
                \.country,
                \.isoCountryCode,
                \.postalCode,
                \.administrativeArea,
                \.subAdministrativeArea,
                \.locality,
                \.subLocality,
                \.thoroughfare,
                \.subThoroughfare
            ] {
                print(String(describing: placemark[keyPath: value]))
            }
            self.name = placemark.subAdministrativeArea ?? placemark.locality ?? placemark.subLocality ?? placemark.name ?? placemark.thoroughfare ?? placemark.subThoroughfare ?? placemark.country ?? ""
        }
    }
    
    /// this function looks up sunrise and sunset time for a particular place by using coordinates (latitude and longitude)
    func lookupSunriseAndSunset() -> [String] {
        var sunrise: String = "undefined"
        var sunset: String = "undefined"
        
        let urlString = "https://api.sunrise-sunset.org/json?lat=\(latitudeView)&lng=\(longitudeView)"
        guard let url = URL(string: urlString) else {
            print("Malformed URL: \(urlString)")
            return [sunrise, sunset]
        }
        guard let jsonData = try? Data(contentsOf: url) else {
            print("Could not look up sunrise or sunset")
            return [sunrise, sunset]
        }
        guard let api = try? JSONDecoder().decode(SunriseSunsetAPI.self, from: jsonData) else {
            print("Could not decode JSON API:\n\(String(data: jsonData, encoding: .utf8) ?? "<empty>")")
            return [sunrise, sunset]
        }
        let inputFormatter = DateFormatter()
        inputFormatter.dateStyle = .none
        inputFormatter.timeStyle = .medium
        inputFormatter.timeZone = .init(secondsFromGMT: 0)
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .none
        outputFormatter.timeStyle = .medium
        outputFormatter.timeZone = .current
        if let time = inputFormatter.date(from: api.results.sunrise) {
            sunrise = outputFormatter.string(from: time)
        }
        if let time = inputFormatter.date(from: api.results.sunset) {
            sunset = outputFormatter.string(from: time)
        }
        return [sunrise, sunset]
    }
    
    /// this function saves a new value in a CoreData
    @discardableResult
    func save() -> Bool {
        do {
            try managedObjectContext?.save()
        } catch {
            print("Error saving: \(error)")
            return false
        }
        return true
    }
}
