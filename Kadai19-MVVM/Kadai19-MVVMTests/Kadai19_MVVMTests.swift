//
//  Kadai19_MVVMTests.swift
//  Kadai19-MVVMTests
//
//  Created by 今村京平 on 2021/09/03.
//

import XCTest

@testable import Kadai19_MVVM

class Kadai19_MVVMTests: XCTestCase {

    private var listViewController: ListViewController!
    private var itemTableView: UITableView!

    override func setUp() {
        let navigationController =
            UIStoryboard(name: "Main", bundle: nil)
            .instantiateInitialViewController()
            as! UINavigationController
        listViewController =
            navigationController.topViewController
            as? ListViewController
        listViewController.loadViewIfNeeded()

        itemTableView =
            listViewController.view.subviews
            .first(where: { $0.restorationIdentifier == "ItemTableView"})
            as? UITableView
    }

    override func tearDown() {
        listViewController = nil
        itemTableView = nil
    }
    
    func testSaveBarButtonPressedWhenCellAdded() {
        let numberOfRowsBeforeAddition = itemTableView.numberOfRows(inSection: 0)

        // 画面遷移
        didTapAddBarButton()
        
        let inputViewController = InputViewController.instantiate(mode: .add)
        inputViewController.loadViewIfNeeded()
        let nameTextField = fetchNameTextField(from: inputViewController)
        nameTextField.text = "Test-Item-Test"
        
        // 画面遷移
        didTapSaveBarButton(from: inputViewController)
        
        let numberOfRowsAfterAddition =
            itemTableView.numberOfRows(inSection: 0)
        
        XCTAssertEqual(
            numberOfRowsAfterAddition,
            numberOfRowsBeforeAddition + 1,
            "didTapSaveBarButtonした時にcellが追加されること"
        )
    }

    private func didTapAddBarButton() {
        let addBarButtonAction =
            listViewController.navigationItem.rightBarButtonItem?.action
        let expPresentInputVC = expectation(description: "画面遷移が終わるまで待つ")
        DispatchQueue.main.async {
            self.listViewController.perform(addBarButtonAction)
            expPresentInputVC.fulfill()
        }
        wait(for: [expPresentInputVC], timeout: 2)
    }

    private func didTapSaveBarButton(from vc: InputViewController) {
        let saveBarButtonAction =
            vc.navigationItem.rightBarButtonItem?.action
        let expDismissInputVC = expectation(description: "画面遷移が終わるまで待つ")
        DispatchQueue.main.async {
            vc.perform(saveBarButtonAction)
            expDismissInputVC.fulfill()
        }
        wait(for: [expDismissInputVC], timeout: 2)
    }

    private func fetchNameTextField(from vc: InputViewController) -> UITextField {
        vc.view.subviews
            .first(where: { $0.restorationIdentifier == "NameTextField"})
            as! UITextField
    }
}
