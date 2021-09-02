//
//  ListViewModel.swift
//  Kadai19-MVVM
//
//  Created by 今村京平 on 2021/09/02.
//

import RxSwift
import RxCocoa

protocol ListViewModelInput {
    func loadItems()
    func didTapAddButton()
    func didSelectRow(index: Int)
    func didTapAccessoryButton(index: Int)
    func didDeleteCell(index: Int)
}

protocol ListViewModelOutput {
    var itemsObservable: Observable<[Item]> { get }
    var event: Driver<ListViewModel.Event> { get }
}

protocol ListViewModelType {
    var inputs: ListViewModelInput { get }
    var outputs: ListViewModelOutput { get }
}

final class ListViewModel: ListViewModelInput, ListViewModelOutput {
    enum Event {
        case presentAdd
        case presentEdit(Int)
    }

    private let itemRepository = ItemRepository()
    private let model: ItemsListModel = ModelLocator.shared.model // modelを共有
    private let disposeBag = DisposeBag()
    private let itemsRelay = PublishRelay<[Item]>()
    private let eventRelay = PublishRelay<Event>()

    init() {
        setupBinding()
    }

    private func setupBinding() {
        model.itemsObservable
            .skip(1) // 初期値が流れるため一回スキップ
            .subscribe(onNext: { [weak self] items in
                guard let self = self else { return }
                self.itemRepository.saveData(items: items) // 保存
                self.itemsRelay.accept(items)
            })
            .disposed(by: disposeBag)
    }

    var itemsObservable: Observable<[Item]> {
        itemsRelay.asObservable()
    }

    var event: Driver<Event> {
        eventRelay.asDriver(onErrorDriveWith: .empty())
    }

    func loadItems() {
        guard let items = itemRepository.loadData() else { return } // 読み込み
        model.loadItems(items: items)
    }

    func didTapAddButton() {
        eventRelay.accept(.presentAdd)
    }

    func didSelectRow(index: Int) {
        model.toggle(index: index)
    }

    func didTapAccessoryButton(index: Int) {
        eventRelay.accept(.presentEdit(index))
    }

    func didDeleteCell(index: Int) {
        model.deleteItem(index: index)
    }
}

// MARK: - ListViewModelType
extension ListViewModel: ListViewModelType {
    var inputs: ListViewModelInput {
        return self
    }

    var outputs: ListViewModelOutput {
        return self
    }
}
