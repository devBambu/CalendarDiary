//
//  ViewController.swift
//  CalendarDiary
//
//  Created by 변예린 on 6/9/25.
//

import UIKit

final class ViewController: UIViewController {
    
    let calendarManager = CalendarManger.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendarView()
        setupCalendarViewConstraints()
        
        reloadCalendarView(date: selectedDate ?? calendarManager.today)
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        reloadCalendarView(date: selectedDate!)
//    }
       
    
    // MARK: 캘린더 뷰 셋업
    
    private let calendarView = UICalendarView()
    var selectedDate: DateComponents? = nil
    var decorations: [DateComponents: UICalendarView.Decoration] = [:]
    
    func setupCalendarView() {
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        
        calendarView.visibleDateComponents = DateComponents(year: calendarManager.today.year!, month: calendarManager.today.month!, day: 1)
        
        calendarView.delegate = self
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
    }
    
    func setupCalendarViewConstraints() {
        view.addSubview(calendarView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func reloadCalendarView(date: DateComponents) {
        calendarView.reloadDecorations(forDateComponents: [date], animated: true)

    }
    
    // MARK: Popup 뷰 설정
  
    func popUp() {
        self.present(PopupViewController(), animated: true)
    }
      
}

extension ViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    // UICalendarViewDelegate
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if let selectedDate = selectedDate, selectedDate == dateComponents {
            
            // 해당 날짜의 다이어리 텍스트를 커스텀뷰로 출력
            return decorations[selectedDate]
            
        }
        return nil
    }
    
    // UICalendarSelectionSingleDateDelegate
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selection.setSelected(dateComponents, animated: true)
        selectedDate = dateComponents
        if let selectedDate = selectedDate {
            // 선택이 되면 입력받아 저장하는 메소드 실행
            calendarManager.selectedDate = selectedDate
            popUp()

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

