//
//  CGWeatherViewController.swift
//  CityGuide
//
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit

class CGWeatherViewController: UIViewController, UITableViewDelegate, CGWeatherTableViewDataSourceDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let dayliForecastsDataSource = CGWeatherTableViewDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = dayliForecastsDataSource
        self.tableView.contentInset = UIEdgeInsetsMake(0.1, 0, 0, 0)
        dayliForecastsDataSource.delegate = self
        
        self.setUpTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setUpBackGroundImage()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {return 120}
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {return nil}
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {return 0.01}
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {return nil}
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {return 0.01}
    
    func didFinishLoading(_ sender: CGWeatherTableViewDataSource) {
        self.tableView.reloadData()
    }
    
    func setUpTitle() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.white
        label.text = String(format: "%@\n%@", NSLocalizedString("CityCountryKey", comment: "Weather vc title"), NSLocalizedString("WeatherForecastKey", comment: "Weather vc title"))
        self.navigationItem.titleView = label
    }
    
    func setUpBackGroundImage() -> Void {
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named:"bg_weather")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
    }
}
