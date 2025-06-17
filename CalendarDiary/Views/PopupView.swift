//
//  PopupView.swift
//  CalendarDiary
//
//  Created by 변예린 on 6/13/25.
//

import UIKit

final class PopupView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 배경이 될 UIView 생성
    let inputDiaryView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    // UIView 내 구성 요소 생성
    let mainLabel: UILabel = {
        var label = UILabel()
        label.text = "오늘 하루는 어땠나요?"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let diaryTextField: UITextField = {
        var textField = UITextField()
        textField.backgroundColor = .white
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholder = "오늘의 기분을 표현해주세요."
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let saveButton: UIButton = {
        var button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitle("저장하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = button.bounds.height / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton: UIButton = {
        var button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.tintColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = button.bounds.height / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let deleteButton: UIButton = {
        var button = UIButton(type: .system)
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        let largeBoldTrash = UIImage(systemName: "trash.fill", withConfiguration: buttonConfig)

        button.setImage(largeBoldTrash, for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // Stack View 설정
    lazy var buttons: [UIButton] = [saveButton, cancelButton]
    
    lazy var stackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: buttons)
        stview.spacing = 15
        stview.axis = .horizontal
        stview.distribution = .fillEqually
        stview.alignment = .fill
        stview.translatesAutoresizingMaskIntoConstraints = false
        return stview
    }()

    // 오토레이아웃 설정
    func setupUI() {
        
        self.addSubview(inputDiaryView)
        NSLayoutConstraint.activate([
            inputDiaryView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            inputDiaryView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            inputDiaryView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/3),
            inputDiaryView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
        ])
        
        inputDiaryView.addSubview(mainLabel)
        NSLayoutConstraint.activate([
            mainLabel.heightAnchor.constraint(equalToConstant: 30),
            mainLabel.widthAnchor.constraint(equalTo: inputDiaryView.widthAnchor, multiplier: 0.8),
            mainLabel.topAnchor.constraint(equalTo: inputDiaryView.topAnchor, constant: 80),
            mainLabel.centerXAnchor.constraint(equalTo: inputDiaryView.centerXAnchor)
        ])

        inputDiaryView.addSubview(diaryTextField)
        NSLayoutConstraint.activate([
            diaryTextField.heightAnchor.constraint(equalToConstant: 20),
            diaryTextField.widthAnchor.constraint(equalTo: inputDiaryView.widthAnchor, multiplier: 0.8),
            diaryTextField.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 10),
            diaryTextField.centerXAnchor.constraint(equalTo: inputDiaryView.centerXAnchor)
        ])
        
        inputDiaryView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 30),
            stackView.widthAnchor.constraint(equalTo: inputDiaryView.widthAnchor, multiplier: 0.8),
            stackView.topAnchor.constraint(equalTo: diaryTextField.bottomAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: inputDiaryView.centerXAnchor)
            
        ])
    }
    
}
