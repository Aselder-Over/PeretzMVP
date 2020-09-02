//
//  ViewDolbaebaController.swift
//  Peretz
//
//  Created by Асельдер on 28.08.2020.
//  Copyright © 2020 Асельдер. All rights reserved.
//

import UIKit

class ViewDolbaebaController: UIView {
        
    @IBOutlet weak var borderColorView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameRestLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    private var currentItem: DishModel?
    
    // ввключает настройки фрейма в конфигурации ниба
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // - хз
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // открывает корзину Делегат написать на нужном контроллере
    var openBasket: (() -> Void)?
    
    // отлавливает нажатие и инициализирует слушаетель (Сендер)
    func configure() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToBasket)))
        Observer.shared.observe(self, selector: #selector(updateData), key: DishUserDefaults.shared.updateBasketEvent)
        updateData()
    }
    
    // - доступ к навигейшн контроллеру
    @objc func goToBasket() {
        openBasket?()
    }
    
    // - Будет обновлять цену и название рестоарана0
    @objc func updateData() {
        priceLabel.text = String(DishUserDefaults.shared.basketPrice) + " ₽"
        
        let itemInCard = DishUserDefaults.shared.countItems()
        var text: String
        
        switch itemInCard {
        case 1:
            text = " блюдо"
        case 2, 3, 4:
            text = " блюда"
        default:
            text = " блюд"
        }
        
        nameRestLabel.text = String(itemInCard) + text
        
    }
}
