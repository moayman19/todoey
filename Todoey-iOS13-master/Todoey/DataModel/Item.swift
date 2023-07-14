//
//  Item.swift
//  Todoey
//
//  Created by MohammedAyman on 5/25/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var date:Date?
    var parentCategory = LinkingObjects(fromType:Category.self ,property: "items")
    
    
}
