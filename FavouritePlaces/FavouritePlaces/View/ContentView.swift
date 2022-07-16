//
//  ContentView.swift
//  FavouritePlaces
//
//  Created by Stanislav Smirnov on 8/5/2022.
//

import SwiftUI
import MapKit

/**
This struct is a part of the View and is used to connect FavouritePlacesApp struct with MasterView struct
*/

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            MasterView()
        }
    }
}
