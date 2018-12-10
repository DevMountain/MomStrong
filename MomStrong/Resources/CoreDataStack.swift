//
//  CoreDataStack.swift
//  MomStrong
//
//  Created by DevMountain on 11/27/18.
//  Copyright © 2018 trevorAdcock. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStack{
    
    static let container: NSPersistentContainer = {
        
        let appName = Bundle.main.object(forInfoDictionaryKey: (kCFBundleNameKey as String)) as! String
        let container = NSPersistentContainer(name: appName)
        container.loadPersistentStores() { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext { return container.viewContext }
    
    static func save(){
        do{
            try CoreDataStack.context.save()
        } catch{
            print("Error Saving to Managed Object Context.  Item Not saved.  \(error)  ;  \(error.localizedDescription)")
        }
    }
}
