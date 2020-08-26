//
//  ViewController.swift
//  MemeMe.1.0
//
//  Created by Maram Moh on 11/10/1441 AH.
//  Copyright © 1441 Maram Moh. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    
    
    @IBOutlet weak var imageviewPicker: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var libraryButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!

    
    override func viewDidLoad() {
        topTextField.borderStyle = .none
        bottomTextField.borderStyle = .none
        shareButton.isEnabled = false
        self.view.backgroundColor = UIColor.black
        topTextField.delegate = self
        bottomTextField.delegate = self
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        setupTextField(tf: topTextField, text: "TOP")
        setupTextField(tf: bottomTextField, text: "BOTTOM")
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    func setupTextField(tf: UITextField, text: String) {
        tf.defaultTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.strokeColor : UIColor.black,
            NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth : -4.0,
        ]
        tf.textColor = UIColor.white
        tf.tintColor = UIColor.white
        tf.textAlignment = .center
        tf.text = text
        tf.delegate = self
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        if textField == topTextField && (bottomTextField != nil) {
            textField.layer.borderWidth = 0
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder{
            view.frame.origin.y = -getKeyboardHeight(notification: notification)
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        view.frame.origin.y = 0
        
    }
    func chooseImageFromCameraOrPhoto(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
        shareButton.isEnabled = true
    }
    
    @IBAction func pickAnimage(_ sender: Any) {
        chooseImageFromCameraOrPhoto(source: .photoLibrary)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]){
        if  let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageviewPicker.image = image
            picker.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    var memeTextAttributes: [NSAttributedString.Key: Any]{
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  -3,
            NSAttributedString.Key.paragraphStyle:paragraph ]
        
        return memeTextAttributes
    }
    
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        chooseImageFromCameraOrPhoto(source: .camera)
    }
    
    func generateMemedImage() -> UIImage {
        navigationBar.isHidden = true
        toolBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationBar.isHidden = false
        toolBar.isHidden = false
        navigationController?.setToolbarHidden(false, animated: false)
        
        return memedImage
    }
   
    func save(_ memedImage: UIImage)  {
        // Create the meme
        let meme = Meme(topTextField: topTextField.text!, bottomTextField: bottomTextField.text!, imageviewPicker: imageviewPicker.image!, memedImage: memedImage)
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        
        print("it's working")
      
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        let memeImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if (success) {
                self.save(memeImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(activityViewController, animated: true,completion: nil)
        
        // Add it to the memes array in the Application Delegate
    }
}

