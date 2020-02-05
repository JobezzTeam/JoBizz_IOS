//
//  OfferViewController.swift
//  JoBizz
//
//  Created by harold Armijo Leon on 09/12/2019.
//  Copyright © 2019 harold Armijo Leon. All rights reserved.
//

import UIKit

class OfferViewController: UIViewController {
    

    //MARK: Properties
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var companyName: UILabel!
    
    var infoPost: InfoWindowMap?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        textView.layer.masksToBounds = false

        textView.layer.shadowRadius = 5.0
        textView.layer.shadowColor = UIColor.gray.cgColor
        textView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        textView.layer.shadowOpacity = 0.8
        
        if let infoPost = self.infoPost {
//            let textContent = NSMutableAttributedString()
//            for (index, desc) in allFormattedDescriptions.enumerated() {
//                let includeLinebreak = index < allFormattedDescriptions.count - 1
//                textContent.append(desc.attributeString(includeLineBreak: includeLinebreak))
//            }
//            textView.attributedText = textContent
            
//            print(infoPost.title)
//            print(infoPost.body)
//            print(infoPost.desc ?? "")
            let textContent = NSMutableAttributedString()
            let formated = Formatted(heading: "Résumé", descriptionText: infoPost.desc!)
            textContent.append(formated.attributeString(includeLineBreak: false))
            
            companyName.text = infoPost.title
            textView.attributedText = textContent
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Methods
    @IBAction func apply(_ sender: UIButton) {
        print("sending application to the back-end")
    }
    

}
