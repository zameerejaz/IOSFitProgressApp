//
//  Weights+CoreDataClass.swift
//  FitProgress
//
//  Created by Zameer Ejaz on 08/07/2019.
//  Copyright © 2019 Zameer Ejaz. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit


public class Weights: NSManagedObject {
    
    private class func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentController.viewContext
    }
    
     class func saveObject(weightInput : Double , dateStamp : String, weekNum : Int) -> Bool{
        
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Weights", in: context)!
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        
        managedObject.setValue(weightInput, forKey: "WeightInput")
        managedObject.setValue(dateStamp, forKey: "dateStamp")
        managedObject.setValue(weekNum, forKey: "weekNum")
        
        
        do{
            try context.save()
            print("item has been saved")
            return true
            
        }catch {
            return false
        }
    
    }
    
    class func fetchObject(week : Int) -> [Weights]?{
        let context = getContext()
        var weightInputUsers : [Weights]? = nil
        
        do {
            let fetchRequest : NSFetchRequest<Weights> = Weights.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "weekNum =%@", NSNumber(value: week))
            weightInputUsers = try context.fetch(fetchRequest)
            return weightInputUsers
        }catch {
            print("Error fetching the data \(error)")
            return weightInputUsers
        }
    }
    
    
    class func fetchSpecificObjectByWeekDate(week2 : Int, date: String) -> Int{
        let context = getContext()
        //var weightInputUsers : [Weights]? = nil
        do{
            let fetchRequest : NSFetchRequest<Weights> = Weights.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "weekNum =%@ AND dateStamp =%@" , NSNumber(value: week2), date)
           // weightInputUsers = try context.fetch(fetchRequest)
            return try context.count(for: fetchRequest)
        }catch{
            print("Could not count the found items")
        }
        return 0
    }
    
    
    class func clearData(){
        let context = getContext()
        let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Weights")
        fetchRequest2.returnsObjectsAsFaults = false
        do{
            let results = try context.fetch(fetchRequest2)
            for object in results {
                guard let objectData = object as? NSManagedObject else {
                    continue
                }
                context.delete(objectData)
            }
           
        } catch {
            print("Deleting Data error")
        }
    }
    
    class func updateUsers(dateStamp : String, weight : Double, weekNum : Int){
          let context = getContext()
        do{
            let fetchRequest : NSFetchRequest<Weights> = Weights.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "weekNum =%@ AND dateStamp =%@" , NSNumber(value: weekNum), dateStamp)
            let object = try context.fetch(fetchRequest)
            let specificObject = object[0]
            specificObject.setValue(dateStamp, forKey: "dateStamp")
            specificObject.setValue(weekNum, forKey: "weekNum")
            specificObject.setValue(weight, forKey: "weightInput")
            
            do {
                try context.save()
                print("item has been updated")
            }catch{
                print("item could not be updated")
            }
            
            
        }catch{
            print("Could not count the found items")
        }
        
    }
    
    
    static func == (lhs : Weights, rhs : Weights) -> Bool{
        return lhs.weekNum == rhs.weekNum && lhs.dateStamp == rhs.dateStamp
    }
    
    
    

}
