//
//  OfferTableViewCell.swift
//  JoBizz
//
//  Created by harold Armijo Leon on 12/12/2019.
//  Copyright © 2019 harold Armijo Leon. All rights reserved.
//

import UIKit

class OfferTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var desc: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
