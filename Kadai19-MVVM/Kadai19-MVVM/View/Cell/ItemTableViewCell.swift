//
//  ItemTableViewCell.swift
//  Kadai19-MVVM
//
//  Created by 今村京平 on 2021/09/02.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: ItemTableViewCell.identifier, bundle: nil) }

    @IBOutlet private weak var checkMarkImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    func configure(item: Item) {
        checkMarkImageView.image = item.isChecked ? UIImage(named: "CheckMark") : nil
        nameLabel.text = item.name
    }
}
