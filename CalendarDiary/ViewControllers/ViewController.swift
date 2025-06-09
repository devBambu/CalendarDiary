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
        
        setupNaviBar()
        
    }

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
    


}

