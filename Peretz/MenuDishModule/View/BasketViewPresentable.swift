//
//  BasketViewPresentable.swift
//  Peretz
//
//  Created by Асельдер on 28.08.2020.
//  Copyright © 2020 Асельдер. All rights reserved.
//

import Foundation
import UIKit

protocol BasketViewPresentable: class {
    
    var isBasketVisible: Bool { get set }
    
    func openBasket()
}

// Показать / скрыть корзину + Анимация
extension BasketViewPresentable where Self: UIViewController {
    
    func showBasketView() {
        
        // Отслеживаем вызов корзины и не допускаем повторной анимации
        Observer.shared.notify(DishUserDefaults.shared.updateBasketEvent)
        
        guard !isBasketVisible else { return }
        
        self.isBasketVisible = true
        
        // регистрация ниба
        let basketView = UINib(nibName: "ViewDolbaeba25", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ViewDolbaebaController
        
        // конфиг ниба
        basketView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 52)
        basketView.backgroundColor = .clear
        basketView.configure()
        basketView.openBasket = { self.openBasket() }
        
        // показ ниба на всех экранах
        // UIApplication.shared.keyWindow!.addSubview(basketView)
        
        UIView.animate(withDuration: 0.3, animations: {
            basketView.frame = CGRect(x: 0, y: self.view.frame.height - 52, width: self.view.frame.width, height: 52)
            
            
        })
        view.addSubview(basketView)
    }
    
    func hideBasketView() {
                
        self.isBasketVisible = false
        
        //Ремов (СабВью - то есть наше вью долбаеба)
        view.subviews.forEach { (subView) in
            
            if (subView.isKind(of: ViewDolbaebaController.self)) {
                
                UIView.animate(withDuration: 0.3, animations: {
                    subView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 52)
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    subView.removeFromSuperview()
                })
            }
        }
    }
}
