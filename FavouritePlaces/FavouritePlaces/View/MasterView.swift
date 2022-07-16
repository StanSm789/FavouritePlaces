//
//  MasterView.swift
//  FavouritePlaces
//
//  Created by Stanislav Smirnov on 9/5/2022.
//

import SwiftUI
import MapKit

/**
 This struct is a part of the View and is used to dispaly a representation of the model and receive the user's interaction with the view.
 It is used to display a list of Places and provides navigation links to each of them.
*/

struct MasterView: View {
    /// this environment property is used to read the managed object context
    @Environment(\.managedObjectContext) var viewContext
    /// edit mode
    @Environment(\.editMode) var editMode
    /// fetching data from the database
    @FetchRequest(sortDescriptors: [SortDescriptor(\Place.name, order: .forward)], animation: .default) var places: FetchedResults<Place>
    
    var body: some View {
        /// displaying all elements fetched from the database and provide a user to go into DetailView if each element
        /// a user can also add a new Place or delete an existing one
        List {
            ForEach(places){ place in
                NavigationLink {
                    DetailView(place: place)
                        .navigationBarItems(trailing: EditButton())
                } label: {
                    PlaceRowView(place: place)
                }
            }
            .onDelete(perform: deletePlaces)
        }
        .navigationTitle("Favourite Places")
        .navigationBarItems(leading: EditButton(), trailing: Button(action: { addPlace() }, label: { Image(systemName: "plus") }))
    }
    
    /// this function is used to add a new Place
    private func addPlace() {
        withAnimation {
            let newPlace = Place(context: viewContext)
            newPlace.name = "New Place"

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    /// this fucntion is used to delete already existing place 
    private func deletePlaces(offsets: IndexSet) {
        withAnimation {
            offsets.map { places[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
