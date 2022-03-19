//
//  Category.swift
//  Todoey
//
//  Created by Bruno Guirra on 18/03/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted var name: String = ""
} 
