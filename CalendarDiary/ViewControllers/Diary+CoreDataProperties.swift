//
//  Diary+CoreDataProperties.swift
//  CalendarDiary
//
//  Created by 변예린 on 6/9/25.
//
//

import Foundation
import CoreData


extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var diarytext: String?
    @NSManaged public var date: Date?

}

extension Diary : Identifiable {

}
