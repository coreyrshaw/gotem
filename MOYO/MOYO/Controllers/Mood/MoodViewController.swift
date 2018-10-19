//
//  MoodViewController.swift
//  MOYO
//
//  Created by Corey S on 8/29/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit
import CoreLocation


class MoodViewController: UITableViewController {
    
    let items = [NSLocalizedString("Mood Swipe", comment: ""), NSLocalizedString("Mood Zoom", comment: ""), NSLocalizedString("PHQ9 Survey", comment: ""), NSLocalizedString("KCCQ", comment: "")]
    
    var icons = ["icons8-happy-filled", "icons8-test-passed", "icons8-test-passed", "icons8-test-passed"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Mood"
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoodCell", for: indexPath) as! MoodCell
        // Configure the cell...
        cell.menuImage.image = UIImage(named: icons[indexPath.row])
        cell.menuTitle.text = items[indexPath.row].uppercased()
        //cell.frame.size.height = tableView.frame.size.height / CGFloat(items.count)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.frame.size.height - topOffset()) / CGFloat(items.count)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.frame.size.height - topOffset()) / CGFloat(items.count)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "showMoodSwipe", sender: self)
        case 1:
            self.performSegue(withIdentifier: "showMoodZoom", sender: self)
        case 2:
            self.performSegue(withIdentifier: "showPHQ9", sender: self)
        case 3:
            self.performSegue(withIdentifier: "showKCCQ12", sender: self)
        default:
            break
        }
    }
    
}

