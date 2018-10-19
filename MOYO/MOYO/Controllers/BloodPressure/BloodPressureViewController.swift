//
//  BloodPressureViewController.swift
//  MOYO
//
//  Created by Corey S on 9/11/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit
import KRProgressHUD

class BloodPressureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var pressureValue: UIPickerView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    
    let picker = UIImagePickerController()
    let choicePicker = UIPickerView()
    //Content for picker views.
    let systolicData = [Int](30...299)
    let diastolicData = [Int](30...299)
    let pulseData = [Int](35...220)
    var chosenImage: UIImage? = nil {
        didSet {
            if chosenImage != nil{
                pressureValue.isUserInteractionEnabled = true
                pressureValue.alpha = 1
                if validatePressure() {
                    submitButton.isEnabled = true
                }
                else {
                    submitButton.isEnabled = false
                }
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Vitals", comment: "")
        picker.delegate = self
        pressureValue.alpha = 0.5
        pressureValue.delegate = self
        pressureValue.selectRow(90, inComponent: 0, animated: false)
        pressureValue.selectRow(30, inComponent: 1, animated: false)
        pressureValue.selectRow(25, inComponent: 2, animated: false)
    }
    
    @IBAction func photoFromLibrary(_ sender: UIButton) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func shootPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            picker.delegate = self
            present(picker, animated: false, completion: nil)
            
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
    func validatePressure() -> Bool{
        let selectedSysValue = systolicData[pressureValue.selectedRow(inComponent: 0)]
        let selectedDiaValue = diastolicData[pressureValue.selectedRow(inComponent: 1)]
        
        if selectedDiaValue >= selectedSysValue {
            return false
        }
        return true
    }
    
    @IBAction func submitData(_ sender: UIButton) {
        //Send picture and text?
        let selectedSysValue = systolicData[pressureValue.selectedRow(inComponent: 0)]
        let selectedDiaValue = diastolicData[pressureValue.selectedRow(inComponent: 1)]
        
        guard selectedDiaValue < selectedSysValue else {
            incorrectValues()
            return
        }
        let selectedPulse = pulseData[pressureValue.selectedRow(inComponent: 2)]
        guard let _ = chosenImage else {
            self.showAlert(title: NSLocalizedString("Please choose or take image", comment: ""), message: nil)
            return
        }
        sendPressure(systolic: selectedSysValue, diastolic: selectedDiaValue, pulse: selectedPulse)
    }
    
    
    func incorrectValues() {
        self.showAlert(title: NSLocalizedString( "Incorrect Values", comment: ""),
                       message: NSLocalizedString("Systolic value must be larger than diastolic value.", comment:""))
    }
    
    //MARK: - Delegates
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        cameraView.contentMode = .scaleAspectFit
        cameraView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return systolicData.count
        case 1:
            return diastolicData.count
        case 2:
            return pulseData.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if chosenImage != nil && validatePressure(){
            submitButton.isEnabled = true
        }
        else {
            submitButton.isEnabled = false
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(systolicData[row])
        case 1:
            return String(diastolicData[row])
        case 2:
            return String(pulseData[row])
        default:
            return ""
        }
        
    }
    func sendPressure(systolic: Int, diastolic: Int, pulse: Int){
        let (formattedDate, millis) = formattedDateAndMillis()
        // send presure
        if let user = DataHolder.userID {
            let fileName = "\(formattedDate)/\(millis)/\(user)+bloodpressure.csv"
            // send data
            let string = "participant_id,systolic_pressure,diastolic_pressure,pulse\n" +
            "\(user),\(systolic),\(diastolic),\(pulse)"
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
                    AppDelegate.appDelegate?.scheduleBloodNotification()
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        else {
            KRProgressHUD.dismiss()
        }
    }
}
