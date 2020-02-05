//
//  WelcomeViewController.swift
//  JoBizz
//
//  Created by harold Armijo Leon on 08/12/2019.
//  Copyright © 2019 harold Armijo Leon. All rights reserved.
//

import UIKit
import Foundation
import os.log
import MongoSwift
import StitchCore
import StitchRemoteMongoDBService

class WelcomeViewController: UIViewController {
    
    //MARK: Properties
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        self.navigationController?.isNavigationBarHidden = true
//        self.navigationController!.navigationBar.topItem!.title = ""
        
        // remove shadow of nav bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // globally remove shadow of nav bar
//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        // check a token if there is a token on login view
        // ..............
//        testMongo()
        ManagerMongo.initMongo() { valid in
            print("callback Manager \(valid)")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            case "LoginApplicant":
                guard let loginViewController = segue.destination as? LoginViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                 
                loginViewController.user = .CANDIDAT
                os_log("Login candidat.", log: OSLog.default, type: .debug)
        case "LoginEmployer":
            guard let loginViewController = segue.destination as? LoginViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
             
            loginViewController.user = .EMPLOYER
                os_log("Login employeur.", log: OSLog.default, type: .debug)
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: Actions
    @IBAction func goToApplicant(_ sender: UIButton) {
        
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        
//        guard let mainNavigationC = mainStoryboard.instantiateViewController(withIdentifier: "LoginNavigationController") as? LoginNavigationController else { return }
//        
//        present(mainNavigationC, animated: true, completion: nil)
    }
    
    @IBAction func unwindToWelcome(sender: UIStoryboardSegue) {
        // cause de button back in login was never bind to the exit action in the dock
        // the programme will never roll over here
        os_log("unwind from login.", log: OSLog.default, type: .debug)
        
        if let sourceVC = sender.source as? LoginViewController, let token = sourceVC.token {
            os_log("going to tab menu.", log: OSLog.default, type: .debug)
            print(token)
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    
            if sourceVC.user == .CANDIDAT {
                guard let rightTabBar = mainStoryboard.instantiateViewController(withIdentifier: "ApplicantTabBarController") as? ApplicantTabBarController else { return }
                
                _ = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(fireTimer), userInfo: rightTabBar, repeats: false)
//                self.parent?.present(rightTabBar, animated: true, completion: nil)
            } else {
                guard let rightTabBar = mainStoryboard.instantiateViewController(withIdentifier: "LoginNavigationController") as? LoginNavigationController else { return }
                
                present(rightTabBar, animated: true, completion: nil)
            }
            
        }
    }

    //MARK: Methods
    @objc func fireTimer(timer: Timer) {
        present(timer.userInfo as! UIViewController, animated: true, completion: nil)
    }
    
//    func testMongo() -> Any? {
//        var mongoClient: RemoteMongoClient? = nil
//        var client: StitchAppClient? = nil
//
//        do {
//            client = try Stitch.initializeDefaultAppClient(withClientAppID: "ios-app-gnwcl")
//
//            mongoClient = try client!.serviceClient(fromFactory: remoteMongoClientFactory, withName: "mongodb-atlas")
//        } catch {
//            print("Failed to initialize MongoDB Stitch iOS SDK: \(error)")
//            return nil
//        }
//
//        let coll = mongoClient!.db("jobizz").collection("annonces")
//
//        let credential = UserAPIKeyCredential.init(withKey: "SavGEcF7jFJ4kZ3EeUZkSCKFN57rDSJBTAUGJls27GVQpdIVX7EqrpombdBEMMPp")
//
//        client!.auth.login(withCredential: credential) { result in
//            switch result {
//            case .success(let user):
//
//                coll.updateOne(
//                    filter: ["owner_id": user.id],
//                    update: ["number": 42, "owner_id": user.id],
//                    options: RemoteUpdateOptions(upsert: true)
//                ) { result in
//                    switch result {
//                    case .success:
//                        coll.find().toArray({ result in
//                            switch result {
//                            case .success(let result):
//                                print("Found documents:")
//
//                                result.forEach({ document in
//                                    print(document.canonicalExtendedJSON)
//                                })
//                            case .failure(let error):
//                                print("Error in finding documents: \(error)")
//                            }
//                        })
//
//                    case .failure(let error):
//                        print("Error updating or inserting a document: \(error)")
//                    }
//                }
//
//            case .failure(let error):
//                print("Error in login: \(error)")
//
//            }
//        }
//
//
//        return mongoClient
//    }
}
