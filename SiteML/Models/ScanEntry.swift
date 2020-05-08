//
//  ScanEntry.swift
//  SiteML
//
//  Created by Alex Rabin on 5/2/20.
//  Copyright © 2020 Alex Rabin. All rights reserved.
//

import Foundation
import CoreData

public class ScanEntry: NSManagedObject, Identifiable{
    @NSManaged public var createdAt : Date?
    @NSManaged public var ocrText : String?
    @NSManaged public var imageLabels : String?
    @NSManaged public var image : Data?
    
}
extension ScanEntry {
    static func getAllEntries() -> NSFetchRequest<ScanEntry>{
        let request : NSFetchRequest<ScanEntry> = ScanEntry.fetchRequest() as! NSFetchRequest<ScanEntry>
        
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        return request
        
    }
}
