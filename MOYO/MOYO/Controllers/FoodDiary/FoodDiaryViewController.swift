//
//  FoodDiaryViewController.swift
//  MOYO
//
//  Created by Corey S on 9/15/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit
import KRProgressHUD

class FoodDiaryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    internal let defaultOffset: CGFloat = 75
    internal let keyboardOffset: CGFloat = 160
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var fieldOffset: NSLayoutConstraint!
    var chosenImage: UIImage? = nil {
        didSet {
            enableButton()
            cameraView.image = chosenImage
        }
    }
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var enterFood: UITextField!
    let picker = UIImagePickerController()
    var observers = [Any]()
    func enableButton() {
        if chosenImage != nil, let text = enterFood.text, !text.isEmpty {
            submitButton.isEnabled = true
        }
        else {
            submitButton.isEnabled = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        enterFood.delegate = self
        cameraView.contentMode = .scaleAspectFit
        let observer1 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil) { (note) in
            self.fieldOffset.constant = self.keyboardOffset
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutSubviews()
            })
        }
        let observer2 = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil) { (note) in
            self.fieldOffset.constant = self.defaultOffset
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutSubviews()
            })
        }
        observers = [observer1,observer2]
        title = NSLocalizedString("Food", comment: "")
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapActon))
        self.view.addGestureRecognizer(tap)
    }
    deinit {
        observers.forEach{NotificationCenter.default.removeObserver($0)}
    }
    @objc func tapActon() {
        self.view.endEditing(true)
    }
    
    @IBAction func photoFromLibrary(_ sender: UIButton) {
        self.view.endEditing(true)
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func shootPhoto(_ sender: UIButton) {
        self.view.endEditing(true)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: false, completion: nil)
            
        } else {
            noCamera()
        }
        
    }
    @IBAction func takeAction(_ sender: Any) {
        let av = UIAlertController(title: NSLocalizedString("Take Photo", comment: ""),
                                   message: nil,
                                   preferredStyle: .actionSheet)
        let photo = UIAlertAction(title: NSLocalizedString("Camera", comment: ""),
                                  style: .default) { (act) in
                                    self.shootPhoto(UIButton())
        }
        let lib = UIAlertAction(title: NSLocalizedString("Photo from Gallery", comment: ""),
                                style: .default) { (act) in
                                    self.photoFromLibrary(UIButton())
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                   style: .cancel,
                                   handler: nil)
        av.addAction(photo)
        av.addAction(lib)
        av.addAction(cancel)
        self.present(av, animated: true, completion: nil)
    }
    @IBAction func submitData(_ sender: UIButton) {
        //Send picture and text?
        guard let text = enterFood.text else {
            self.showAlert(title: NSLocalizedString("Please enter your food", comment: ""), message: nil)
            return
        }
        guard let _ = self.chosenImage else {
            self.showAlert(title: NSLocalizedString("Please choose or take picture", comment: ""), message: nil)
            return
        }
        self.sendFood(food: text)
    }
    
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    //MARK: - Delegates
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage //2
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
            if !result.isEmpty && chosenImage != nil {
                submitButton.isEnabled = true
                return true
            }
        }
        submitButton.isEnabled = false
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enterFood.resignFirstResponder()
        return true
    }
}
extension FoodDiaryViewController {
    func sendFood(food: String){
        let (formattedDate, millis) = formattedDateAndMillis()
        // send presure
        if let user = DataHolder.userID {
            let fileName = "\(formattedDate)/\(millis)/\(user)+fooddiary.csv"
            // send data
            let string = "participant_id,foodname\n" +
            "\(user),\(food)"
            let data = string.data(using: .utf8)!
            KRProgressHUD.show(withMessage:NSLocalizedString("Sending data..", comment: ""), completion: nil)
            API.default.uploadFile(millis: millis, data: data, fileName:fileName, completion: { (result) in
                switch result {
                case let .Error(message):
                    KRProgressHUD.dismiss()
                    self.showError(message: message)
                case .Success:
                    self.sendImage(image: self.chosenImage!, formattedDate: formattedDate, millis: millis)
                }
            })
        }
    }
    func sendImage(image: UIImage, formattedDate: String, millis: Int64) {
        if let user = DataHolder.userID, let data = UIImageJPEGRepresentation(image, 0.65) {
            let fileName = "\(formattedDate)/\(millis)/\(user)+bloodpressure.jpg"
            // send image
            KRProgressHUD.show(withMessage:NSLocalizedString("Sending image..", comment: ""), completion: nil)
            API.default.uploadFile(millis: millis, data: data, fileName:fileName, completion: { (result) in
                KRProgressHUD.dismiss()
                print("result data sending: \(result)")
                switch result {
                case let .Error(message):
                    self.showError(message: message)
                case .Success:
                    AppDelegate.appDelegate?.scheduleFoodNotification()
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        else {
            KRProgressHUD.dismiss()
        }
        
    }

}
