//
//  ViewController.swift
//  JoBizz
//
//  Created by harold Armijo Leon on 02/12/2019.
//  Copyright © 2019 harold Armijo Leon. All rights reserved.
//

import UIKit
import os.log
import MongoSwift

class LoginViewController: UIViewController, UITextFieldDelegate {
    //MARK: Properties
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var userTile: UILabel!
    
    var user: UserType?
    var token: String?
    var timer: Timer?
    var connected: Bool = false
    var errorConnexion: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Handle the text field’s user input through delegate callbacks.
        email.delegate = self
        password.delegate = self
        
//        email.layer.cornerRadius = 10.0
//        email.layer.borderWidth = 2.0
//        email.layer.borderColor = UIColor.systemBackground.cgColor
        
        password.layer.cornerRadius = 10.0
        password.layer.borderWidth = 2.0
        password.layer.borderColor = UIColor.systemBackground.cgColor
        
        if let user = self.user {
            userTile.text = user.rawValue
        } else {
            os_log("user false.", log: OSLog.default, type: .debug)
        }
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    //MARK: Navigation
    // This method lets you configure a view controller before segue it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        os_log("enter in segue login. (maybe)", log: OSLog.default, type: .debug)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("in should perform \(identifier).")
        
        if identifier == "Login" {
            if token == nil {
                return false
            }
        }
        return true
    }

    //MARK: Actions
    @IBAction func connection(_ sender: UIButton) {
        os_log("in connection button.", log: OSLog.default, type: .debug)
        token = "true token"
//        if (token != nil) {
//            performSegue(withIdentifier: "Login", sender: nil)
//        }
        // call api....
        // verif connection.....
        
        
        if ManagerMongo.connexionIsValid == .Success {
            if user == UserType.CANDIDAT {
                connectIt(info: [
                    "ApplicantSpace", "ApplicantTabBarController"
                ], collection: "users", email: email.text ?? "", password: password.text ?? "")
            } else if user == UserType.EMPLOYER {
                connectIt(info: [
                    "EmployerSpace", "EmployerTabBarController"
                ], collection: "recruteurs", email: email.text ?? "", password: password.text ?? "")
            } else {
                fatalError("there is not UserType.")
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        if let owningNavigationController = navigationController {
            
            // The else block is called if the user is editing an existing meal. This also means that the meal detail scene was pushed onto a navigation stack when the user selected a meal from the meal list
            token = nil
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The LoginViewController is not inside a navigation controller.")
        }
    }
    
    //MARK: Methods
    @objc func fireTimer(timer: Timer) {
        
        if self.connected {
            
            print("opening \((timer.userInfo as! [String])[0]) --- > \((timer.userInfo as! [String])[1])")
            let storyboard = UIStoryboard(name: (timer.userInfo as! [String])[0], bundle: Bundle.main)
            let rightTabBar = storyboard.instantiateViewController(withIdentifier: (timer.userInfo as! [String])[1])
            
            // discard timer
            self.timer?.invalidate()
            present(rightTabBar, animated: true, completion: nil)
        } else if self.errorConnexion {
            self.timer?.invalidate()
            
            // create the alert
            let alert = UIAlertController(title: "Attention", message: "Votre mot de passe ou email est incorrect.", preferredStyle: UIAlertController.Style.alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func connectIt(info: [String], collection: String, email: String, password: String) {
        // refactoring this block
        let coll = ManagerMongo.mongoClient!.db("jobizz").collection(collection)
        
        //find user then connect him
        // if you don't find the user open a pop up
        coll.findOne([
            "email": email,
            "password": password
        ] as Document, options: nil) { [self] doc in
            switch doc {
            case .success(let doc):
                switch doc {
                case .none:
                    print("No document matches the provided query")
                    
                    self.errorConnexion = true
                case .some(let doc):
                    print("Successfully found document: \(doc)")
                    
                    self.connected = true
                }
            case .failure(let err):
                print("Failed to findOne: \(err)")
            }
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.fireTimer), userInfo: info, repeats: true)
        // end of refactoring
    }
    
}

