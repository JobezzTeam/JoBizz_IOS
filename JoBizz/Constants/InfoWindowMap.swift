//
//  InfoWindowMap.swift
//  JoBizz
//
//  Created by harold Armijo Leon on 09/12/2019.
//  Copyright © 2019 harold Armijo Leon. All rights reserved.
//

import Foundation

class InfoWindowMap {
    
    //MARK: Properties
    var title :String
    var body :String
    var desc: String?
    
    
    init(title: String, body: String, desc: String? = nil) {
        self.title = title
        self.body = body
        self.desc = desc
    }
    
}
