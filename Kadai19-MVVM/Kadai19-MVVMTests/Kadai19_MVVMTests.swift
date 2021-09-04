//
//  Kadai19_MVVMTests.swift
//  Kadai19-MVVMTests
//
//  Created by 今村京平 on 2021/09/03.
//

import XCTest

@testable import Kadai19_MVVM

class Kadai19_MVVMTests: XCTestCase {
    
    func test_didTapSaveBarButtonした時にcellが追加されること() {
        let navigationController =
            UIStoryboard(name: "Main", bundle: nil)
            .instantiateInitialViewController()
            as! UINavigationController
        let listViewController =
            navigationController.topViewController
            as! ListViewController
        listViewController.loadViewIfNeeded()
        let itemTableView =
            listViewController.view.subviews
            .first(where: { $0.restorationIdentifier == "ItemTableView"})
            as! UITableView
        let item追加前のrowの数 = itemTableView.numberOfRows(inSection: 0)
        let addBarButtonAction =
            listViewController.navigationItem.rightBarButtonItem?.action
        
        // 画面遷移
        let expPresentInputVC = expectation(description: "画面遷移が終わるまで待つ")
        DispatchQueue.main.async {
            listViewController.perform(addBarButtonAction)
            expPresentInputVC.fulfill()
        }
        wait(for: [expPresentInputVC], timeout: 2)
        
        let inputViewController = InputViewController.instantiate(mode: .add)
        let nameTextField =
            inputViewController.view.subviews
            .first(where: { $0.restorationIdentifier == "NameTextField"})
            as! UITextField
        nameTextField.text = "GitHub"
        let saveBarButtonAction =
            inputViewController.navigationItem.rightBarButtonItem?.action
        
        // 画面遷移
        let expDismissInputVC = expectation(description: "画面遷移が終わるまで待つ")
        DispatchQueue.main.async {
            inputViewController.perform(saveBarButtonAction)
            expDismissInputVC.fulfill()
        }
        wait(for: [expDismissInputVC], timeout: 2)
        
        let item追加後のrowの数 =
            itemTableView.numberOfRows(inSection: 0)
        
        XCTAssertEqual(
            item追加後のrowの数,
            item追加前のrowの数 + 1,
            "didTapSaveBarButtonした時にcellが追加されること"
        )
    }
}
