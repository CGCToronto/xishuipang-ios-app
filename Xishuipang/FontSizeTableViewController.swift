//
//  FontSizeTableViewController.swift
//  Xishuipang
//
//  Created by Xiangyu Luo on 2019-02-01.
//  Copyright © 2019 Chinese Gospel Church. All rights reserved.
//

import UIKit

class FontSizeTableViewController: UITableViewController {

    // MARK: outlets
    @IBOutlet weak var size20Cell: FontSizeTableViewCell!
    @IBOutlet weak var size25Cell: FontSizeTableViewCell!
    @IBOutlet weak var size30Cell: FontSizeTableViewCell!
    @IBOutlet weak var size35Cell: FontSizeTableViewCell!
    @IBOutlet weak var size40Cell: FontSizeTableViewCell!
    @IBOutlet weak var size50Cell: FontSizeTableViewCell!
    @IBOutlet weak var size60Cell: FontSizeTableViewCell!
    
    // MARK: Properties
    var settings: Settings?
    var cells: [FontSizeTableViewCell]?

    override func viewDidLoad() {
        super.viewDidLoad()
        cells = [FontSizeTableViewCell]()
        cells?.append(size20Cell)
        cells?.append(size25Cell)
        cells?.append(size30Cell)
        cells?.append(size35Cell)
        cells?.append(size40Cell)
        cells?.append(size50Cell)
        cells?.append(size60Cell)
        updateSelection()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FontSizeTableViewCell {
            if let settingsInstance = settings {
                settingsInstance.fontSize = cell.fontSize
            }
            
            if let tableCells = cells {
                for fontCell in tableCells {
                    fontCell.accessoryType = .none
                }
            }
            
            cell.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func updateSelection() {
        if let settingsInstance = settings {
            if let tableCells = cells {
                for cell in tableCells {
                    if cell.fontSize == settingsInstance.fontSize {
                        cell.accessoryType = .checkmark
                        break
                    }
                }
            }
        }
    }
}
