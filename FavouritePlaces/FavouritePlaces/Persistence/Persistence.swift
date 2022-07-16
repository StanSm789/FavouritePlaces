//
//  Persistence.swift
//  FavouritePlaces
//
//  Created by Stanislav Smirnov on 8/5/2022.
//

import CoreData

/**
     This class is used to store data in the datsabase.
     It has a constructor that initializes both the data model and persistence container.
     */

class Persistence {
    /// persistence object
    static let shared = Persistence()
    /// this container represents the database
    let container: NSPersistentContainer
    
    /// this constructor that initializes both the data model and persistence container
    init(inMemory: Bool = false) {
        
        /// creating an entity that replicates Place class
        let placeEntity = NSEntityDescription()
        /// givin a name to the entity
        placeEntity.name = "Place"
        /// giving a class name to the entity for a managed object system
        placeEntity.managedObjectClassName = "Place"
        
        /// name attribute of the entity
        let nameAttribute = NSAttributeDescription()
        nameAttribute.name = "name"
        nameAttribute.type = .string
        placeEntity.properties.append(nameAttribute)
        
        /// imageURL attribute of the entity
        let imgageURLAttribute = NSAttributeDescription()
        imgageURLAttribute.name = "imageURL"
        imgageURLAttribute.type = .uri
        placeEntity.properties.append(imgageURLAttribute)
        
        /// details attribute of the entity
        let detailsAttribute = NSAttributeDescription()
        detailsAttribute.name = "details"
        detailsAttribute.type = .string
        placeEntity.properties.append(detailsAttribute)
        
        /// latitude attribute of the entity
        let latitudeAttribute = NSAttributeDescription()
        latitudeAttribute.name = "latitude"
        latitudeAttribute.type = .float
        placeEntity.properties.append(latitudeAttribute)
        
        /// longitude attribute of the entity
        let longitudeAttribute = NSAttributeDescription()
        longitudeAttribute.name = "longitude"
        longitudeAttribute.type = .float
        placeEntity.properties.append(longitudeAttribute)
        
        /// sunrise
        let sunriseAttribute = NSAttributeDescription()
        sunriseAttribute.name = "sunrise"
        sunriseAttribute.type = .string
        placeEntity.properties.append(sunriseAttribute)
        
        /// sunset
        let sunsetAttribute = NSAttributeDescription()
        sunsetAttribute.name = "sunset"
        sunsetAttribute.type = .string
        placeEntity.properties.append(sunsetAttribute)
        
        /// managed object model that represents the underlying database
        let model = NSManagedObjectModel()
        /// adding all the entities we have in the database
        /// it's always an array of entities
        model.entities = [placeEntity]
        
        /// storing this database in a database container
        let container = NSPersistentContainer(name: "PlaceModel", managedObjectModel: model)
        
        /// nulling out database location if we want to keep it just in memory
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // loading the database
        container.loadPersistentStores { description, error in
            if let error = error {
                print("CoreData failed: \(error.localizedDescription)")
            }
        }
        
        // telling the contained what to do with data that needs to be merged into database
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        self.container = container
    }
    
    // displaying some default data
    static let preview: Persistence = {
        let persistence = Persistence(inMemory: true)
        let viewContext = persistence.container.viewContext
        
        for i in 0..<3 {
            let place = Place(context: viewContext)
            place.name = "New Place"
            place.imageURL = nil
            place.details = ""
            place.latitude = 0.0
            place.longitude = 0.0
        }
        
        /// saving the database
        viewContext.perform {
            try? viewContext.save()
        }
        
        /// returning persistence 
        return persistence
    }()
}
