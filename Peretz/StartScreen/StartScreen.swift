//
//  StartScreen.swift
//  Peretz
//
//  Created by Асельдер on 24.08.2020.
//  Copyright © 2020 Асельдер. All rights reserved.
//

import UIKit

class StartScreenVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 4
        
    }
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    @IBAction func nextScreenButton(_ sender: Any) {
        
        // Засовываем в переменную файл сторибоарда
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // ЗАсосываем во вторую перменную ВьюКонтроллер по ID
        let viewController = storyboard.instantiateViewController(identifier: "ViewController")
        // Пушим новый вью контроллер
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
}
