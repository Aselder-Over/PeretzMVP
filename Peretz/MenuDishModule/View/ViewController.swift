//
//  ViewController.swift
//  Peretz
//
//  Created by Асельдер on 20.08.2020.
//  Copyright © 2020 Асельдер. All rights reserved.
//

import UIKit

//Протокол

protocol MenuViewProtocol {
    func setDish(items: [DishModel])
    
    func showLoading()
    func hideLoading()
}

// класс код
class ViewController: UIViewController, BasketViewPresentable {
    
    var isBasketVisible = false
    
    var menuPresenter: MenuPresenterProtocol?
    
    //MARK: BasketMethod
    
    //тип делегат опен баскета 
    func openBasket() { }
    
    var basketView: BasketViewPresentable?
    
    //get dish menu
    var menuDish: [DishModel] = [] {
        didSet {
            tableViewDish.reloadData()
        }
    }
    
    var dishItem: DishModel?
    
    // Оутлеты
    @IBOutlet weak var tableViewDish: UITableView!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observer.shared.observe(self, selector: #selector(showBasketViewEvent), key: DishUserDefaults.shared.showBasketEvent)
        Observer.shared.observe(self, selector: #selector(hideBasketViewEvent), key: DishUserDefaults.shared.hideBasketEvent)
                
        //Config navigation bar
        let yourBackImage = #imageLiteral(resourceName: "Vector")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.topItem?.title = " "
        
        menuPresenter = MenuPresenter(view: self)
        
        // Нижний отступ таблицы
        tableViewDish.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 52, right: 0)
        
        tableViewDish.dataSource = self
        tableViewDish.delegate = self
        
    }
    
    // Ремув обсерверов
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Observer.shared.removeObserver(self)
        hideBasketView()
    }
    
    //MARK: - Basket method
    
    @objc func showBasketViewEvent() {
        showBasketView()
    }
    
    @objc func hideBasketViewEvent() {
        hideBasketView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Basket on scene
        if DishUserDefaults.shared.showBasket() {
            showBasketView()
        }
    }
}


//MARK: - TableView Configuration

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuDish.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuCell = tableViewDish.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! TableViewCell
        
        menuCell.setData(dishItem: menuDish[indexPath.row])
        menuCell.selectionStyle = .none
        
        return menuCell
    }
}

// MARK: - Protocol

extension ViewController: MenuViewProtocol {
    
    func showLoading() {
        myActivityIndicator.startAnimating()
        myActivityIndicator.isHidden = false
    }
    
    func hideLoading() {
        myActivityIndicator.stopAnimating()
        myActivityIndicator.isHidden = true
    }
    
    func setDish(items: [DishModel]) {
        menuDish.append(contentsOf: items)
        print("\(menuDish) append")
    }
}
