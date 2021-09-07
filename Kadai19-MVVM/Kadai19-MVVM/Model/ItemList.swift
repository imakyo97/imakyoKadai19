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
    func addItem(item: Item)
    func toggle(index: Int)
    func editName(index: Int, name: String)
    func deleteItem(index: Int)
}

final class ItemsList: ItemsListModel {

    private let itemsRelay = BehaviorRelay<[Item]>(value: [])
    private let repository: ItemRepositoryProtocol

    init(repository: ItemRepositoryProtocol) {
        self.repository = repository
        if let items = repository.loadData() {
            itemsRelay.accept(items)
        }
    }

    var itemsObservable: Observable<[Item]> {
        itemsRelay.asObservable()
    }

    func addItem(item: Item) {
        var items = itemsRelay.value
        items.append(item)
        itemsRelay.accept(items)
        repository.saveData(items: items)
    }

    func toggle(index: Int) {
        var items = itemsRelay.value
        items[index].isChecked.toggle()
        itemsRelay.accept(items)
        repository.saveData(items: items)
    }

    func editName(index: Int, name: String) {
        var items = itemsRelay.value
        items[index].name = name
        itemsRelay.accept(items)
        repository.saveData(items: items)
    }

    func deleteItem(index: Int) {
        var items = itemsRelay.value
        items.remove(at: index)
        itemsRelay.accept(items)
        repository.saveData(items: items)
    }
}
