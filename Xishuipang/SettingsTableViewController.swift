//
//  SettingsTableViewController.swift
//  Xishuipang
//
//  Created by Xiangyu Luo on 2019-01-28.
//  Copyright © 2019 Chinese Gospel Church. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    // MARK: outlets
    @IBOutlet weak var characterVersionLabel: UILabel!
    @IBOutlet weak var fontSizeLabel: UILabel!
    
    // MARK: properties
    var settings: Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCharacterVersion" {
            guard let characterVersionTableViewController = segue.destination as? CharacterVersionTableViewController else {
                fatalError("Destination of ShowCharacterVersion segue must be CharacterVersionTableViewController.")
            }
            characterVersionTableViewController.settings = settings
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if settings?.characterVersion == .simplified {
            characterVersionLabel.text = "简体"
        } else if settings?.characterVersion == .traditional {
            characterVersionLabel.text = "繁體"
        }
    }
    

}
