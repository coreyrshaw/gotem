//
//  HomePageViewController.swift
//  MOYO
//
//  Created by Corey S on 7/30/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit
import CoreLocation


class HomePageViewController: UITableViewController {
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    
    let items = [NSLocalizedString("Activity", comment: ""), NSLocalizedString("Behavior", comment: ""), NSLocalizedString("Environment", comment: ""), NSLocalizedString("Food", comment: ""),
                 NSLocalizedString("Mood", comment: ""),
                 NSLocalizedString("Vitals", comment: "")]
    
    var icons = ["activity2", "social2", "travel2", "food2", "mood2", "bloodpressure2"]
    
    let contents = [NSLocalizedString("Track and measure your daily step data.", comment: ""), NSLocalizedString("Track and measure your social interaction.", comment: ""),
                    NSLocalizedString("Find out what's going on around you.", comment: ""), NSLocalizedString("Upload and track what you're eating.", comment: ""), NSLocalizedString("Take survey to determine your mood.", comment: ""), NSLocalizedString("Upload and track your vital signs.", comment: "")]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutAction))
        // nav bar border
        if let navBar = self.navigationController?.navigationBar {
            let border = CALayer()
            border.backgroundColor = UIColor.black.cgColor
            border.frame = CGRect(x:0, y: navBar.frame.height - 0.5, width:navBar.frame.width, height: 0.5)
            navBar.layer.addSublayer(border)
        }
    }
    @objc func logoutAction() {
        AppDelegate.appDelegate?.logout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomePageCell", for: indexPath) as! HomePageCell
        // Configure the cell...
        cell.menuImage.image = UIImage(named: icons[indexPath.row])
        cell.menuTitle.text = items[indexPath.row].uppercased()
        cell.menuContent.text = contents[indexPath.row]
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
            self.performSegue(withIdentifier: "showActivity", sender: self)
        case 2:
            self.performSegue(withIdentifier: "showTravel", sender: self)
        case 3:
            self.performSegue(withIdentifier: "showFoodDiary", sender: self)
        case 4:
            self.performSegue(withIdentifier: "showMood", sender: self)
        case 5:
            self.performSegue(withIdentifier: "showBloodPressure", sender: self)
        default:
            break
        }
    }
    
    //    func transitionToGeolocation() {
    //        let tableViewVC = self.storyboard?.instantiateViewController(withIdentifier: "tableViewVC") as! GeolocationTableViewController
    //        self.present(tableViewVC, animated: false, completion: nil)
    //    }
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
