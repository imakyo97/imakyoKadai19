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
    
    func testAddBarButtonPressedWhenCellAdded() {
        let numberOfRowsBeforeAddition = itemTableView.numberOfRows(inSection: 0)
        let addBarButtonAction =
            listViewController.navigationItem.rightBarButtonItem?.action
        
        // 画面遷移
        let expPresentInputVC = expectation(description: "画面遷移が終わるまで待つ")
        DispatchQueue.main.async {
            self.listViewController.perform(addBarButtonAction)
            expPresentInputVC.fulfill()
        }
        wait(for: [expPresentInputVC], timeout: 2)
        
        let inputViewController = InputViewController.instantiate(mode: .add)
        inputViewController.loadViewIfNeeded()
        let nameTextField =
            inputViewController.view.subviews
            .first(where: { $0.restorationIdentifier == "NameTextField"})
            as! UITextField
        nameTextField.text = "Test-Item-Test"
        let saveBarButtonAction =
            inputViewController.navigationItem.rightBarButtonItem?.action
        
        // 画面遷移
        let expDismissInputVC = expectation(description: "画面遷移が終わるまで待つ")
        DispatchQueue.main.async {
            inputViewController.perform(saveBarButtonAction)
            expDismissInputVC.fulfill()
        }
        wait(for: [expDismissInputVC], timeout: 2)
        
        let numberOfRowsAfterAddition =
            itemTableView.numberOfRows(inSection: 0)
        
        XCTAssertEqual(
            numberOfRowsAfterAddition,
            numberOfRowsBeforeAddition + 1,
            "didTapSaveBarButtonした時にcellが追加されること"
        )
    }
}
