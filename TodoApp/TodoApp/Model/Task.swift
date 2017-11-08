//
//  Task.swift
//  TodoApp
//
//  Created by Best Peers on 07/11/17.
//  Copyright © 2017 Best Peers. All rights reserved.
//

import UIKit
import RealmSwift

final class Task: Object {
    @objc dynamic var title = ""
    @objc dynamic var completed = false
    @objc dynamic var priority = 2
    @objc dynamic var startDate = Date.init()
}
