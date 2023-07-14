//
//  Category.swift
//  Todoey
//
//  Created by MohammedAyman on 5/25/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name:String = ""
    @objc dynamic var hexColor:String = ""
    let items = List<Item>()
    
}
