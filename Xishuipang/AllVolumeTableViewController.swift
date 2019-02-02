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

    // MARK: properties
    var volumes = [Int]()
    var delegate : AllVolumeTableViewControllerDelegate?
    var selectedVolume: Int = 1
    
    // MARK: URLSession
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask : URLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let completionHandler = {() -> Void in
            self.tableView?.reloadData()
        }
        
        loadVolumeListFromServer(completionHandler: completionHandler)
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
        cell.textLabel?.text = "第\(volumes[indexPath.row])期"
        if volumes[indexPath.row] == selectedVolume {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let cell = tableView.cellForRow(at: indexPath)
        let selectedVolumeNumber = volumes[indexPath.row]
        self.delegate?.allVolumeTableViewControllerWillDismiss(volumeNumber: selectedVolumeNumber)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        os_log("Preparing", log: .default, type: .debug)
    }
    
    
    // MARK: private methods
    private func loadVolumeListFromServer(completionHandler: @escaping ()->Void) -> Bool {
        if let urlComponents = URLComponents(string: API.VolumeList.URL) {
            dataTask?.cancel()
            
            guard let url = urlComponents.url else {
                return false
            }
            
            let handler = { (data: Data?, response:URLResponse?, error:Error?) -> Void in
                if let error = error {
                    os_log("Error: %S", log: .default, type: .debug, error.localizedDescription)
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    if self.parseVolumeList(data:data) {
                        DispatchQueue.main.async {
                            completionHandler()
                        }
                    }
                }
                
                self.dataTask = nil
            }
            
            dataTask = defaultSession.dataTask(with: url, completionHandler: handler)
            dataTask?.resume()
            return true
        } else {
            return false
        }
    }
    
    private func parseVolumeList(data: Data?) -> Bool{
        do {
            guard let data = data else {
                return false
            }
            guard let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSArray else {
                throw NSError()
            }
            if let volumeList = jsonObj as? [Any] {
                for volumeNumber in volumeList {
                    if let volumeNumberStr = volumeNumber as? String, let volumeNumberNum = Int(volumeNumberStr) {
                        volumes.append(volumeNumberNum)
                    }
                }
                
                volumes = volumes.sorted(by: {$0 > $1})
            }
            
        } catch let error as NSError {
            print(error.debugDescription)
            return false
        }
        
        return true
    }
}
