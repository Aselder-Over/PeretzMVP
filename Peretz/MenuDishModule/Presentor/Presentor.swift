//
//  Presenor.swift
//  Peretz
//
//  Created by Асельдер on 24.08.2020.
//  Copyright © 2020 Асельдер. All rights reserved.
//

import Foundation
import Alamofire

protocol MenuPresenterProtocol {
    var itemsArray: [DishModel]? {get set}
    
    func getMenuItems()
    
    init(view: MenuViewProtocol)
}

class MenuPresenter: MenuPresenterProtocol {
    
    // MARK: - init
    
    required init (view: MenuViewProtocol) {
        self.view = view
        getMenuItems()
    }
    
    // MARK: - getDish
    
    var view: MenuViewProtocol?
    
    var itemsArray: [DishModel]?
    
    func getMenuItems() {
        AF.request("https://peretz-group.ru/api/v2/products?category=93&key=47be9031474183ea92958d5e255d888e47bdad44afd5d7b7201d0eb572be5278").responseData { response in
            switch response.result {
            case .success(let resultJSON):
                let resultArray = try? JSONDecoder().decode([DishModel].self, from: resultJSON)
                print(resultArray ?? "resultArray = nil")
                self.itemsArray = resultArray
                self.view?.setDish(items: self.itemsArray ?? [])
                
                self.view?.hideLoading()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
