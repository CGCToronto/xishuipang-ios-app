//
//  CharacterVersionTableViewController.swift
//  Xishuipang
//
//  Created by Xiangyu Luo on 2019-01-28.
//  Copyright © 2019 Chinese Gospel Church. All rights reserved.
//

import UIKit

class CharacterVersionTableViewController: UITableViewController {

    var settings : Settings?
    
    @IBOutlet weak var simplifiedCell: UITableViewCell!
    @IBOutlet weak var traditionalCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSelection()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        simplifiedCell.accessoryType = .none
        traditionalCell.accessoryType = .none
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        if let settingsInstance = settings {
            if cell == simplifiedCell {
                settingsInstance.characterVersion = .simplified
            } else if cell == traditionalCell {
                settingsInstance.characterVersion = .traditional
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Operations
    private func updateSelection() {
        if let settingsInstance = settings{
            if settingsInstance.characterVersion == .simplified {
                simplifiedCell.accessoryType = .checkmark
            } else if settingsInstance.characterVersion == .traditional {
                traditionalCell.accessoryType = .checkmark
            }
        }
    }

}
