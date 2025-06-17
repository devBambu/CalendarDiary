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
            
            guard let diary = calendarManager.getDiary(selectedDate: date) else {
                // 기존 데이터가 없을 때
                popUpView.diaryTextField.placeholder = "오늘의 기분을 5글자로 표현해주세요."
                
                popUpView.saveButton.setTitle("저장하기", for: .normal)
                popUpView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
                return
            }
            // 기존 데이터가 있을 때
            popUpView.diaryTextField.placeholder = diary.diarytext
            
            popUpView.saveButton.setTitle("수정하기", for: .normal)
            popUpView.saveButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        }
    }

    
    @objc func saveButtonTapped(_ sender: UIButton) {
        if let date = calendarManager.selectedDate {
            if let newText = popUpView.diaryTextField.text {
                calendarManager.saveDiary(selectedDate: date, diarytext: newText) { return }
                let decoration = calendarManager.addDecoration(text: newText, on: date)
                calendarManager.addDecorations(decoration: decoration, on: date)
                dismiss(animated: true)
            }
        }
    }
        
    @objc func updateButtonTapped(_ sender: UIButton) {
        if let date = calendarManager.selectedDate {
            if let newText = popUpView.diaryTextField.text {
                calendarManager.updateDiary(date: date, newDiaryText: newText) { return }
                let decoration = calendarManager.addDecoration(text: newText, on: date)
                calendarManager.addDecorations(decoration: decoration, on: date)
                dismiss(animated: true)
            }
        }
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton) {
            dismiss(animated: true)
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        if let date = calendarManager.selectedDate {
            calendarManager.deleteDiary(date: date) {
                self.calendarManager.decorations[date] = nil
            }
        }
        dismiss(animated: true)
    }
    
}
 

extension PopupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
        if !(newLength <= 5) {
            let alert = UIAlertController(title: "글자가 너무 많습니다!", message: "5글자 이내로 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
            return false
        }
        return true
    }

}
