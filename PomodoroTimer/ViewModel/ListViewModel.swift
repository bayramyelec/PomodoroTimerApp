//
//  ListViewModel.swift
//  PomodoroTimer
//
//  Created by Bayram Yeleç on 8.03.2025.
//

import Foundation

final class ListViewModel {
    
    var items: [ListModel] = [ListModel(focusTime: 1500, breakTime: 60, date: Date()), ListModel(focusTime: 1500, breakTime: 60, date: Date())] {
        didSet {
            reloadData?()
        }
    }
    
    var reloadData: (() -> Void)?
    
    func addItem(focusTime: Int, breakTime: Int, date: Date) {
        let newItem = ListModel(focusTime: focusTime, breakTime: breakTime, date: date)
        items.append(newItem)
        print("Item added, new count: \(items.count)")
        reloadData?()
    }
    
    func removeItem(at index: Int) {
        guard index >= 0 && index < items.count else {
            print("error removing item")
            return
        }
        items.remove(at: index)
        reloadData?()
    }
    
}
