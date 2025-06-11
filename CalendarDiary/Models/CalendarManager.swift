//
//  CalendarManager.swift
//  CalendarDiary
//
//  Created by 변예린 on 6/9/25.
//

import UIKit
import CoreData

final class CalendarManger {
    
    let calendar = Calendar.current
    lazy var today = calendar.dateComponents([.year, .month, .day], from: Date())
    
    // MARK: CoreData Setup
    static let shared = CalendarManger()
    private init() {}
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    let modelName: String = "Diary"
    
    // [Read]
    func getAllDiary() -> [Diary] {
        var allDiary: [Diary] = []
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            let dateOrder = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [dateOrder]
            
            do {
                if let fetchAllDiary = try context.fetch(request) as? [Diary] {
                    allDiary = fetchAllDiary
                }
            } catch {
                print("가져오기 실패")
            }
        }
        
        return allDiary
    }
    
    func getDiary(selectedDate: DateComponents) -> Diary? {
        let date = calendar.date(from: selectedDate)!
        var diary: Diary? = nil
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "date == %@", date as CVarArg)
            
            do {
                if let targetdiary = try context.fetch(request).first as? Diary {
                    diary = targetdiary
                }
            } catch {
                print("선택한 날짜의 다이어리 불러오기 실패")
            }
        }
        return diary
    }
    
    // [Create]
    func saveDiary(selectedDate: DateComponents, diarytext: String, completion: @escaping () -> Void) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                if let diary = NSManagedObject(entity: entity, insertInto: context) as? Diary {
                    // Diary에 실제 데이터 할당
                    diary.date = calendar.date(from: selectedDate)
                    diary.diarytext = diarytext
                    
                    appDelegate?.saveContext()
                }
            }
        }
        return completion()
    }
    
    // [Delete]
    func deleteDiary(diary: Diary, completion: @escaping () -> Void) {
        guard let date = diary.date else {
            completion()
            return
        }
        
        if let context = context {
            context.delete(diary)
            appDelegate?.saveContext()
        }
        completion()
    }
    
    // [Update]
    func updateDiary(diary: Diary, newDiaryText: String, completion: @escaping () -> Void) {
        guard let selectedDate = diary.date else {
            completion()
            return
        }
        
        if let context = context {
            diary.diarytext = newDiaryText
            appDelegate?.saveContext()
        }
        completion()
    }
}
