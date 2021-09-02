//
//  ItemList.swift
//  Kadai19-MVVM
//
//  Created by 今村京平 on 2021/09/02.
//

import RxSwift
import RxRelay

protocol ItemsListModel {
    var itemsObservable: Observable<[Item]> { get }
    func loadItems(items: [Item])
    func addItem(item: Item)
    func toggle(index: Int)
    func editName(index: Int, name: String)
    func deleteItem(index: Int)
}

final class ItemsList: ItemsListModel {

    private lazy var itemsRelay = BehaviorRelay<[Item]>(value: [])

    var itemsObservable: Observable<[Item]> {
        itemsRelay.asObservable()
    }

    func loadItems(items: [Item]) {
        itemsRelay.accept(items)
    }

    func addItem(item: Item) {
        var items = itemsRelay.value
        items.append(item)
        itemsRelay.accept(items)
    }

    func toggle(index: Int) {
        var items = itemsRelay.value
        items[index].isChecked.toggle()
        itemsRelay.accept(items)
    }

    func editName(index: Int, name: String) {
        var items = itemsRelay.value
        items[index].name = name
        itemsRelay.accept(items)
    }

    func deleteItem(index: Int) {
        var items = itemsRelay.value
        items.remove(at: index)
        itemsRelay.accept(items)
    }
}
