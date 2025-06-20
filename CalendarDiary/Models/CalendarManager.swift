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
    var selectedDate: DateComponents? = nil
    var decorations: [DateComponents: UICalendarView.Decoration] = [:]
    
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
    func saveDiary(selectedDate: DateComponents?, diarytext: String, completion: @escaping () -> Void) {
        guard let date = selectedDate else {
            completion()
            return
        }
        
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                if let diary = NSManagedObject(entity: entity, insertInto: context) as? Diary {
                    // Diary에 실제 데이터 할당
                    diary.date = calendar.date(from: date)
                    diary.diarytext = diarytext
                    
                    appDelegate?.saveContext()
                }
            }
        }
        return completion()
    }
    
    // [Delete]
    func deleteDiary(date: DateComponents?, completion: @escaping () -> Void) {
        guard let dateComp = date else {
            completion()
            return
        }
        
        let date = calendar.date(from: dateComp)!
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "date == %@", date as CVarArg)
            
            do {
                if let fetchedDiary = try context.fetch(request) as? [Diary] {
                    if let targetDiary = fetchedDiary.first { context.delete(targetDiary)
                        appDelegate?.saveContext()
                    }
                }
                completion()
            } catch {
                print("삭제 실패")
                completion()
            }
        }
    }
    
    // [Update]
    func updateDiary(date: DateComponents?, newDiaryText: String, completion: @escaping () -> Void) {
        guard let dateComp = date else {
            completion()
            return
        }
        
        let date = calendar.date(from: dateComp)!
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "date == %@", date as CVarArg)
            
            do {
                if let FetchedDiary = try context.fetch(request) as? [Diary] {
                    if let targetDiary = FetchedDiary.first {
                        targetDiary.date = date
                        targetDiary.diarytext = newDiaryText
                        appDelegate?.saveContext()
                    }
                }
                completion()
            } catch {
                print("업데이트 실패")
                completion()
            }
            
        }
        
    }
    
    // Decoration 추가하기
    
    func addDecoration(text: String, on date: DateComponents) -> UICalendarView.Decoration {
        return .customView {
            let label = UILabel()
            label.text = text
            label.textAlignment = .center
            return label
        }
    }
    
    func addDecorations(decoration: UICalendarView.Decoration, on date: DateComponents) {
        decorations[date] = decoration
    }
    
}
