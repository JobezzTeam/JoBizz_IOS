//
//  ProfileApplicantViewController.swift
//  JoBizz
//
//  Created by harold Armijo Leon on 12/12/2019.
//  Copyright © 2019 harold Armijo Leon. All rights reserved.
//

import UIKit

class ApplicantProfileViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var photo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        photo.layer.masksToBounds = true
        photo.layer.cornerRadius = photo.bounds.width / 2
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
