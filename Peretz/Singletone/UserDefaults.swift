//
//  UserDefaults.swift
//  Peretz
//
//  Created by Асельдер on 25.08.2020.
//  Copyright © 2020 Асельдер. All rights reserved.
//

import Foundation

struct DishMenuUD: Codable {
    var menuItem: DishModel
    var dishCount: Int
}

final class DishUserDefaults {
    
    let showBasketEvent   = "SHOW_BASKET"
    let hideBasketEvent   = "HIDE_BASKET"
    let updateBasketEvent = "UPDATE_BASKET"
    
    private let key       = "dish_peretz_ID"
    private let keyPrice  = "BASKET_PRICE"
    
    
    //SinglTone
    static let shared = DishUserDefaults()
    
    // Собираем цены корзины
    var basketPrice = 0
    
    
    private var menu: [Int: Int] = [:] {
        didSet {
            // Когда записывается или удаляется один объект из ЮД то
            if (menu.isEmpty) {
                // Зарегай нотификацию хайд баскет
                Observer.shared.notify(hideBasketEvent, object: nil)
            } else {
                // Зарегай нотификацию шов баскет
                Observer.shared.notify(showBasketEvent, object: nil)
            }
            
        }
    }
    
    private init() {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let menuFromDataBase = try? JSONDecoder().decode([Int:Int].self, from: data) else { return }
        
        //Сохраняем цену в юд
        let price = UserDefaults.standard.object(forKey: keyPrice) as? Int
        basketPrice = price ?? 0
        for (k, v) in menuFromDataBase {
            menu.updateValue(v, forKey: k)
        }
    }
    
    // MARK: - Public func
    
    // Проверка на нахождение в ЮзерДефаултс
    
    func checkCount(productId: Int) -> Int {
        
        for (id, quantity) in menu {
            if (id == productId) { return quantity }
        }
        
        return 0
    }
    
    // Проверка отображения корзины
    func showBasket() -> Bool {
        if menu.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    //Проверка и добавление элемента или увеличение кол-ва
    func plusCount(productId: Int) {
        
        var isNewItem = true
        
        for (id, quantity) in menu {
            if (id == productId) {
                menu.updateValue(quantity + 1, forKey: id)
                isNewItem = false
            }
        }
        if (isNewItem) {
            menu.updateValue(1, forKey: productId)
        }
        
        synchronize()
    }
    
    // Проверка и удаление записи
    func removeCount(productId: Int) {
        
        for (id, quanity) in menu {
            if (id == productId) {
                if (quanity == 1) {
                    
                    // ремув кванити не работает
                    menu.removeValue(forKey: id)
                    
                    synchronize()
                } else {
                    menu.updateValue(quanity - 1, forKey: id)
                }
            }
        }
    }
    
    // Очистка
    func clear() {
        menu.removeAll()
        synchronize()
    }
    
    // Обновление данных
    private func synchronize() {
        guard let menu = try? JSONEncoder().encode(menu) else { return }
        UserDefaults.standard.set(menu, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    // Подсчет количества позиций в корзине
    func countItems() -> Int {
        return menu.count
    }
    
    //Синхрон ценыв юд после обновления
    func synchronizeBasket() {
        UserDefaults.standard.set(basketPrice, forKey: keyPrice)
        UserDefaults.standard.synchronize()
    }
}
