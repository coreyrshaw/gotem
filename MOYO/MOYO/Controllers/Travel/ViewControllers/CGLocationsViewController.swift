//
//  CGLocationsViewController.swift
//  CityGuide
//
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit
import CoreLocation

class CGLocationsViewController: UIViewController, UITableViewDelegate, CGLocationsTableViewDataSourceDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView! = nil
    
    var locationsDataSource: CGLocationsTableViewDataSource! = nil
    var cityLocation: CLLocation! = nil
    var searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationsDataSource = CGLocationsTableViewDataSource(location: cityLocation)
        NotificationCenter.default.addObserver(self, selector: #selector(CGLocationsViewController.showEmptyState(_:)), name:NSNotification.Name(rawValue: "showEmptyState"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CGLocationsViewController.hideEmptyState(_:)), name:NSNotification.Name(rawValue: "hideEmptyState"), object: nil)
        
        if CGLocationsManager.sharedInstance.selectedLocationTypeIsFavorites() {
            self.title = NSLocalizedString("FavoritesTitleKey", comment: "favorites title")
        } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsSleep() {
            self.title = NSLocalizedString("SleepKey", comment: "sleep title")
        } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsEat() {
            self.title = NSLocalizedString("EatKey", comment: "eat title")
        } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsEnjoy() {
            self.title = NSLocalizedString("EnjoyKey", comment: "enjoy title")
        } 
        
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBarStyle.default
        searchBar.showsCancelButton = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = locationsDataSource
        self.tableView.contentInset = UIEdgeInsetsMake(0.1, 0, 0, 0)
        
        locationsDataSource.delegate = self
        
        self.addNavBarButtons()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                    
        let vc = CGLocationDetailsViewController(nibName: "CGLocationDetailsViewController", bundle: nil)
        vc.location = self.locationsDataSource.locations[(indexPath as NSIndexPath).row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {return 300}
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {return nil}
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {return 0.01}
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {return nil}
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {return 0.01}
    
    @objc func showEmptyState(_ notification: Notification){
        if CGLocationsManager.sharedInstance.selectedLocationTypeIsFavorites() {
            CGTableViewEmptyState.EmptyMessage(NSLocalizedString("NoFavoritePlacesKey", comment: "empty favorite list message"), tableView: tableView)
        } else {
            CGTableViewEmptyState.EmptyMessage(NSLocalizedString("NoLocationsFoundKey", comment: "empty list message"), tableView: tableView)
        }
    }
    
    @objc func hideEmptyState(_ notification: Notification){
        CGTableViewEmptyState.EmptyMessage("", tableView: tableView)
    }
    
    @IBAction func toggleSearchButton(_ sender: UIBarButtonItem) {
        showSearchBar()
    }
    
    func showSearchBar() {
        self.navigationItem.rightBarButtonItems = []
        searchBar.alpha = 0
        navigationItem.titleView = searchBar
        navigationItem.setLeftBarButton(nil, animated: true)
        UIView.animate(withDuration: 0.5, animations: {
            self.searchBar.alpha = 1
            }, completion: { finished in
                self.searchBar.becomeFirstResponder()
        })
    }
    
    func hideSearchBar() {
        navigationItem.titleView = nil
        self.addNavBarButtons()
    }

    @IBAction func toggleMapButton(_ sender: UIBarButtonItem) {
        let mapVC = CGMapViewController(nibName: "CGMapViewController", bundle: nil)
        if CGLocationsManager.sharedInstance.selectedLocationTypeIsSleep() {
            mapVC.sleepLocations = self.locationsDataSource.locations
        } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsEat() {
            mapVC.eatLocations = self.locationsDataSource.locations
        } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsEnjoy() {
            mapVC.enjoyLocations = self.locationsDataSource.locations
        } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsFavorites() {
            mapVC.favoriteLocations = self.locationsDataSource.locations
        }
        self.navigationController?.pushViewController(mapVC, animated: true)
    }

    @IBAction func toggleMoreButton(_ sender: UIBarButtonItem) {
        
    }
    
    func didFinishLoading(_ sender: CGLocationsTableViewDataSource) {
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            if searchText.count > 2 {
                locationsDataSource.loadLocationForKeyWord(searchText)
                searchBar.resignFirstResponder()
                hideSearchBar()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func addNavBarButtons() -> Void {
        
        let searchButton: UIButton = UIButton()
        searchButton.setImage(UIImage(named: "ic_white_search"), for: .normal)
        searchButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        searchButton.addTarget(self, action: #selector(CGLocationsViewController.toggleSearchButton(_:)), for: .touchUpInside)
        
        let mapButton: UIButton = UIButton()
        mapButton.setImage(UIImage(named: "ic_white_map"), for: .normal)
        mapButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        mapButton.addTarget(self, action: #selector(CGLocationsViewController.toggleMapButton(_:)), for: .touchUpInside)
        
        if CGLocationsManager.sharedInstance.selectedLocationTypeIsFavorites() {
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: mapButton)]
        } else {
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: mapButton), UIBarButtonItem(customView: searchButton)]
        }
    }
}
