//
//  CalendarManager.swift
//  CalendarDiary
//
//  Created by 변예린 on 6/9/25.
//

import UIKit

final class CalendarManger {
    
    let calendar = Calendar.current
    let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
}
