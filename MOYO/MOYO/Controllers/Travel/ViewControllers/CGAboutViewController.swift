//
//  CGAboutViewController.swift
//  CityGuide
//
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit
import AVFoundation

class CGAboutViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, XMLParserDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var fullScreanImageView: UIImageView!
    
    var currentElement:String = ""
    var parser = XMLParser()
    
    var images = [String]()
    var cityInfoText = ""
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parseXML()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        if let layout = collectionView?.collectionViewLayout as? AboutVCLayout {
            layout.delegate = self
            layout.cityInfoText = self.cityInfoText
        }
        
        let higeImage = UITapGestureRecognizer(target: self, action: #selector(CGAboutViewController.hideImage(_:)))
        self.fullScreanImageView.addGestureRecognizer(higeImage)
        
        self.setUpTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //self.setUpBackGroundImage()
    }

    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        
        return images.count
    }

    func collectionView(_ cellForItemAtcollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textCell", for: indexPath) as! CGAboutTextCollectionViewCell
            cell.cityInfoLabel.text = cityInfoText
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! CGAboutImageCollectionViewCell
       // cell.imageView.image = UIImage(named: "\(images[indexPath.row])")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            UIView.animate(withDuration: 0.5, animations: {
                self.fullScreanImageView.image = UIImage(named: "\(self.images[indexPath.row])")
                self.fullScreanImageView.alpha = 1
                }, completion: { finished in
            })
        }
    }
    
    @objc func hideImage(_ sender:UITapGestureRecognizer){
        
        UIView.animate(withDuration: 0.5, animations: {
            self.fullScreanImageView.alpha = 0
            }, completion: { finished in
        })
    }
    
    func parseXML() -> Void {
        if let urlpath = Bundle.main.path(forResource: "about", ofType: "xml") {
            let url = URL(fileURLWithPath: urlpath)
            parser = XMLParser(contentsOf: url)!
            parser.delegate = self
            parser.parse()
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {

        currentElement = elementName;
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

        currentElement="";
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if currentElement == "path" {
            images.append(string)
        } else if (currentElement == "content") {
            cityInfoText = string
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
    }
    
    func setUpTitle() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
        label.numberOfLines = 0
        label.text = String(format: "%@\n%@", NSLocalizedString("CityCountryKey", comment: "About vc title"), NSLocalizedString("AboutKey", comment: "About vc title"))
        self.navigationItem.titleView = label
    }
    
    func setUpBackGroundImage() -> Void {
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named:"bg_about")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
    }
}

extension CGAboutViewController : AboutVCLayoutDelegate {

    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        
        if (indexPath as NSIndexPath).section == 0 {
            return 0
        }
    
        let photo = UIImage(named: "\(images[(indexPath as NSIndexPath).row])")
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect  = AVMakeRect(aspectRatio: photo!.size, insideRect: boundingRect)
        return rect.size.height
        
    }
}
