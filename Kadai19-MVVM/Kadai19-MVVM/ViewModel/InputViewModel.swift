//
//  InputViewModel.swift
//  Kadai19-MVVM
//
//  Created by 今村京平 on 2021/09/02.
//

import RxSwift
import RxCocoa

protocol InputViewModelInput {
    func didTapCancelButton()
    func didTapSaveButton(nameText: String)
    func editingName(index: Int)
}

protocol InputViewModelOutput {
    var event: Driver<InputViewModel.Event> { get }
    var name: Driver<String?> { get }
    var mode: InputViewModel.Mode { get }
}

protocol InputViewModelType {
    var inputs: InputViewModelInput { get }
    var outputs: InputViewModelOutput { get }
}

final class InputViewModel: InputViewModelInput, InputViewModelOutput {
    enum Mode {
        case add
        case edit(Int)
    }

    enum Event {
        case dismiss
    }

    private let model: ItemsListModel = ModelLocator.shared.model // modelを共有
    private let eventRelay = PublishRelay<Event>()
    private let disposeBag = DisposeBag()
    private var items: [Item] = []

    private let nameRelay = BehaviorRelay<String?>(value: "")
    var name: Driver<String?> {
        nameRelay.asDriver()
    }

    let mode: Mode

    init(mode: Mode) {
        self.mode = mode
        setupBinding()
    }

    private func setupBinding() {
        model.itemsObservable
            .subscribe(onNext: { [weak self] items in
                self?.items = items
            })
            .disposed(by: disposeBag)
    }

    var event: Driver<Event> {
        return eventRelay.asDriver(onErrorDriveWith: .empty())
    }

    func didTapCancelButton() {
        eventRelay.accept(.dismiss)
    }

    func didTapSaveButton(nameText: String) {
        switch mode {
        case .add:
            let item = Item(isChecked: false, name: nameText)
            model.addItem(item: item)
        case .edit(let index):
            model.editName(index: index, name: nameText)
        }
        eventRelay.accept(.dismiss)
    }

    func editingName(index: Int) {
        let name = items[index].name
        nameRelay.accept(name)
    }
}

// MARK: - InputViewModelType
extension InputViewModel: InputViewModelType {
    var inputs: InputViewModelInput {
        return self
    }

    var outputs: InputViewModelOutput {
        return self
    }
}
