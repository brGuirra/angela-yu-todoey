//
//  Task.swift
//  Todoey
//
//  Created by Bruno Guirra on 18/03/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    @Persisted var title: String = ""
    @Persisted var done: Bool = false
}
