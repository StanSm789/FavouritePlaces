//
//  Place.swift
//  FavouritePlaces
//
//  Created by Stanislav Smirnov on 8/5/2022.
//

import CoreData
import MapKit

/**
     This class is a part of the Model and is used to store data of each place.
     This class has six attributes: **name**, **imageURL**,  **details**, **latitude**, **longitude**,  **region**.
     It also conform to @ObservableObject via NSManagedObject, so that it can be used inside views.
 
     */

@objc(Place)
class Place: NSManagedObject {
    /// this variable is used to store name of the place
    @NSManaged var name: String?
    /// this variable is used to store inamge url
    @NSManaged var imageURL: URL?
    /// this variable is used to store details about the place
    @NSManaged var details: String
    /// this variable is used to store latitude of the place
    @NSManaged var latitude: Float
    /// this variable is used to store longitude of the place
    @NSManaged var longitude: Float
    /// this variable is used to store the region
    @NSManaged var region: MKCoordinateRegion
    /// this variable is used to store name of the place
    /// sunrise
    @NSManaged var sunrise: String?
    /// sunset
    @NSManaged var sunset: String?
}
