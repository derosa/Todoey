//
//  Data.swift
//  Todoey
//
//  Created by David Erosa on 29/10/18.
//  Copyright © 2018 David Erosa. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
