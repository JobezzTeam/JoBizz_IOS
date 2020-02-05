//
//  SignUpViewController.swift
//  JoBizz
//
//  Created by harold Armijo Leon on 10/12/2019.
//  Copyright © 2019 harold Armijo Leon. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    
    //MARK: Properties
    @IBOutlet weak var photoProfile: UIImageView!
    @IBOutlet weak var nom: UITextField!
    @IBOutlet weak var competencePro2: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    private var activeField: UITextField?
    private var lastOffset: CGPoint?
    private var keyboardHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        photoProfile.layer.masksToBounds = true
        photoProfile.layer.cornerRadius = photoProfile.bounds.width / 2
        
        let placeholderString =
            NSAttributedString.init(string: "nom*", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red:0.16, green:0.63, blue:0.88, alpha:1.0)])
        nom.attributedPlaceholder = placeholderString
        
        competencePro2.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }
    
    //MARK: Keyboard
    func keyboardWillShow(notification: NSNotification) {
        if keyboardHeight != nil {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            // so increase contentView's height by keyboard height
            UIView.animate(withDuration: 0.3, animations: {
                self.constraintContentHeight.constant += self.keyboardHeight!
            })
            // move if keyboard hide input field
            let distanceToBottom = self.scrollView.frame.size.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
            let collapseSpace = keyboardHeight! - distanceToBottom
            if collapseSpace < 0 {
                // no collapse
                return
            }
            // set new offset for scroll view
            UIView.animate(withDuration: 0.3, animations: {
                // scroll to the position above keyboard 10 points
                self.scrollView.contentOffset = CGPoint(x: self.lastOffset!.x, y: collapseSpace + 10)
            })
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.constraintContentHeight.constant -= self.keyboardHeight!
            self.scrollView.contentOffset = self.lastOffset!
        }
        keyboardHeight = nil
    }

}
