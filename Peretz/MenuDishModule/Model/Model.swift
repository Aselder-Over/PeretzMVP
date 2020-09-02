//
//  Model.swift
//  Peretz
//
//  Created by Асельдер on 24.08.2020.
//  Copyright © 2020 Асельдер. All rights reserved.
//

import Foundation

struct DishModel: Codable {
    var id: Int
    var name: String
    var description: String
    var new: Bool
    var price: Int
    var image: String?
}
