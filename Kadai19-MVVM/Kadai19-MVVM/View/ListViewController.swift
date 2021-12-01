//
//  ListViewController.swift
//  Kadai19-MVVM
//
//  Created by 今村京平 on 2021/09/02.
//

import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {

    @IBOutlet private weak var itemTableView: UITableView!
    @IBOutlet private weak var addBarButton: UIBarButtonItem!

    private let viewModel: ListViewModelType = ListViewModel()
    private let disposeBag = DisposeBag()
    private let dataSource = ItemDataSource()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        setupBinding()
        setupTableView()
        setupAddBarButton()
        print("\(#function): viewDidLoad----------")
    }

    private func setupBinding() {
        viewModel.outputs.itemsObservable
            .bind(to: itemTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        viewModel.outputs.event
            .drive(onNext: { [weak self] event in
                let inputViewController = InputViewController.instantiate(
                    mode: InputViewModel.Mode(event: event)
                )
                let navigationController = UINavigationController(rootViewController: inputViewController)
                self?.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }

    // テストコードを書くためにaddBarButton.actionで実装
    private func setupAddBarButton() {
        addBarButton.action = #selector(didTapAddBarButton)
        addBarButton.target = self
    }

    @objc private func didTapAddBarButton() {
        viewModel.inputs.didTapAddButton()
    }

    private func setupTableView() {
        itemTableView.register(
            ItemTableViewCell.nib,
            forCellReuseIdentifier: ItemTableViewCell.identifier
        )
        itemTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.inputs.didSelectRow(index: indexPath.row)
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        viewModel.inputs.didTapAccessoryButton(index: indexPath.row)
    }
}

// MARK: - ItemDataSourceDelegate
// 自作delegate
extension ListViewController: ItemDataSourceDelegate {

    // cellの削除を通知するメソッド
    func didDeleteCell(indexRow: Int) {
        viewModel.inputs.didDeleteCell(index: indexRow)
    }
}

// enumをイニシャライザを実装できる
// MARK: - InputViewModel.Modeのイニシャライザ拡張(enumのinit())
private extension InputViewModel.Mode {
    init(event: ListViewModel.Event) {
        switch event {
        case .presentAdd:
            self = .add
        case .presentEdit(let index):
            self = .edit(index)
        }
    }
}
