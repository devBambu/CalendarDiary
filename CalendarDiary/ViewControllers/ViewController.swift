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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadCalendarView(date: calendarManager.calendar.date(from: calendarManager.today)!)
    }
       
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
    
    func reloadCalendarView(date: Date) {
        calendarView.reloadDecorations(forDateComponents: [Calendar.current.dateComponents([.year, .month, .day], from: date)], animated: true)

    }
    
    // MARK: Alert 컨트롤러 셋업
    
    func setupAlertController(selectedDate: DateComponents) {
        let diaryAlert = UIAlertController(title: "오늘 하루는 어떘나요?", message: "오늘의 기분을 표현해주세요.", preferredStyle: .alert)
        self.present(diaryAlert, animated: true)
        
        let diary = calendarManager.getDiary(selectedDate: selectedDate)
        
        if let diary = diary {
            updateDiary(diaryAlert: diaryAlert, diary: diary)
            
        } else {
            writeDiary(diaryAlert: diaryAlert, selectedDate: selectedDate)
        }
        
        
    }
    
    func writeDiary(diaryAlert: UIAlertController, selectedDate: DateComponents?) {

        var diaryText = ""
        
        diaryAlert.addTextField { (textField) in
            textField.placeholder = "내용을 입력해주세요."
            textField.setPlaceholder(color: .lightGray)
        }
        
        let writeAction = UIAlertAction(title: "작성하기", style: .default) { [weak diaryAlert] _ in
            guard let textFields = diaryAlert?.textFields else { return }
            if let text = textFields[0].text { diaryText = text }
            self.calendarManager.saveDiary(selectedDate: selectedDate!, diarytext: diaryText) { return }
        }
        diaryAlert.addAction(writeAction)
        let decoration = addDecoration(text: diaryText, on: selectedDate!)
        addDecorations(decoration: decoration, on: selectedDate!)
        
    }

    
    func updateDiary(diaryAlert: UIAlertController, diary: Diary) {
        
        var newText = ""
        
        diaryAlert.addTextField() { (textField) in
            textField.placeholder = diary.diarytext
            textField.textColor = .black
        }
        
        let updateAction = UIAlertAction(title: "수정하기", style: .default) { [weak diaryAlert] _ in
            guard let textFields = diaryAlert?.textFields else { return }
            
            if let text = textFields[0].text { newText = text }
            
            self.calendarManager.updateDiary(diary: diary, newDiaryText: newText, completion: { return })
        }
        
        diaryAlert.addAction(updateAction)

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
            let date = Calendar.current.date(from: selectedDate)!
            // 선택이 되면 입력받아 저장하는 메소드 실행
            setupAlertController(selectedDate: selectedDate)
            reloadCalendarView(date: date)
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
