//
//  Model_Test.swift
//  Kadai19-MVVMTests
//
<<<<<<< HEAD
//  Created by 今村京平 on 2021/11/30.
=======
//  Created by kyoheiimamura on 2021/11/30.
>>>>>>> 2542b5279960c2ca29e89d9f78e96e819aca4863
//

import XCTest
import RxSwift

@testable import Kadai19_MVVM

class Model_Test: XCTestCase {
    func testAddItem() {
        let itemsList = ItemsList(repository: DummyItemRepository())
        let item = Item(isChecked: false, name: "スイカ")
        var addItem: Item?
        itemsList.addItem(item: item)
        itemsList.itemsObservable
            .subscribe(onNext: { items in
                addItem = items.last
            })
            .disposed(by: DisposeBag())
        XCTAssertTrue(addItem == item)
    }
}

private class DummyItemRepository: ItemRepositoryProtocol {
    func loadData() -> [Item]? {
        return nil
    }

    func saveData(items: [Item]) {
    }
}
