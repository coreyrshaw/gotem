//
//  SwipeMoodViewController.swift
//  MOYO
//
//  Created by Whitney H on 9/5/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit

class SwipeMoodViewController: UIViewController {
    
    let moodImages : [String] = ["icons8-angry-filled.png", "icons8-sad-filled.png", "icons8-neutral-filled.png", "icons8-happy-filled.png", "icons8-lol-filled.png"]
    var imageIndex = 0
    var userMood = String()
    
    @IBOutlet weak var moodImageView: UIImageView!
    override func viewDidLoad() {
        
        //Setting initial image.
        moodImageView.image = UIImage(named: "icons8-neutral-filled.png")
        super.viewDidLoad()
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
    }
    func changeMoodOptions() {
        if imageIndex == moodImages.count - 1 {
            imageIndex = 0
        } else {
            imageIndex += 1
        }
        moodImageView.image = UIImage(named: moodImages[imageIndex])
    }
    
    func recordMood(){
        if imageIndex == 0 {
            userMood = "Angry"
        } else if imageIndex == 1 {
            userMood = "Sad"
        } else if imageIndex == 2 {
            userMood = "Neutral"
        } else if imageIndex == 3 {
            userMood = "Happy"
        } else if imageIndex == 4 {
            userMood = "Very Happy"
        }
        let data = "userMood\n\(userMood)"
        sendFile(fileName: "SwipeMood", withString: data) { success in
            if success {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.down:
                changeMoodOptions()
            case UISwipeGestureRecognizerDirection.up:
                changeMoodOptions()
            default:
                break
            }
        }
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        //Pass userMood into your send to AWS function.
        recordMood()
        print(userMood)
    }
    
}
