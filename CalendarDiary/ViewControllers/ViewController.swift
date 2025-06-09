//
//  ViewController.swift
//  CalendarDiary
//
//  Created by 변예린 on 6/9/25.
//

import UIKit

final class ViewController: UIViewController {

    let calendarManager = CalendarManger()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendarView()
        setupCalendarViewConstraints()
        
    }

    // MARK: 네비게이션 바 셋업
    func setupNaviBar() {
        self.title = "\(calendarManager.today.year!)"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    // MARK: 캘린더 뷰 셋업
    
    private let calendarView = UICalendarView()
    var selectedDate: DateComponents? = nil
    
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
    
    func setupAlertController() {
        let inputDiary = UIAlertController(title: "내용 추가하기", message: "오늘 하루는 어땠나요?", preferredStyle: .alert)
        self.present(inputDiary, animated: true)
        
        inputDiary.addTextField { (textField) in
            textField.placeholder = "내용을 입력해주세요. (5글자 이내)"
        }
        

    }

    
}

extension ViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {

    // UICalendarViewDelegate
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        print(#function)
        
        if let selectedDate = selectedDate, selectedDate == dateComponents {
            setupAlertController()
        }
        return nil
    }
    
    // UICalendarSelectionSingleDateDelegate
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selection.setSelected(dateComponents, animated: true)
        selectedDate = dateComponents
        if let date = selectedDate {
            calendarView(calendarView, decorationFor: date)
            reloadCalendarView(date: Calendar.current.date(from: date)!)
        }
    }

    
}
