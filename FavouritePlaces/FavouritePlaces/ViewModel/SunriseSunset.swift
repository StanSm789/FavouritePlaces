//
//  SunriseSunset.swift
//  FavouritePlaces
//
//  Created by Stanislav Smirnov on 30/5/2022.
//

import Foundation

/**
     This struct is a part of the ViewModel and is used to hold sunrise and sunset time.
*/
struct SunriseSunset: Codable {
    var sunrise: String
    var sunset: String
}

/**
     This struct is a part of the ViewModel and is used to hold SunriseSunset result inside lookupSunriseAndSunset() function of the Place extension,
     which is located in PlaceViewModel.swift file.
*/
struct SunriseSunsetAPI: Codable {
    var results: SunriseSunset
    var status: String?
}
