//
//  CoreDataHelper.swift
//  GrawApp
//
//  Created by Alexander Kotik on 28.08.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper {
    
    static func insertStation (station :StationItem)
    {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let item = Station(entity: Station.entity(), insertInto: context)
            item.name = station.name
            item.id = station.id
            try? context.save()
        }
    }
    
    static func insertUserWithStation(userId :String, stationItem: Station)
    {
        if let context = getContext(){
            if !updateUserStation(userId: userId, stationItem: stationItem) {
                stationItem.isdefault = true
                let item = User(entity: User.entity(), insertInto: context)
                item.id = userId
                item.addToUserstation(stationItem)
                save()
                resetStationDefault(userId: userId)
                let userstation = UserStation(entity: UserStation.entity(), insertInto: context)
                userstation.isdefault = true
                userstation.user = item
                userstation.station = stationItem
                save()
            }
        }
    }
    
    static func updateUserStation(userId: String, stationItem:Station) ->Bool{
        
        if let context = getContext() {
            let fetchRequest = UserStation.fetchRequest() as NSFetchRequest<UserStation>
            fetchRequest.predicate = NSPredicate(format: "user.id ==%@ AND station.key == %@", userId,stationItem.key)
            if let userData = try? context.fetch(fetchRequest)  {
                if userData.count > 0 {
                    resetStationDefault(userId: userId)
                    let user = userData[0]
                    user.setValue(true, forKey: "isdefault")
                    save()
                    return true
                }
            }
        }
        return false
    }
    
    static func resetStationDefault(userId: String) {
        if let context = getContext() {
            let fetchRequest = UserStation.fetchRequest() as NSFetchRequest<UserStation>
            fetchRequest.predicate = NSPredicate(format: "user.id == %@ AND isdefault ==%@",userId, true as CVarArg)
            
            do {
                let dataSets = try context.fetch(fetchRequest)
                for data in dataSets {
                    data.isdefault = false
                }
                save()
            }
            catch {
                print (error.localizedDescription)
            }
        }
    }
    
    static func getDefaultStationFromUser(userId : String)->Station? {
        if let context = getContext() {
            
            let fetchRequest = UserStation.fetchRequest() as NSFetchRequest<UserStation>
            fetchRequest.predicate = NSPredicate(format: "user.id ==%@ AND isdefault ==%@", userId,true as CVarArg)
            do {
                let fetchData = try context.fetch(fetchRequest)
                if fetchData.count > 0 {
                    let station = fetchData[0].station
                    let user = fetchData[0].user
                    if let usr = user {
                        print ("User:\(String(describing: usr.id))")
                    }
                    return station
                }
            }
            catch {
                print (error.localizedDescription)
            }
            /*
            let fetchRequest = User.fetchRequest() as NSFetchRequest<User>
            fetchRequest.predicate = NSPredicate(format: "id ==%@", userId)
            
            if let userData = try? context.fetch(fetchRequest)  {
                if userData.count > 0 {
                    if let stations = userData[0].userstation?.allObjects as? [Station] {
                        for station in stations {
                            print ("station: \(station.id)")
                            if station.isdefault {
                                
                                return station
                            }
                        }
                        let firstItem = stations.first(where: { (item) -> Bool in
                            if !item.isdefault {
                                return true
                            }
                            else {
                                return false
                            }
                        })
                        if let fi = firstItem {
                            print ("station: \(fi.id)")
                        }
                        return firstItem
                        //return station
                    }
                
                }
            }*/
            
        }
        return nil
    }
    
    static func getAllUserStations(_ userId : String) -> [UserStation] {
        if let context = getContext(){
            let fetchRequest = UserStation.fetchRequest() as NSFetchRequest<UserStation>
            fetchRequest.predicate = NSPredicate(format: "user.id ==%@", userId)
            do {
                let itemArray = try context.fetch(fetchRequest)
                var stations: [UserStation] = []
                for item in itemArray {
                    stations.append(item)
                }
                return stations
            }
            catch {
                print (error.localizedDescription)
            }
        }
        return []
    }
    
    
    static func getContext() -> NSManagedObjectContext? {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            return context
        }
        return nil
    }
    
    static func getStationObject() ->Station? {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let entity = NSEntityDescription.entity(forEntityName: "Station", in: context)
        // you need to make sure you have a reference to your CoreData managedObjectContext
            let stationObject = NSManagedObject(entity: entity!, insertInto: context) as? Station
            return stationObject
    }
        return nil
    }
    
    static func deleteAllUsers(){
        if let context = getContext() {
            //delete UserStation First!!
            let fetschUserStation = UserStation.fetchRequest() as NSFetchRequest<UserStation>
            do {
                let userStationArray = try context.fetch(fetschUserStation)
                for item in userStationArray {
                    context.delete(item)
                }
                save()
            }
            catch {
                print (error.localizedDescription)
            }
        
    
            
            
            let fetchRequest = User.fetchRequest() as NSFetchRequest<User>
            if let userArray = try? context.fetch(fetchRequest)  {
                for user in userArray as [NSManagedObject] {
                    context.delete(user)
                    //print("delete user: \(user.id)")
                }
                save()
            }
        }
    }
    
    
    static func save() {
         if let context = getContext() {
            do {
                try context.save()
            }
            catch let error as NSError {
                print ("could not save: \(error), \(error.userInfo)")
            }
        }
    }
}
