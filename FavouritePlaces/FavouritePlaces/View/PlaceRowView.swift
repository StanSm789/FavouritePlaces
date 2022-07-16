//
//  PlaceRowView.swift
//  FavouritePlaces
//
//  Created by Stanislav Smirnov on 10/5/2022.
//

import SwiftUI

/**
This struct is a part of the View and is used to dispaly Place information in the MasterView
*/

struct PlaceRowView: View {
    /// information about the place that is passed from the MasterView
    @ObservedObject var place: Place
    /// @State variable that allows to display image inside this struct
    @State var image = Image(systemName: "photo").resizable()

    /// displaying place name and image in a list of the MasterView
    var body: some View {
        HStack {
            image.aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 25, alignment: .center)
            Text(place.placeName)
        }.task {
            image = await place.getImage()
        }
    }
}
