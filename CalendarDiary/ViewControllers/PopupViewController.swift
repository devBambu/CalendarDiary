//
//  PopupViewController.swift
//  CalendarDiary
//
//  Created by 변예린 on 6/16/25.
//

import UIKit

final class PopupViewController: UIViewController {

    private let popUpView = PopupView()
    
    override func loadView() {
        self.view = popUpView
    }
    
    let calendarManager = CalendarManger.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        
        popUpView.diaryTextField.delegate = self

        popUpView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        popUpView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        // 기존 데이터가 있을 때
        if let date = calendarManager.selectedDate {
            if let diary = calendarManager.getDiary(selectedDate: date) {
                // 기존 데이터가 있을 때
                popUpView.diaryTextField.placeholder = diary.diarytext
                popUpView.diaryTextField.setPlaceholder(color: .lightGray)
                popUpView.saveButton.setTitle("수정하기", for: .normal)
                popUpView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
            } else {
                // 기존 데이터가 없을 때
                popUpView.saveButton.setTitle("저장하기", for: .normal)
                popUpView.saveButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
            }
        }
    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        if let date = calendarManager.selectedDate {
            if var newText = popUpView.diaryTextField.text {
                calendarManager.saveDiary(selectedDate: date, diarytext: newText) { return }
            }
        }
    }
        
    @objc func updateButtonTapped(_ sender: UIButton) {
        if let date = calendarManager.selectedDate {
            if var newText = popUpView.diaryTextField.text {
                calendarManager.updateDiary(date: date, newDiaryText: newText) { return }
            }
        }
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        if let date = calendarManager.selectedDate {
            calendarManager.deleteDiary(date: date) { return }
        }
    }
    
}
 

extension PopupViewController: UITextFieldDelegate {
    
}
