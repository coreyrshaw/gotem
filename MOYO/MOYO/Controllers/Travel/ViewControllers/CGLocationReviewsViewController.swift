//
//  CGLocationReviewsViewController.swift
//  CityGuide
//
//  Created by  Diyan Zhekov on 10/4/16.
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit
import AlamofireImage

class CGLocationReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var reviewsList = [CGLocationReview]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.title = NSLocalizedString("ReviewsScreenTitleKey", comment: "reviews screen title")
        
        self.tableView.contentInset = UIEdgeInsetsMake(0.1, 0, 0, 0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 130
        
        tableView.register(UINib(nibName: "CGLocationReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "reviewCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CGLocationReviewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! CGLocationReviewTableViewCell
        
        let review:CGLocationReview = self.reviewsList[(indexPath as NSIndexPath).row]
        
        var placeholderImage:UIImage!
        
        if CGLocationsManager.sharedInstance.selectedLocationTypeIsSleep() {
            placeholderImage = UIImage(named: "ic_sleep_ratings_user_pic")
        } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsEat() {
            placeholderImage = UIImage(named: "ic_eat_ratings_user_pic")
        } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsEnjoy() {
            placeholderImage = UIImage(named: "ic_enjoy_ratings_user_pic")
        } else if CGLocationsManager.sharedInstance.selectedLocationTypeIsFavorites() {
            placeholderImage = UIImage(named: "ic_fav_ratings_user_pic")
        }
        
        if let downloadURL = URL(string: "\(review.aurotImageURL)") {
            cell.autorImageView.af_setImage(withURL: downloadURL, placeholderImage: placeholderImage)
        }
        
        cell.autorImageView.layer.cornerRadius = cell.autorImageView.frame.size.width / 2
        cell.autorImageView.clipsToBounds = true
        
        cell.autorNameLabel.text = review.autorName
        cell.locationRatingView.locationRating = review.locationRating
        cell.reviewDateLabel.text = review.reviewDate
        cell.reviewTextLabel.text = review.reviewText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {return nil}
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {return 0.01}
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {return nil}
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {return 0.01}

}
