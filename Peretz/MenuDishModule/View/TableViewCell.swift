//
//  TableViewCell.swift
//  Peretz
//
//  Created by Асельдер on 24.08.2020.
//  Copyright © 2020 Асельдер. All rights reserved.
//

import UIKit
import SDWebImage

//MARK: - Protocol delegate
protocol BasketDelegate {
    func getPrice(dishItem: DishModel) -> Int
    func minusButtonAction(_ sender: Any)
    func plusButtonAction(_ sender: Any)
    var allBasketPrice: Int { get set }
}

//MARK: - Class code
class TableViewCell: UITableViewCell {
    
    //Outlet
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishDescriptionLabel: UILabel!
    @IBOutlet weak var priceDishLabel: UILabel!
    @IBOutlet weak var countDishLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var dishImage: UIImageView!
    
    private var currentItem: DishModel?
    
    func setData(dishItem: DishModel) {
        
        //Проверка
        if DishUserDefaults.shared.checkCount(productId: dishItem.id) >= 1 {
            countDishLabel.isHidden = false
            minusButton.isHidden = false
            countDishLabel.text = String(DishUserDefaults.shared.checkCount(productId: dishItem.id))
        } else {
            countDishLabel.isHidden = true
            minusButton.isHidden = true
        }
        
        //собираем объекты
        currentItem = dishItem
        
        //спарсинговые объекты передаем в подготовленные на вью их места
        if let image = dishItem.image {
            dishImage.sd_setImage(with: URL(string: image), completed: nil)
        }
        dishNameLabel.text = dishItem.name.capitalized
        dishDescriptionLabel.text = dishItem.description.capitalized
        priceDishLabel.text = String(dishItem.price ) + " ₽"

    }
    
//MARK: - Method
    
    @IBAction func minusButtonAction(_ sender: Any) {
        
        // Изменение basketPrice
        DishUserDefaults.shared.basketPrice -= currentItem?.price ?? 0

        if (Int(countDishLabel.text ?? "0")! >= 2) {
            DishUserDefaults.shared.removeCount(productId: currentItem!.id)
            countDishLabel.text = String(DishUserDefaults.shared.checkCount(productId: currentItem!.id))
            
        } else if (Int(countDishLabel.text ?? "0")! <= 1) {
    
            DishUserDefaults.shared.removeCount(productId: currentItem!.id)
            minusButton.isHidden = true
            countDishLabel.isHidden = true
        }
        // Синхронизируем изменения в баскет прайс
        DishUserDefaults.shared.synchronizeBasket()
    }
    
    @IBAction func plusButtonAction(_ sender: Any) {
        
        DishUserDefaults.shared.basketPrice += currentItem?.price ?? 0
        DishUserDefaults.shared.plusCount(productId: currentItem!.id)
        countDishLabel.text = String(DishUserDefaults.shared.checkCount(productId: currentItem!.id))
        
        if Int(countDishLabel.text ?? "0")! >= 1 {
            countDishLabel.isHidden = false
            minusButton.isHidden = false
        }
        DishUserDefaults.shared.synchronizeBasket()
    }
}

