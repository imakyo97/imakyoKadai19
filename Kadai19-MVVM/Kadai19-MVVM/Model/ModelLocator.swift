//
//  ModelLocator.swift
//  Kadai19-MVVM
//
//  Created by 今村京平 on 2021/09/02.
//

import Foundation

// modelを共有するための構造体
struct ModelLocator {
    static let shared = ModelLocator()
    let model = ItemsList(repository: ItemRepository())
    private init() {}
}
