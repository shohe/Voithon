//
//  RegistViewController.swift
//  Voithon
//
//  Created by SHOHE on 6/6/15.
//  Copyright (c) 2015 OhtaniShohe. All rights reserved.
//

import UIKit

class RegistViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var userPicButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.userPicButton.layer.cornerRadius = 10
        self.userPicButton.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapScreen(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    @IBAction func selectPhoto(sender: AnyObject) {
        pickImageFromLibrary()
    }
    
    @IBAction func pushRegist(sender: AnyObject) {
        // TODO ユーザ登録処理
        User.regist(nameField.text, pass: passField.text, imgFile: userPicButton.imageView?.image, success: { (isSuccess) -> Void in
            if isSuccess {
                // 画面遷移
                self.errorLabel.hidden = true
                let topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TopViewController") as! TopViewController
                self.presentViewController(topViewController, animated: false, completion: nil)
            } else {
                self.errorLabel.hidden = false
            }
            
        }) { (error) -> Void in
            println("regist error: \(error)")
        }
    }
    
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.userPicButton.setImage(image, forState: UIControlState.Normal)
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

}
