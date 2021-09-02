//
//  ItemRepository.swift
//  Kadai19-MVVM
//
//  Created by 今村京平 on 2021/09/02.
//

import Foundation

struct ItemRepository {

    private let itemsKey = "itemsKey"
    private let userDefaults = UserDefaults.standard

    func loadData() -> [Item]? {
        guard let data = userDefaults.data(forKey: itemsKey) else { return nil }
        return try? PropertyListDecoder().decode(Array<Item>.self, from: data)
    }

    func saveData(items: [Item]) {
        guard let data = try? PropertyListEncoder().encode(items) else { return }
        userDefaults.setValue(data, forKey: itemsKey)
    }
}
