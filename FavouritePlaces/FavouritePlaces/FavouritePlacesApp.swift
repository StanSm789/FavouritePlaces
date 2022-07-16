//
//  FavouritePlacesApp.swift
//  FavouritePlaces
//
//  Created by Stanislav Smirnov on 8/5/2022.
//

import SwiftUI
import MapKit

/**
This struct is an entry point for the **FavouritePlaces** app.
 It iinjects managed object context into the SwiftUI environment
*/

@main
struct FavouritePlacesApp: App {
    /// persistence variable
    let persistence = Persistence.shared
    
    /// the first scene for the app
    /// it  injects managed object context into the SwiftUI environment
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}

