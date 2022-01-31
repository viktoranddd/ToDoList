//
//  Model.swift
//  ToDoList
//
//  Created by Viktor Andreev on 27.10.2021.
//

import Foundation
import UserNotifications
import UIKit

var ToDoItems: [[String: Any]] {
    set {
        UserDefaults.standard.set(newValue, forKey: "ToDoDataKey")
        UserDefaults.standard.synchronize()
    }
    
    get {
        if let array = UserDefaults.standard.array(forKey: "ToDoDataKey") as? [[String: Any]] {
            return array
        } else {
            return []
        }
    }
}

func addItem(nameItem: String, isCompleted: Bool = false) {
    ToDoItems.append(["Name": nameItem, "isCompleted": isCompleted])
    setBadge()
}

func removeItem(at index: Int) {
    ToDoItems.remove(at: index)
    setBadge()
}

func moveItem(from: Int, to: Int) {
    let fromData = ToDoItems[from]
    ToDoItems.remove(at: from)
    ToDoItems.insert(fromData, at: to)
}

func changeState(at item: Int) -> Bool {
    ToDoItems[item]["isCompleted"] = !(ToDoItems[item]["isCompleted"] as! Bool)
    setBadge()
    return ToDoItems[item]["isCompleted"] as! Bool
}

func requestForNotifications() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) { isEnabled, error in
        if isEnabled {
            print("Согласие получено")
        } else {
            print("Пришёл отказ")
        }
    }
}

func setBadge() {
    var totalBadgeNumber = 0
    for item in ToDoItems {
        if item["isCompleted"] as? Bool == false {
            totalBadgeNumber += 1
        }
    }
    
    UIApplication.shared.applicationIconBadgeNumber = totalBadgeNumber
}
