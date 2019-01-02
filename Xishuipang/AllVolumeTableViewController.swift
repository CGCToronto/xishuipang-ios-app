//
//  AllVolumeTableViewController.swift
//  Xishuipang
//
//  Created by Xiangyu Luo on 2018-12-09.
//  Copyright © 2018 Chinese Gospel Church. All rights reserved.
//

import UIKit
import os.log

class AllVolumeTableViewController: UITableViewController {

    var volumes = [Volume]()
    var delegate : AllVolumeTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        initializeVolumeList()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return volumes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VolumeCell", for: indexPath)

        // Configure the cell...table
        cell.textLabel?.text = "第\(volumes[indexPath.row].volumeNumber)期"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let cell = tableView.cellForRow(at: indexPath)
        let newVolume = Volume()
        newVolume.volumeTheme = "blah blah blah"
        self.delegate?.allVolumeTableViewControllerWillDismiss(volume: newVolume)
        navigationController?.popViewController(animated: true)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        os_log("Preparing", log: .default, type: .debug)
    }
    
    
    // MARK: private methods
    private func initializeVolumeList() {
        for i in 1...57 {
            let newVolume = Volume()
            newVolume.volumeNumber = i
            volumes.append(newVolume)
        }
    }
}
