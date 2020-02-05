//
//  ApplicantToOffer.swift
//  JoBizz
//
//  Created by harold Armijo Leon on 12/12/2019.
//  Copyright © 2019 harold Armijo Leon. All rights reserved.
//

import Foundation
import UIKit

class ApplicantToOffer {
    
    //MARK: Properties
    var nom: String
    var desc: String?
    var photo: UIImage?
    
    
    //MARK: Initializer
    init?(nom: String, desc: String?, photo: UIImage?) {
        
        
        if nom.isEmpty {
            return nil
        }
        
        self.nom = nom
        self.desc = desc
        self.photo = photo
    }
    
}
