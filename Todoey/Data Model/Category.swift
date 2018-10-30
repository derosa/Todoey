//
//  Category.swift
//  Todoey
//
//  Created by David Erosa on 30/10/18.
//  Copyright © 2018 David Erosa. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
}
